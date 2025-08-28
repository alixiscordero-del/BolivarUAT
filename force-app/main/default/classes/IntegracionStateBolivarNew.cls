public class IntegracionStateBolivarNew {
   public class InfoInput {
        @InvocableVariable(required=true)
        public String CallID;
        @InvocableVariable(required=false)
        public String Numero;  
        @InvocableVariable(required=false)
        public String EarliestStart;
        @InvocableVariable(required=false)
        public String DueDate;
        @InvocableVariable(required=false)
        public String Status;
        @InvocableVariable(required=false)
        public String Customer;
        @InvocableVariable(required=false)
        public String Region;
        @InvocableVariable(required=false)
        public String OpenDate;
        @InvocableVariable(required=false)
        public String WorkTypeId;
        @InvocableVariable(required=false)
        public String Duration;
        @InvocableVariable(required=false)
        public String ContactName;
        @InvocableVariable(required=false)
        public String ContactPhoneNumber;
        @InvocableVariable(required=false)
        public Double Latitude; 
        @InvocableVariable(required=false)
        public Double Longitude; 
        @InvocableVariable(required=false)
        public String Street;
        @InvocableVariable(required=false)
        public String City; 
        @InvocableVariable(required=false)
        public String Country;
        @InvocableVariable(required=false)
        public String CustomerEmail;
        @InvocableVariable(required=false)
        public String Continent;
        @InvocableVariable(required=false)
        public String ServiceResource;
        @InvocableVariable(required=false)
        public String Technician;   
        @InvocableVariable(required=false)
        public String BLStreet;    
        @InvocableVariable(required=false)
        public Double BLDestinationLatitude;
        @InvocableVariable(required=false)
        public String BLSchedulingType;
        @InvocableVariable(required=false)
        public String NumeroSiniestro;
        @InvocableVariable(required=false)
        public String CodigoRamo;
        @InvocableVariable(required=false)
        public String ProductoCodigo; 
        @InvocableVariable(required=false)
        public String CausaCodigo; 
        @InvocableVariable(required=false)
        public String ServCodigo;
        @InvocableVariable(required=false)
        public String Riesgo;
        @InvocableVariable(required=false)
        public String Proveedor;    
        @InvocableVariable(required=false)
        public String Observaciones;  
        @InvocableVariable(required=false)
        public String TelefonoAsegurado;    
        @InvocableVariable(required=false)
        public String ContactEmail; 
        @InvocableVariable(required=false)
        public String IsGuarantee;
        @InvocableVariable(required=false)
        public String NumeroOT;
        @InvocableVariable(required=false)
        public String Diagnostico;
        @InvocableVariable(required=false)
        public String Causa; 
        @InvocableVariable(required=false)
        public String SchedStartTime;
        @InvocableVariable(required=false)
        public String SchedEndTime; 
        @InvocableVariable(required=false)
        public String ServiceTerritory; 
        @InvocableVariable(required=false)
        public String CedulaAsegurado; 
        @InvocableVariable(required=false)
        public String LateStart;
        @InvocableVariable(required=false)
        public String ContactDate;
        @InvocableVariable(required=false)
        public String ConfirmationDate;
        @InvocableVariable(required=false)
        public String ScheduleDate;
        @InvocableVariable(required=false)
        public String DispatchDate; 
        @InvocableVariable(required=false)
        public String OnSiteDate; 
        @InvocableVariable(required=false)
        public String CompletionDate;  
        @InvocableVariable(required=false)
        public String Attachments;     
        @InvocableVariable(required=false)
        public String Comment;
        @InvocableVariable(required=false)
        public String TravelDate;
        @InvocableVariable(required=false)
        public String NameArea;
        @InvocableVariable(required=false)
        public String AssignmentStart;
        @InvocableVariable(required=false)
        public String AssignmentFinish;
        @InvocableVariable(required=false)
        public String IDEngineer;
        @InvocableVariable(required=false)
        public String NumeroDocumento; 
        @InvocableVariable(required=false)
        public String TipoDocumentoEnginner;
        @InvocableVariable(required=false)
        public String NumeroDocumentoEnginner;
        @InvocableVariable(required=false)
        public String TipoDocumentoPro;
        @InvocableVariable(required=false)
        public String IDResponsable;
        @InvocableVariable(required=false)
        public String CancellationReason;
        @InvocableVariable(required=false)
        public String ServiceAccepted;
        @InvocableVariable(required=false)
        public String TipificaSiab;
        @InvocableVariable(required=false)
        public String PlanReparacion;
        @InvocableVariable(required=false)
        public Decimal Kilometraje;
        @InvocableVariable(required=false)
        public String CostoTotalAtencion;
        @InvocableVariable(required=false)
        public String TipoDocumentoResponsable;
        @InvocableVariable(required=false)
        public String BLDestinationCity;
        @InvocableVariable(required=false)
        public String ObservationsAsset;
        @InvocableVariable(required=false)
        public String GuaranteeObservations;
        @InvocableVariable(required=false)
        public String GuaranteeReason;
        @InvocableVariable(required=false)
        public String ActividadesCantidades;
        @InvocableVariable(required=false)
        public String Signature;
        @InvocableVariable(required=false)
        public String VigenciaSOAT;
        @InvocableVariable(required=false)
        public String VigenciaTecno;
        @InvocableVariable(required=false)
        public String CausaDano;
        @InvocableVariable(required=false)
        public String DanosOcurridos;
        @InvocableVariable(required=false)
        public String ServicioNoestandar;
        @InvocableVariable(required=false)
        public String TiempoSoluccionDiccionario;
        @InvocableVariable(required=false)
        public String FailureReason;
        @InvocableVariable(required=false)
        public String FailConfirmed;
        @InvocableVariable(required=false)
        public String WorkOrderId;
        @InvocableVariable(required=false)
        public String NumeroDocumentoProveedor;
        @InvocableVariable(required=false)
        public String CancellationSubReason;
    }

    public class InfoResult {
        @InvocableVariable
        public String status;
        @InvocableVariable
        public String message;
        @InvocableVariable
        public String response; // Nuevo campo para almacenar la respuesta del servicio
    }

    @InvocableMethod(label='Create Update State Bolivar NEW' description='Update the State of SA to Bolivar NEW')
    public static List<InfoResult> UpdateWorkOrder(List<InfoInput> inputList) {
        IntegracionStateBolivarNew integracionStateBolivar = new IntegracionStateBolivarNew();
        List<InfoResult> resultList = new List<InfoResult>();
        
        for (InfoInput input : inputList) {
            InfoResult result = new InfoResult();
            Http http = new Http();      
            try {
                // Validar campos requeridos antes de proceder
                if (input.CallID == null) {
                    throw new IllegalArgumentException('CallID es obligatorio');
                }
                 // Validar y modificar el campo Numero para eliminar cualquier sufijo después del guion
                if (input.CallID != null && input.CallID.contains('_')) {
                    input.CallID = input.CallID.split('_')[0];
                }
                
                if (input.Kilometraje == null){
                    input.Kilometraje = 0 ;
                }
                if (input.Observaciones != null) {
    				input.Observaciones = input.Observaciones.replaceAll('\n', ' '); // Reemplaza '\n' con un espacio o elimínalo si prefieres.
				}
              
                String jsonCancel = '';
                String jsonFail = '';
                
                 // Validar y modificar el campo Status para corregir Canceled y generar JSON de cancelacion o fallo
                if (input.Status == 'Canceled'){
                    input.Status = 'Cancelled';
                    jsonCancel = '"CancellationReason_SO":{"@objectType": "TaskCancellationReason_SO", "Name": "'+ input.CancellationReason + '"},"CancellationSubReason_SO":{"@objectType": "TaskCancellationSubReason_SO", "Name": "'+ input.CancellationSubReason + '"},';
                }else if (input.Status == 'Failed'){
                    jsonFail = '"FailureReason":{"@objectType":"FailureReason","Name":"'+ input.FailureReason +'"},';
                }			
				String jsonAttach = '';
                	
				if (input.Attachments == null || String.isBlank(input.Attachments)) {
    				jsonAttach = '"Attachments":[],';
				} else {
    				jsonAttach = '"Attachments":[{"@objectType":"Attachment","FileName":"' + input.Attachments +
                 	'","FileIndex":0,"FileSize":null,"TimeAttached": "2024-04-18T15:40:00","UploadedBy": "erica.qa@AsistenciaD4","ExternalURL_SO": "'+ input.Attachments + 
                 	'"}],';
				}
                
                // Use the obtained token to make the work order creation request
                HttpRequest req = new HttpRequest();
                req.setEndpoint('https://os7cfipof2.execute-api.us-east-1.amazonaws.com/stage/siab_asistencia/api/v1/services/salesforce/authorization');
                req.setMethod('PUT');
                req.setHeader('Content-Type', 'application/json');
                req.setHeader('x-api-key', 'sp4Eu6SuH11SGLuemzEm15aSO2HgliaD3fntHWly');
                
                Integer BLlatInt = input.BLDestinationLatitude != null ? (Integer) (Double.valueOf(input.BLDestinationLatitude) * 100000) : null;
                Integer latInt = input.Latitude != null ? (Integer) (Double.valueOf(input.Latitude) * 100000) : null;
                Integer longInt = input.Longitude != null ? (Integer) (Double.valueOf(input.Longitude) * 100000) : null;
                
                String requestBody = '{"CompleteTask":{"Destination":"BolivarSIAB","CreatedBy": "erica.qa@AsistenciaD4","Task":{ "@objectType":"Task",';
                requestBody +=
                    '"CallID":"' + input.CallID + 
                    '","Number":"' + input.Numero +
                    '","EarlyStart": "'+ input.EarliestStart +
                    '","DueDate": "' + input.DueDate +
                    '","LateStart": "' + input.LateStart +
                    '","Status":{"@objectType":"TaskStatus","Name": "' + input.Status + 
                    '"},"Customer": "'+ input.Customer +
                    '","Region":{"@objectType":"Region","Name": "' + input.Region + 
                    '"},"OpenDate": "'+ input.OpenDate +
                    '","ContactDate": "'+ input.ContactDate +
                    '","ConfirmationDate": "'+ input.ConfirmationDate +
                    '","TaskType":{"@objectType":"TaskType","Name": "' + input.WorkTypeId + 
                    '"},"Duration": ' + input.Duration + 
                    ',"AppointmentStart": "' + input.SchedStartTime + 
                    '","AppointmentFinish": "' + input.SchedEndTime +
                    '","ContactName":"'+input.ContactName +
                    '","ContactPhoneNumber":"'+input.ContactPhoneNumber +
                    '","Latitude":'+ (latInt != null ? latInt : 0) +
                    ',"Longitude":'+ (longInt != null ? longInt : 0) +
                    ',"Street":"'+ input.Street +
                    '","City": "'+ input.City +
                    '","CountryID":{"@objectType": "Country","Name": "' + input.Country + 
                    '"},"CustomerEmail":"' +input.CustomerEmail +
                    '","DisplayStatus":{"@objectType":"DisplayStatus","Name": "' + input.Status + 
                    '"},"DispatchDate": "' + input.DispatchDate +
                    '","ScheduleDate": "' + input.ScheduleDate +
                    '","OnSiteDate": "' + input.OnSiteDate +
                    '","Comment":"' + input.Comment + 
                    '","Signature":"' + input.Signature + 
                    '","TravelDate":"' + input.TravelDate + 
                    '","CompletionDate": "' + input.CompletionDate +
                    '", '+ jsonAttach + '"Area":{"@objectType": "Area","Name": "' + input.NameArea + 
                    '"},"Continent":{"@objectType": "Continent","Name": "' + input.Continent +
                    '"},"AssignmentStart":"' + input.AssignmentStart + 
                    '","AssignmentFinish": "' + input.AssignmentFinish +
                    '","AssignedEngineer":{"@objectType": "Engineer","Name": "' + input.ServiceResource +
                    '","ID":"' + input.IDEngineer + 
                    '","Proveedor":{"@objectType": "Proveedor","Name": "' + input.Proveedor + 
                    '","TipoDocumento":{"@objectType": "TipoDocumento","Name": "'+ input.TipoDocumentoPro +
                    '"},"NumeroDocumento":"' + input.NumeroDocumentoProveedor + 
                    '"},"TipoDocumento":{"@objectType": "TipoDocumento","Name": "'+ input.TipoDocumentoEnginner +
                    '"},"Responsable":{"@objectType": "Engineer","Name": "' + input.Technician + 
                    '","ID": "'+ input.IDResponsable +
                    '","TipoDocumento":{"@objectType": "TipoDocumento","Name": "'+ input.TipoDocumentoResponsable +
                    '"}}},'+ jsonCancel +
                    '"ServiceAccepted":"'+input.ServiceAccepted +
                    '","BLStreet":"'+input.BLStreet +
                    '","BLDestinationLatitude":' + (BLlatInt != null ? BLlatInt : 0) +
                    ',"BLSchedulingType":{"@objectType": "BLSchedulingType","Name": "' + input.BLSchedulingType + 
                    '"},"NumeroSiniestro":"'+input.NumeroSiniestro +
                    '","TipificaSiab":{"Key": "' + input.TipificaSiab + 
                    '"},"RamoCodigo":"'+input.CodigoRamo +
                    '","ProductoCodigo":"'+input.ProductoCodigo +
                    '","CausaCodigo":"'+ input.CausaCodigo+ 
                    '","ServCodigo":"'+ input.ServCodigo+
                    '","Riesgo":"'+ input.Riesgo+
                    '","PlanReparacion":"'+ input.PlanReparacion +
                    '","VigenciaSOAT":"'+ input.VigenciaSOAT +
                    '","VigenciaTecnomecanica":"'+ input.VigenciaTecno +
                    '","CausaDano":"'+ input.CausaDano +
                    '","DanosOcurridos":"'+ input.DanosOcurridos + 
                    '","CostoTotalAtencion":"'+ input.CostoTotalAtencion +
                    '","TerceroInvolucrado":[],"AttachmentsOpen":[],"AttachementClose":[],"Proveedor":{"@objectType": "Proveedor","Name": "' + input.Proveedor +
                    '","TipoDocumento":{"@objectType": "TipoDocumento","Name": "'+ input.TipoDocumentoPro +
                    '"},"NumeroDocumento":"' + input.NumeroDocumentoProveedor +
                    '"},"Observaciones":"'+input.Observaciones +
                    '","TelefonoAsegurado":"'+input.TelefonoAsegurado +
                    '","BLDestinationCity":"'+input.BLDestinationCity +
                    '","ContactEmail":"'+input.ContactEmail +
                    '","IsGuarantee":"'+input.IsGuarantee +
                    '","ObservationsAsset":"'+input.ObservationsAsset +
                    '","GuaranteeObservations":"'+input.GuaranteeObservations +
                    '","NumeroOT":"'+input.NumeroOT +
                    '","GuaranteeReason":{"Key": "'+ input.GuaranteeReason +
                    '"},"CedulaAsegurado":"'+input.CedulaAsegurado +
                    '","Diagnostico":"'+input.Diagnostico +
                    '","Causa":"'+input.Diagnostico + 
                    '","ActividadesCantidades":"'+input.ActividadesCantidades + 
                    '","TiempoSoluccionDiccionario":{"Key": "'+ input.TiempoSoluccionDiccionario +
                    '"},"ServiceTypes":[],"ServicioNoestandarizado":"'+input.ServicioNoestandar +
                    '","Amount":"'+ input.Kilometraje + 
                    '","ComplementStatus":{"Key":-1},'+ jsonFail +
                    '"FailConfirmed":"'+ input.FailConfirmed +'","AdditionalServicesListTask":[]}}}';
                
                req.setBody(requestBody);
                System.debug('Peticion a enviar a Bolivar: ' + requestBody);
                
                HttpResponse res = http.send(req);
                // Procesar la respuesta de Bolivar para la actualizacion de los diferentes estados
                if (res.getStatusCode() == 200) {
                    // Éxito, manejar la respuesta
                    String responseBody = res.getBody();
                    System.debug('Respuesta de Bolivar Exito actualizacion de los estados : ' + responseBody);
                    // Set the result status and message
                    result.status = 'Success';
                    result.message = 'SA Updated successfully.';
                    result.response = responseBody;
                } else {
                    // Manejar el caso en que la solicitud no sea exitosa
                    result.status = 'Error';
                    result.message = 'Failed to update Service Appointment.';
                    result.response = res.getBody();
                    System.debug('Respuesta de Bolivar Fallo Update SA : ' + result.response);
                }
            } catch (Exception e) {
                // Manejo de excepciones
                result.status = 'Error';
                result.message = 'Exception occurred: ' + e.getMessage();
                System.debug('Respuesta de Bolivar Exception: ' + result.message);
            }
            
            System.debug('Respuesta de Bolivar Result: ' + result);
            resultList.add(result);
        }
        
        return resultList;
    } 
}