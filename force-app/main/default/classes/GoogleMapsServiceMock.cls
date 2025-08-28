@isTest
public class GoogleMapsServiceMock implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200); // Código 200 para indicar éxito.
        
        // Respuesta JSON simulada de Google Maps con ciudad y estado.
        res.setBody('{"results": [{"address_components": [{"long_name": "Bogotá", "types": ["locality"]}, {"long_name": "Bogotá D.C.", "types": ["administrative_area_level_1"]}]}]}');
        return res;
    }
}