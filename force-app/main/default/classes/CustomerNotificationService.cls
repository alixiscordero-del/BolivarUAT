public class CustomerNotificationService {
    
    // Método para crear una notificación al cliente
    public static String createCustomerNotification(String customerPhone, String notificationMessage,String CustomerName, String NumeroSiniestro, String Response, String ServiceApp, String StatusSA, String Email,String WorkOrder,String LCase, String WhastAppsTem) {
        
    try {
        // Crear una instancia del objeto Customer Notifications
        CoIT_Customer_Notificacion__c newNotification = new CoIT_Customer_Notificacion__c();
        
        // Asignar valores a los campos del objeto
        newNotification.CoIT_Numero_Cliente__c = customerPhone;
        newNotification.CoIT_Notificacion__c = notificationMessage;
        newNotification.CoIT_Nombre_Cliente__c = CustomerName;
        newNotification.CoIT_Numero_Autorizacion__c = NumeroSiniestro;
        newNotification.CoIT_Response__c = Response;
        newNotification.CoIT_Service_Appointment__c = ServiceApp;
        newNotification.CoIT_Status_Service_Appointment__c = StatusSA;
        newNotification.CoIT_Customer_Email__c = Email;
        newNotification.CoIT_Work_Order__c = WorkOrder;
        newNotification.CoIT_Case__c = LCase;
        newNotification.CoIT_SurvercateTemplate__c = WhastAppsTem;
        
        
        // Insertar el registro en la base de datos
            insert newNotification;
            System.debug('Notificación al cliente creada con éxito.' + newNotification.Id);
            return 'Notificación al cliente creada con éxito.' + newNotification.Id;

        } catch (DmlException e) {
            System.debug('Error al crear la notificación al cliente: ' + e.getMessage());
            return 'Error al crear la notificación al cliente: ' + e.getMessage();

        }
    }
}