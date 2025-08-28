@IsTest
public class GoogleMapsServiceTest {

    // Clase mock que simula una respuesta HTTP exitosa
    private class GoogleMapsServiceCalloutSuccessMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Creamos una respuesta exitosa simulada
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"results" : [{"formatted_address" : "1600 Amphitheatre Parkway, Mountain View, CA 94043, USA"}]}');
            res.setStatusCode(200);  // Simulamos un status code 200 (éxito)
            return res;
        }
    }

    // Clase mock que simula una respuesta HTTP fallida
    private class GoogleMapsServiceCalloutFailureMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Creamos una respuesta fallida simulada
            HttpResponse res = new HttpResponse();
            res.setStatusCode(404);  // Simulamos un status code 404 (error)
            res.setBody('{"error_message": "Location not found"}');
            return res;
        }
    }

    // Prueba que cubre la ejecución exitosa del método getLocationData
    @IsTest
    static void testGetLocationData_Success() {
        // Establecemos el mock para simular una respuesta exitosa
        Test.setMock(HttpCalloutMock.class, new GoogleMapsServiceCalloutSuccessMock());

        // Ejecutamos el método con latitud y longitud de prueba (usamos Double en lugar de Decimal)
        Double latitude = 37.4224764;
        Double longitude = -122.0842499;
        String result = GoogleMapsService.getLocationData(latitude, longitude);
        
        // Verificamos que el resultado no sea nulo
        System.assertNotEquals(null, result, 'El resultado no debe ser nulo');
        
        // Verificamos que el cuerpo de la respuesta contiene la dirección esperada
        System.assert(result.contains('1600 Amphitheatre Parkway'), 'El cuerpo de la respuesta debe contener la dirección formateada.');
    }

    // Prueba que cubre el caso donde la llamada falla
    @IsTest
    static void testGetLocationData_Failure() {
        // Establecemos el mock para simular una respuesta fallida
        Test.setMock(HttpCalloutMock.class, new GoogleMapsServiceCalloutFailureMock());

        // Ejecutamos el método con valores de latitud y longitud que simularán un error (usamos Double)
        Double latitude = 0.0;
        Double longitude = 0.0;
        String result = GoogleMapsService.getLocationData(latitude, longitude);

        // Verificamos que el resultado sea nulo debido al error 404
        System.assertEquals(null, result, 'El resultado debe ser nulo en caso de error.');
    }
}