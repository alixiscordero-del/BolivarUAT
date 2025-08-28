@RestResource(urlMapping= '/api/crearCaso')
global with sharing class ServicioCreacionCaso {
    
    global class CrearCaseRequest { 
        public String CodigoProducto;
        public String CodigoRamo;
        public String RamoSIAB;
        public String ProductoSIAB;
        public String NumeroPoliza;
        public String CodigoCausa; 
        public String ProductoBolivar; 
        public String EstadoLlamada;
        public String CLV; 
        public String Origen; 
        public String Severidad; 
        public Boolean Cobertura360; 
        public String Observaciones; 
        public String TipoAsistencia;
                                  
        public String Riesgo; 
        public String NumeroSiniestro;
        public String OpcionCobertura; 
        public String NumeroPlaca; 
        public String NombreTomador;
        public String CorreoTomador;
                                   
        public String DocumentoTomador;
        public String TelefonoTomador; 
        public String NombreUbicacion;
        public String CodigoUbicacion;
        public String CausaSIAB ;
        public String LineaNegocio;
        public String Status; 
        public Boolean CreatedByIntegration;
    }
    
    @HttpPost 
    global static String crearCase(CrearCaseRequest request) {
        // Obtener el ID del RecordType
        Id recordTypeId = getRecordTypeId(request.CodigoRamo);
        
        // Verificar si se encontró el RecordType
        if (recordTypeId == null) {
            return 'Error: No se encontró un RecordType asociado al código de ramo: ' + request.CodigoRamo;
        }
        
        // Crear o actualizar el contacto
        Contact contacto = crearActualizarContacto(request);
        
        // Crear un nuevo caso con el RecordType obtenido
        return crearNuevoCaso(request, contacto, recordTypeId);
    }
    
    // Método para crear o actualizar un contacto
    global static Contact crearActualizarContacto(CrearCaseRequest request) {
        Contact[] contactosExistentes = [SELECT Id, LastName, CoIT_N_Documento__c, Email, Phone 
                                          FROM Contact 
                                          WHERE CoIT_N_Documento__c = :request.DocumentoTomador LIMIT 1];
        
        // Verificar si se encontró un contacto existente
        if (!contactosExistentes.isEmpty()) {
            // Actualizar los campos del contacto existente con los nuevos valores proporcionados
            Contact contactoExistente = contactosExistentes[0];
            contactoExistente.LastName = request.NombreTomador;
            contactoExistente.Email = request.CorreoTomador;
            contactoExistente.Phone = request.TelefonoTomador;
            // Actualizar otros campos del contacto si es necesario...
            
            // Actualizar el contacto existente
            update contactoExistente;
            
            return contactoExistente;
        } else {
            // Crear un nuevo contacto utilizando el nombre del tomador y el número de documento
            Contact nuevoContacto = new Contact(
                LastName = request.NombreTomador,
                CoIT_N_Documento__c = request.DocumentoTomador,
                Email = request.CorreoTomador,
                Phone = request.TelefonoTomador,
                AccountId = '0018M00000SM5EPQA1'
                // Otros campos del contacto que puedan ser necesarios...
            );
            
            // Insertar el nuevo contacto
            insert nuevoContacto;
            
            return nuevoContacto;
        }
    }
    
    // Método para crear un nuevo caso con el RecordType proporcionado
    global static String crearNuevoCaso(CrearCaseRequest request, Contact contacto, Id recordTypeId) {
        // Crear un nuevo registro de caso
        Case nuevoCaso = new Case(
            CoIT_Codigo_del_Producto__c = request.CodigoProducto,
            CoIT_Codigo_del_Ramo__c = request.CodigoRamo,
            CoIT_Ramo_SIAB__c = request.RamoSIAB,
            CoIT_Producto_SIAB__c= request.ProductoSIAB,
            CoIT_Numero_de_la_Poliza__c = request.NumeroPoliza,
            CoIT_Codigo_Causa__c = request.CodigoCausa,
            CoIT_Producto_Bolivar__c = request.ProductoBolivar,
            CoIT_Estado_de_la_Llamada__c = request.EstadoLlamada,
            CoIT_CLV__c = request.CLV,
            CoIT_Origen__c = request.Origen,
            CoIT_Click_Severity__c = request.Severidad,
            CoIT_Cobertura_360__c = request.Cobertura360,
            CoIT_Observaciones__c = request.Observaciones,
            CoIT_Tipo_de_Asistencia__c = request.TipoAsistencia,
            CoIT_Riesgo__c = request.Riesgo,
            CoIT_Numero_del_Siniestro__c = request.NumeroSiniestro,
            CoIT_Opcion_de_Cobertura__c = request.OpcionCobertura,
            CoIT_Numero_de_Placa__c = request.NumeroPlaca,
            CoIT_Nombre_Tomador__c = contacto.LastName,
            CoIT_Correo_Tomador__c = contacto.Email,
            CoIT_Documento_Tomador__c = contacto.CoIT_N_Documento__c,
            CoIT_Telefono_Tomador__c = contacto.Phone,
            CoIT_Nombre_Ubicacion__c = request.NombreUbicacion,
            CoIT_Codigo_Ubicacion__c = request.CodigoUbicacion,
            CoIT_Linea_de_Negocio__c = request.LineaNegocio,
            CoIT_Causa_SIAB__c = request.CausaSIAB,
            CoIT_Was_Created_by_Integration__c = request.CreatedByIntegration,
            Status = 'New',
            RecordTypeId = recordTypeId,
            ContactId = contacto.Id,
            CoIT_Management_Type__c = 'Gestión Automatica',
            AccountId = '0018M00000SM5EPQA1'// Asumiendo un estado por defecto para el caso
        );
        
        // Insertar el nuevo caso
        try {
            insert nuevoCaso;
            return 'Caso creado con éxito. ID: ' + nuevoCaso.Id + '. Contacto creado/actualizado: ' + contacto.Id;
        } catch (Exception e) {
            return 'Error al crear el caso: ' + e.getMessage();
        }
    }
    
    // Método para obtener el ID del RecordType basado en el código de ramo
    public static Id getRecordTypeId(String codigoRamo) {
        String recordTypeName;
        
        // Determinar el nombre del RecordType según el código de ramo
        if (codigoRamo == '10'|| codigoRamo == '70' || codigoRamo == '130'|| codigoRamo == '400' ) {
            recordTypeName = 'Autos';
        } else if (codigoRamo == '100' || codigoRamo == '120' ) {
            recordTypeName = 'Hogares';
        } else {
            recordTypeName = 'Master';
        }
        
        // Realizar una consulta SOQL para obtener el Id del RecordType utilizando el nombre del RecordType
        RecordType recordType = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND DeveloperName = :recordTypeName LIMIT 1];
        
        return (recordType != null) ? recordType.Id : null;
    }
}