@isTest
public class CoIT_IntegracionSMSTest {
    
    @isTest
    static void testUpdateWorkOrderSuccess() {
        // Preparar datos de entrada
        List<IntegracionSMS.InfoInput> inputs = new List<IntegracionSMS.InfoInput>();
        IntegracionSMS.InfoInput input = new IntegracionSMS.InfoInput();
        input.NameNotification = 'Test Notification';
        input.KeyTask = '123';
        input.SMSText = 'Test SMS';
        input.CustomerPhoneNumber = '1234567890';
        // Añadir más campos según necesidad...
        inputs.add(input);

        // Mockear respuesta HTTP para simular un entorno de prueba controlado
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Ejecutar el método que se está probando
        Test.startTest();
        List<IntegracionSMS.InfoResult> results = IntegracionSMS.UpdateWorkOrder(inputs);
        Test.stopTest();
        
        // Verificar el resultado
        System.assertEquals(1, results.size());
        System.assertEquals('Success', results[0].status);
        // Añadir más aserciones según necesidad...
    }

    @isTest
    static void testUpdateWorkOrderFailure() {
        // Simular condiciones de error, como errores HTTP o excepciones
    }
    
    // Clase de ayuda para generar respuestas HTTP simuladas
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"status":"Success","message":"SMS sent successfully"}');
            res.setStatusCode(200);
            return res;
        }
    }
}