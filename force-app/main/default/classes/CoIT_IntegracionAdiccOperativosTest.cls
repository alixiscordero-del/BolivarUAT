@isTest
public class CoIT_IntegracionAdiccOperativosTest {
    
    
    
    @isTest
    static void testUpdateWorkOrderSuccess() {
        // Preparar datos de entrada
        List<IntegracionAdiccOperativos.InfoInput> inputs = new List<IntegracionAdiccOperativos.InfoInput>();
        IntegracionAdiccOperativos.InfoInput input = new IntegracionAdiccOperativos.InfoInput();
        input.key = '123';
        input.CallID = '12345';
        input.Numero = '67890';
        input.Status = 'Active';
        input.CustomerName = 'Test Customer';
        input.TasktypeName = 'Repair';
        // Añadir más campos según necesidad...
        inputs.add(input);

        // Mockear respuestas de base de datos y HTTP
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Test.startTest();

        // Llamar al método que se está probando
        List<IntegracionAdiccOperativos.InfoResult> results = IntegracionAdiccOperativos.UpdateWorkOrder(inputs);
        Test.stopTest();

        // Verificar resultados
        System.assertEquals(1, results.size());
        System.assertEquals('Success', results[0].status);
        // Añadir más aserciones para verificar la integridad de los datos...
    }

    @isTest
    static void testUpdateWorkOrderFailure() {
        // Simular condiciones de fallo, como respuesta HTTP con error
    }
    
    // Mock para generar respuestas HTTP simuladas
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"status":"Success","message":"SA Updated successfully."}');
            res.setStatusCode(200);
            return res;
        }
    }
    
    
}