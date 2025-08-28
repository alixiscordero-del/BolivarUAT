@RestResource(urlMapping= '/api/crearWorkOrder')
global with sharing class ServicioCreacionWorkOrder {
    
    global class CrearWorkOrderRequest {
        public String RequerimientosCliente;
        public DateTime StartDate;
        public String Street;
        public String City; 
        public Decimal Latitude;
        public String TipoAgendamiento;
        public Decimal Longitude;
        public String State;
        public String Country;
        public String DireccionDestino;
        public String CiudadDestino;
        public String WorkTypeId;
        public Double LatitudeDestino;
        public Double LongitudeDestino;
        public String DestinationCity;
        public String DirInicioComplemento;
        public String InquietudServicio;
        public Integer CodigoServicio;
        public String DirDestinoComplemento;
        public String Distrito;
        public String Color;
        public String NumeroPlaca;
        public String ModeloAutomovil;
        public Boolean Garantia;
        public String Region;
        public Boolean Critical;
        public String NumeroSiniestro;
        public String NecesidadCliente;
        public String DocumentoAsegurado;
        public String EmailAsegurado;
        public String NombreAsegurado;
        public String TelefonoAsegurado;
        public String NombreSolicitante;
        public String TelefonoSolicitante;
        public String EmailSolicitante;
        public String NumeroAutorizacion;
        public String PhoneNumbers;
        public Decimal CodServicioCL;
        public Boolean CreatedByIntegration;
        public String Status;
        public String Marca;
    }
    
    @HttpPost 
    global static String crearWorkOrder(CrearWorkOrderRequest request) {
        // Validar que el nombre del solicitante no esté vacío
        if (String.isBlank(request.NombreAsegurado)) {
            return 'El nombre del solicitante es obligatorio.';
        }

        // Validar que el documento del asegurado no esté vacío
        if (String.isBlank(request.DocumentoAsegurado)) {
            return 'El número de documento del asegurado es obligatorio.';
        }

        try {
            // Llamar al servicio de Google Maps para obtener la ciudad y el estado
            String responseBody = GoogleMapsService.getLocationData(request.LatitudeDestino, request.LongitudeDestino);
            
            // Inicializar valores predeterminados
            String city = 'Unknown City';
            String state = 'Unknown State';

            // Si la respuesta no es nula
            if (responseBody != null) {
                // Deserializar el JSON y extraer la ciudad y el estado
                Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
                List<Object> results = (List<Object>) jsonResponse.get('results');
                
                if (!results.isEmpty()) {
                    for (Object result : results) {
                        Map<String, Object> resultMap = (Map<String, Object>) result;
                        List<Object> addressComponents = (List<Object>) resultMap.get('address_components');

                        for (Object component : addressComponents) {
                            Map<String, Object> componentMap = (Map<String, Object>) component;
                            List<Object> types = (List<Object>) componentMap.get('types');

                            // Buscar el componente 'locality' para obtener la ciudad
                            if (types.contains('locality')) {
                                city = (String) componentMap.get('long_name');
                            }

                            // Buscar el componente 'administrative_area_level_1' para obtener el estado
                            if (types.contains('administrative_area_level_1')) {
                                state = (String) componentMap.get('long_name');
                            }
                        }
                    }
                }
            }

            // Buscar contacto existente o crear uno nuevo
            Contact[] contactosExistentes = [SELECT Id, LastName, CoIT_N_Documento__c, Email, Phone FROM Contact WHERE CoIT_N_Documento__c = :request.DocumentoAsegurado LIMIT 1];
            
            if (!contactosExistentes.isEmpty()) {
                // Actualizar contacto existente
                Contact contactoExistente = contactosExistentes[0];
                contactoExistente.LastName = request.NombreAsegurado;
                update contactoExistente;
                return crearOrdenDeTrabajo(request, contactoExistente, city, state);
            } else {
                // Crear un nuevo contacto
                Contact nuevoContacto = new Contact(
                    LastName = request.NombreAsegurado,
                    CoIT_N_Documento__c = request.DocumentoAsegurado,
                    Email = request.EmailAsegurado,
                    Phone = request.TelefonoAsegurado
                );
                insert nuevoContacto;
                return crearOrdenDeTrabajo(request, nuevoContacto, city, state);
            }
        } catch (Exception e) {
            return 'Error al procesar la solicitud: ' + e.getMessage();
        }
    }

    private static String crearOrdenDeTrabajo(CrearWorkOrderRequest request, Contact contacto, String city, String state) {
        Id serviceTerritoryId = obtenerServiceTerritoryIdPorNombre(request.Distrito);
        DateTime StartDateGMT = DateTime.newInstanceGMT(request.StartDate.year(), request.StartDate.month(), request.StartDate.day(), request.StartDate.hour(), request.StartDate.minute(), request.StartDate.second());
        DateTime StartDateColombia = convertirAGMTMinus5(StartDateGMT);

        WorkOrder nuevaOrden = new WorkOrder(
            CoIT_Requerimientos_del_cliente__c = request.RequerimientosCliente,
            StartDate = StartDateColombia,
            Street =  request.Street,
            City =  request.City,
            Country = request.Country,
            State = request.State,
            Latitude =  request.Latitude,
            Longitude =  request.Longitude,
            CoIT_Address__Street__s =  request.DireccionDestino,
            CoIT_Address__City__s =  request.CiudadDestino, 
            CoIT_Address__CountryCode__s =  'CO',
            WorkTypeId =  request.WorkTypeId,
            CoIT_Address__Latitude__s =  request.LatitudeDestino,
            CoIT_Address__Longitude__s =  request.LongitudeDestino,
            CoIT_WOM_Scheduling_type__c =  request.TipoAgendamiento,
            CoIT_Complemento_Direccion_Inicio__c =  request.DirInicioComplemento,
            CoIT_Inquietud_del_Servicio__c =  request.InquietudServicio, 
            CoIT_Codigo_Servicio__c =  request.CodigoServicio, 
            CoIT_Direccion_Destino_Complemento__c =  request.DirDestinoComplemento, 
            CoIT_Distrito__c =  request.Distrito, 
            CoIT_Color__c =  request.Color, 
            CoIT_Numero_de_Placa__c =  request.NumeroPlaca, 
            CoIT_Modelo_Automovil__c =  request.ModeloAutomovil,  
            CoIT_Garantia__c =  request.Garantia, 
            CoIT_Critical__c =  request.Critical, 
            CoIT_Numero_Siniestro__c =  request.NumeroSiniestro,
            CoIT_Necesidad_Cliente__c =  request.NecesidadCliente, 
            CoIT_Documento_Asegurado__c =  contacto.CoIT_N_Documento__c, 
            CoIT_Nombre_Asegurado__c =  contacto.LastName, 
            CoIT_Email_Asegurado__c =  contacto.Email, 
            CoIT_Telefono_Asegurado__c =  contacto.Phone, 
            CoIT_Nombre_Solicitante__c =  request.NombreSolicitante,
            CoIT_Telefono_Solicitante__c =  request.TelefonoSolicitante,
            CoIT_Email_Solicitante__c =  request.EmailSolicitante,
            CoIT_Authorization_Number__c =  request.NumeroAutorizacion,
            CoIT_Cod_Clase_Servicio__c =  request.CodServicioCL,
            CoIT_Lista_de_Numeros__c =  request.PhoneNumbers,
            CoIT_WOM_WasCreatedByIntegration__c = request.CreatedByIntegration,
            Status = 'New',
            CoIT_Region__c = request.Region,
            ServiceTerritoryId = serviceTerritoryId,
            ContactId = contacto.Id,
            CoIT_Partner_Location__CountryCode__s =  'CO',
            AccountId = '0018M00000SM5EPQA1', //  Seguros Bolivar
            CoIT_Marca__c = request.Marca
        );

        try {
            insert nuevaOrden;
            return 'Orden de Trabajo creada con éxito. ID: ' + nuevaOrden.Id + '. Contacto creado/actualizado: ' + contacto.Id + '. Territorio de Servicio Asignado: ' + serviceTerritoryId;
        } catch (Exception e) {
            return 'Error al crear la Orden de Trabajo: ' + e.getMessage();
        }
    }

    private static DateTime convertirAGMTMinus5(DateTime fechaGMT) {
        return fechaGMT.addHours(+10);
    }

    public static Id obtenerServiceTerritoryIdPorNombre(String nombreServiceTerritory) {
        ServiceTerritory[] territories = [SELECT Id FROM ServiceTerritory WHERE Name = :nombreServiceTerritory LIMIT 1];
        return territories.isEmpty() ? null : territories[0].Id;
    }
}