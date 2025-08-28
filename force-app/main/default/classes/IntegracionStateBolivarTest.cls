@isTest
public class IntegracionStateBolivarTest {
    
    @testSetup
    static void setup() {
        // Crear registros necesarios para las pruebas, si es necesario
    }

    @isTest
    static void testUpdateWorkOrder_Success() {
        // Crear la solicitud de prueba
        IntegracionStateBolivar.InfoInput input = new IntegracionStateBolivar.InfoInput();
        input.CallID = '12345';
        input.Numero = '54321';
        input.EarliestStart = '2024-05-20T08:00:00.000Z';
        input.DueDate = '2024-05-21T08:00:00.000Z';
        input.Status = 'In Progress';
        input.Customer = 'Customer Name';
        input.Region = 'Region Name';
        input.OpenDate = '2024-05-19T08:00:00.000Z';
        input.WorkTypeId = 'TestWorkTypeId';
        input.Latitude = 40.712776;
        input.Longitude = -74.005974;
        input.Street = '123 Test Street';
        input.City = 'Test City';
        input.Country = 'Test Country';
        input.CustomerEmail = 'customer@example.com';
        input.ContactName = 'Contact Name';
        input.ContactPhoneNumber = '1234567890';
        input.Comment = 'Test Comment';

        List<IntegracionStateBolivar.InfoInput> inputList = new List<IntegracionStateBolivar.InfoInput> { input };

        Test.startTest();
        
        // Simular la respuesta HTTP
        MockHttpResponseGenerator mock = new MockHttpResponseGenerator(200, '{ "response": "SA Updated successfully." }');
        Test.setMock(HttpCalloutMock.class, mock);
        
        List<IntegracionStateBolivar.InfoResult> results = IntegracionStateBolivar.UpdateWorkOrder(inputList);
        
        Test.stopTest();
        
        System.assertEquals(1, results.size(), 'Debe haber un resultado');
        System.assertEquals('Success', results[0].status, 'El estado debe ser Success');
        System.assertEquals('SA Updated successfully.', results[0].message, 'El mensaje debe ser SA Updated successfully.');
    }

    @isTest
    static void testUpdateWorkOrder_Failure() {
        // Crear la solicitud de prueba
        IntegracionStateBolivar.InfoInput input = new IntegracionStateBolivar.InfoInput();
        input.CallID = '12345';
        input.Numero = '54321';
        input.EarliestStart = '2024-05-20T08:00:00.000Z';
        input.DueDate = '2024-05-21T08:00:00.000Z';
        input.Status = 'In Progress';
        input.Customer = 'Customer Name';
        input.Region = 'Region Name';
        input.OpenDate = '2024-05-19T08:00:00.000Z';
        input.WorkTypeId = 'TestWorkTypeId';
        input.Latitude = 40.712776;
        input.Longitude = -74.005974;
        input.Street = '123 Test Street';
        input.City = 'Test City';
        input.Country = 'Test Country';
        input.CustomerEmail = 'customer@example.com';
        input.ContactName = 'Contact Name';
        input.ContactPhoneNumber = '1234567890';
        input.Comment = 'Test Comment';

        List<IntegracionStateBolivar.InfoInput> inputList = new List<IntegracionStateBolivar.InfoInput> { input };

        Test.startTest();
        
        // Simular la respuesta HTTP
        MockHttpResponseGenerator mock = new MockHttpResponseGenerator(500, '{ "error": "Failed to update Service Appointment." }');
        Test.setMock(HttpCalloutMock.class, mock);
        
        List<IntegracionStateBolivar.InfoResult> results = IntegracionStateBolivar.UpdateWorkOrder(inputList);
        
        Test.stopTest();
        
        System.assertEquals(1, results.size(), 'Debe haber un resultado');
        System.assertEquals('Error', results[0].status, 'El estado debe ser Error');
        System.assertEquals('Failed to update Service Appointment.', results[0].message, 'El mensaje debe ser Failed to update Service Appointment.');
    }
    
    // Mock HTTP Response Generator para pruebas
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        private Integer statusCode;
        private String responseBody;
        
        public MockHttpResponseGenerator(Integer statusCode, String responseBody) {
            this.statusCode = statusCode;
            this.responseBody = responseBody;
        }
        
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(statusCode);
            res.setBody(responseBody);
            return res;
        }
    }
}