public class IntegracionSMS {

    public class InfoInput {
        @InvocableVariable(required=false)
        public String NameNotification;
        @InvocableVariable(required=false)
        public String KeyTask;
        @InvocableVariable(required=false)
        public String CallID;
        @InvocableVariable(required=false)
        public String SMSText;
        @InvocableVariable(required=false)
        public String CustomerPhoneNumber;
        @InvocableVariable(required=false)
        public String MissionURL;
        @InvocableVariable(required=false)
        public String MissionID;
        @InvocableVariable(required=false)
        public String MisssionUpdate;
        @InvocableVariable(required=false)
        public String PhoneNumbers;
        @InvocableVariable(required=false)
        public Boolean IsUpdatedSMSTextLM;
        @InvocableVariable(required=false)
        public Boolean IsUpdatedSMSTextAsistencia;
        @InvocableVariable(required=false)
        public Boolean IsUpdatedSMSTextConductorEleg;
        @InvocableVariable(required=false)
        public Boolean IsUpdatedSMSTextGruas;
        @InvocableVariable(required=false)
        public Boolean IsUpdatedSMSTextCerrajeria;
        @InvocableVariable(required=false)
        public Boolean IsUpdatedSMSTextConductorF;
        @InvocableVariable(required=false)
        public Boolean IsUpdatedSMSTextCarroT;
        @InvocableVariable(required=false)
        public Boolean IsUpdatedSMSTextAsistenciaGN;
        @InvocableVariable(required=false)
        public String ServiceName;
        @InvocableVariable(required=false)
        public String TaskDate;
        @InvocableVariable(required=false)
        public String StartDate;
        @InvocableVariable(required=false)
        public String AssignedEngineer;
        @InvocableVariable(required=false)
        public String StreetDirection;
        @InvocableVariable(required=false)
        public String TaskStatus;
        @InvocableVariable(required=false)
        public String WhastAppTemplate;
        @InvocableVariable(required=false)
        public String Mark;
        
        @InvocableVariable(required=false)
        public String CustomerName;
        @InvocableVariable(required=false)
        public String NumeroAutorizacion;
        @InvocableVariable(required=false)
        public String ServiceAppointment;
        @InvocableVariable(required=false)
        public String Status;
        @InvocableVariable(required=false)
        public String Email;
        @InvocableVariable(required=false)
        public String WorkOrderNumber;
        @InvocableVariable(required=false)
        public String CaseNumber;
    }

    public class InfoResult {
        @InvocableVariable
        public String status;
        @InvocableVariable
        public String message;
        @InvocableVariable
        public String response; // Nuevo campo para almacenar la respuesta del servicio
    }

    @InvocableMethod(label='Send Message SMS' description='Send SMS Creation and Notification')
    public static List<InfoResult> UpdateWorkOrder(List<InfoInput> inputList) {
        List<InfoResult> resultList = new List<InfoResult>();

        Http http = new Http();
        
        try {
            
               
            // Use the obtained token to make the work order creation request
                HttpRequest req = new HttpRequest();
                req.setEndpoint('https://os7cfipof2.execute-api.us-east-1.amazonaws.com/stage/siab_asistencia/api/v1/services/sms/click');
                req.setMethod('POST');
                req.setHeader('Content-Type', 'application/json');
                req.setHeader('x-api-key', 'sp4Eu6SuH11SGLuemzEm15aSO2HgliaD3fntHWly');

            for (InfoInput input : inputList) {
                
                if (input.KeyTask != null && input.KeyTask.contains('_')) {
                    input.KeyTask = input.KeyTask.split('_')[0];
                }
                
                if (input.TaskStatus == 'In Progress'){
                    input.TaskStatus = 'On-Site';
                }
                if (input.TaskStatus == 'None'){
                    input.TaskStatus = 'New';
                }               
                String requestBody = '{"MissionCreate":';
                requestBody = requestBody +
                    '{"Destination":"BolivarSMSCreate","CreatedBy":"integrationAsistencia@AsistenciaD4","Mission":{"@objectType":"Mission","MissionType":{"@objectType": "MissionType","Name": "' + input.NameNotification +
                    '"},"Task":{"@objectType":"Task", "CallID":"' + input.CallID +
                    '"},"SMSText":"' + input.SMSText +
                    '","CustomerPhoneNumber":"' + input.CustomerPhoneNumber +
                    '","MissionID":"' + input.MissionID +    
                    '","MissionURL":"' + input.MissionURL +
                    '","MisssionUpdate":"' + input.MisssionUpdate +
                    '","PhoneNumbers":"' + input.PhoneNumbers +
                    '","IsUpdatedSMSTextLM":' + input.IsUpdatedSMSTextLM +
                    ',"IsUpdatedSMSTextAsistencia":' + input.IsUpdatedSMSTextAsistencia +
                    ',"IsUpdatedSMSTextConductorEleg":' + input.IsUpdatedSMSTextConductorEleg +
                    ',"IsUpdatedSMSTextGruas":' + input.IsUpdatedSMSTextGruas +
                    ',"IsUpdatedSMSTextCerrajeria":' + input.IsUpdatedSMSTextCerrajeria +
                    ',"IsUpdatedSMSTextConductorF":' + input.IsUpdatedSMSTextConductorF +
                    ',"IsUpdatedSMSTextCarroT":' + input.IsUpdatedSMSTextCarroT +
                    ',"IsUpdatedSMSTextAsistenciaGN":' + input.IsUpdatedSMSTextAsistenciaGN +
                    ',"ServiceName":"' + input.ServiceName +
                    '","TaskDate":"' + input.TaskDate +
                    '","StartDate":"' + input.StartDate +
                    '","StreetDirection":"' + input.StreetDirection +
                    '","AssignedEngineer":"' + input.AssignedEngineer +
                    //'","TaskStatus":"' + input.TaskStatus +
                    '","Mark":"' + input.Mark +
                    '","WhastAppTemplate":"' + input.WhastAppTemplate + '"}}}';

                req.setBody(requestBody);

                System.debug('Peticion a enviar a Bolivar: ' + requestBody);

                HttpResponse res = http.send(req);

                InfoResult result = new InfoResult();
                // Procesar la respuesta de Bolivar
                if (res.getStatusCode() == 200) {
                    // Éxito, manejar la respuesta
                    String responseBody = res.getBody();
                    System.debug('Respuesta de Bolivar Login: ' + responseBody);
                    result.status = 'Success';
                    result.message = 'SMS sent successfully';
                    result.response = responseBody;

                    // Crear un registro en Customer Notifications y obtener el ID
                    CustomerNotificationService.createCustomerNotification(input.CustomerPhoneNumber, input.SMSText, input.CustomerName, input.NumeroAutorizacion, 'SMS sent successfully: ' + responseBody, input.ServiceAppointment, input.Status, input.Email, input.WorkOrderNumber, input.CaseNumber,input.WhastAppTemplate);       
                    
                } else {
                    // Manejar el caso en que la solicitud no sea exitosa
                    System.debug('Error Bolivar Login: ' + res.getStatusCode() + ' ' + res.getBody());
                    result.status = 'Error';
                    result.message = 'Error sending SMS: ' + res.getBody();
                    result.response = res.getBody();
                }

                resultList.add(result);
            }
        } catch (Exception e) {
            // Manejo de excepciones
            InfoResult result = new InfoResult();
            result.status = 'Error';
            result.message = 'Exception occurred: ' + e.getMessage();
            System.debug('Respuesta de Bolivar Exception: ' + result.message);
            resultList.add(result);
        }

        System.debug('Respuesta de Bolivar Result: ' + resultList);
        return resultList;
    }
}