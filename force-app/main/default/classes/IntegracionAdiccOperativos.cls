public class IntegracionAdiccOperativos {
    
    public class InfoInput{
        
      @InvocableVariable(required=false)
      public String key; 
      @InvocableVariable(required=false)
      public String CallID; 
      @InvocableVariable(required=false)
      public String Numero;
      @InvocableVariable(required=false)
      public String Status; 
      @InvocableVariable(required=false)
      public String CustomerName; 
      @InvocableVariable(required=false)
      public String TasktypeName;
      @InvocableVariable(required=false)
      public String AttachmentName;
      @InvocableVariable(required=false)
      public String FileSize;
      @InvocableVariable(required=false)
      public String FileURL;
      @InvocableVariable(required=false)
      public String AssigmentStart;
      @InvocableVariable(required=false)
      public String AssigmentFinish;
      @InvocableVariable(required=false)
      public String EngineerName;
      @InvocableVariable(required=false)
      public String CityEngineer;
      @InvocableVariable(required=false)
      public String ProveedorName;
      @InvocableVariable(required=false)
      public String TipoDocumentoProv;
      @InvocableVariable(required=false)
      public String NumeroDocumentoProv;
      @InvocableVariable(required=false)
      public String NumeroDocumentoEngine;
      @InvocableVariable(required=false)
      public String NameEngineer;
      @InvocableVariable(required=false)
      public String DocumentoEngineer;
      @InvocableVariable(required=false)
      public String TipoDocEnginner;
      @InvocableVariable(required=false)
      public String TipoAgendamiento;
      @InvocableVariable(required=false)
      public String WorkOrderId;
      @InvocableVariable(required=false)
      public String ExternalKey;
      @InvocableVariable(required=false)
      public String ExternalURL;
        
        
    }
    public class InfoResult {
        @InvocableVariable
        public String status;
        @InvocableVariable
        public String message;
        @InvocableVariable
        public String response; // Nuevo campo para almacenar la respuesta del servicio
    }
    
    public class ProductConsumeManager {
        
       	List<Map<String, Object>> productConsumesDetails = new List<Map<String, Object>>(); 
     
        public List<Expense> getAllProductConsumes( Id workOrderId){
            List<Expense> productConsumes = [
              SELECT Id, CoIT_ExpenseType_Id__c,CoIT_Units__c, CoIT_Expense_SIAB_Id__c FROM Expense WHERE WorkOrderId = :workOrderId

            ];       

        return productConsumes;
            
       }
    }
    
    
    
    @InvocableMethod(label='Create Update State Bolivar' description='Update the State of SA to Bolivar')
    public static List<InfoResult> UpdateWorkOrder(List<InfoInput> inputList) {
        ProductConsumeManager manager = new ProductConsumeManager(); 
        IntegracionAdiccOperativos integracionAdiccOperativosBolivar = new IntegracionAdiccOperativos();
        List<InfoResult> resultList = new List<InfoResult>();
        
      	InfoResult result = new InfoResult();
      	Http http = new Http();
        
        
      try {    
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://ambientepruebas.asistenciabolivar.com/AsistenciaServicios/siab/IntegraClick-Cls/adicionales');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        
        // Inicializar el mapa de productos fuera del bucle
        Map<Id,CoIT_Expense_Type__c> expenseTypeMap = new Map<Id,CoIT_Expense_Type__c>([SELECT Id, Name, CoIT_External_SIAB_Id__c FROM CoIT_Expense_Type__c]);


		List<String> additionalServicesJsonList = new List<String>();

		// Iterar sobre los elementos de inputList
		for (InfoInput input : inputList) {
    		// Obtener los consumos de productos para la orden de trabajo actual
    		List<Expense> productConsumes = manager.getAllProductConsumes(input.WorkOrderId);
    
    		// Iterar sobre los consumos de productos
    		for (Expense productConsume : productConsumes) {
          		// Obtener el nombre del producto basado en el ID del producto
        		String productName =  expenseTypeMap.containsKey(productConsume.CoIT_ExpenseType_Id__c) ?  expenseTypeMap.get(productConsume.CoIT_ExpenseType_Id__c).Name : '';
        		String productCode =  expenseTypeMap.containsKey(productConsume.CoIT_ExpenseType_Id__c) ?  expenseTypeMap.get(productConsume.CoIT_ExpenseType_Id__c).CoIT_External_SIAB_Id__c: '';
                
        		// Crear el mapa de detalles del servicio adicional
        		Map<String, Object> additionalServiceMap = new Map<String, Object>();
        		additionalServiceMap.put('@objectType', 'additionalServiceList');
        		Map<String, Object> additionalMap = new Map<String, Object>();
        		additionalMap.put('@objectType', 'Additional');
        		additionalMap.put('Name', productName); // Utilizar el nombre del producto
        		additionalMap.put('ID', ProductCode);
        		additionalServiceMap.put('Additional', additionalMap);
        		additionalServiceMap.put('units', productConsume.CoIT_Units__c); // Convertir a cadena
        		String additionalServiceJson = JSON.serialize(additionalServiceMap);
        
        // Agregar el JSON a la lista
        additionalServicesJsonList.add(additionalServiceJson);
    }

            
            String additionalServicesJson = '[' + String.join(additionalServicesJsonList,',') + ']';
            
            System.debug('JSON Product Consumed' + additionalServicesJson);
            
            String requestBody = '{"OperativosAdicionales":{"Destination":"BolivarCLS","CreatedBy":"COIT_Implementer@AsistenciaD4",';
            requestBody = requestBody +
                '"Task":{"@ObjectType":"Task","Key":"' + input.key + 
                '","CallID":"' + input.CallID +
                '","Number":"' + input.Numero +
                '","Status": {"@objectType":"TaskStatus","Name":"' + input.Status + 
                '"},"Customer": "' + input.CustomerName + 
                '","TaskType": {"@objecType":"Tasktype","Name":"' + input.TasktypeName +
                '"},"Attachments":[{"@ObjectType":"Attachment","FileName":"'+ input.AttachmentName + 
                '","FileSize":"","FileType":{"Key":"-1"},"ExternalKey_SO":"","ExternalURL_SO":""}],"AssignmentStart": "'+ input.AssigmentStart +
                '","AssigmentFinish": "'+ input.AssigmentFinish  + 
                '","AssignedEngineer":{"@objectType":"Engineer","Name":"'+ input.EngineerName + 
                '","City":"'+ input.CityEngineer + 
                '","Proveedor":{"@objectType":"Proveedor","Name":"' + input.ProveedorName + 
                '","TipoDocumento":{"@objectType":"TipoDocumento","Name":"' + input.TipoDocumentoProv + 
                '"},"NumeroDocumento":"' + input.NumeroDocumentoProv + 
                '"},"TipoDocumento":{"@objectType":"TipoDocumento","Name":"'+ input.TipoDocEnginner + 
                '"},"Responsable":{"@objectType":"Engineer","Name":"' + input.NameEngineer + 
                '","ID":"'+ input.DocumentoEngineer + 
                '","TipoDocumento":{"@objectType":"TipoDocumento","Name":"'+ input.TipoDocEnginner + 
                '"}}},"BLSchedulingType":{"@objectType":"BLSchedulingType","Name":"'+ input.TipoAgendamiento + 
                '"},"AttachmentsOpen":[{"@objectType":"Attachment","FileName":"'+ input.AttachmentName + 
                '","FileSize":"","FileType":{"Key":-1},"ExternalKey_SO":"'+ input.ExternalKey +
                '","ExternalURL_SO":"'+ input.ExternalURL + 
                '"}],"Proveedor":{"@objectType":"Proveedor","Name":"'+ input.ProveedorName +
                '","TipoDocumento":{"@objectType":"TipoDocumento","Name":"'+ input.TipoDocumentoProv +
                '"},"NumeroDocumento":"' + input.NumeroDocumentoProv + 
                '"},"AttachmentOC":[],"additionalserviceslisttask":' + additionalServicesJson + '}}}';
            
            req.setBody(requestBody);
            String debugFilePath = 'debugResponse.txt';
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
        }
      }catch(Exception e){
            // Manejo de excepciones
    			result.status = 'Error';
    			result.message = 'Exception occurred: ' + e.getMessage();
                
           
            	System.debug('Respuesta de Bolivar Exception: ' + result.message);
                
        }  
        System.debug('Respuesta de Bolivar Result: ' + result);
        resultList.add(result);
        
        return resultList;
    }
}