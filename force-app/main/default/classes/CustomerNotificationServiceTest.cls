@isTest
public class CustomerNotificationServiceTest {
    
    @isTest
    static void testCrearCustomerNotification(){
        // Preparar datos de entrada
        String customerPhone = '1234567890';
        String notificationMessage = 'Test Notification';
        String CustomerName = 'Test Cstomer';
        String NumeroSiniestro = '12345';
        String Response = 'Test Response';
        String StatusSA = 'Test Status';
        String Email = 'test.email@example.com';
        String WhastAppsTem = 'TestEjemplo';
        
        // Ejecutar el método que se está probando
        Test.startTest();
        
        // Creacion de instancia de caso, WO y SA para prueba
        Case testCase = new Case();
        WorkOrder testWO = new WorkOrder();
        ServiceAppointment testSA= new ServiceAppointment();
        String LCase = testCase.Id;
        String WorkOrder = testWO.Id;
        String ServiceApp = testSA.Id;
        
        String result = CustomerNotificationService.createCustomerNotification(customerPhone, notificationMessage, CustomerName, NumeroSiniestro, Response, ServiceApp, StatusSA, Email, WorkOrder,LCase, WhastAppsTem);
        System.debug(result);
        Test.stopTest();
        
        // Verificar el resultado
        System.assert(result.startsWith('Notificación al cliente creada con éxito.'), 'Expected message');
    }
    
    
    
}