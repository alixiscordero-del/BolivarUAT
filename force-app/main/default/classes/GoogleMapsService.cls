public class GoogleMapsService {

    // Método que hace una llamada a la API de Google Maps y obtiene el cuerpo de la respuesta
    public static String getLocationData(Double latitude, Double longitude) {
        // URL de la API de Google Maps con los parámetros (requiere tu API key)
        String apiKey = 'AIzaSyA-YLjJOVw5HE8VxDnOIPVRAmUzmr_6Q7Q';  // Reemplazar con tu API key de Google Maps
        String endpoint = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=' 
            + latitude + ',' + longitude + '&key=' + apiKey;
        
        // Crear el objeto de la solicitud HTTP
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        
        // Hacer la llamada HTTP
        HttpResponse response = http.send(request);
        
        // Verificar si la respuesta es exitosa
        if (response.getStatusCode() == 200) {
            // Obtener el cuerpo completo de la respuesta JSON
            String responseBody = response.getBody();
            
            // Mostrar el cuerpo de la respuesta en los logs de depuración
            System.debug('Response Body: ' + responseBody);
            
            // Devolver el cuerpo de la respuesta
            return responseBody;
        } else {
            // Manejar el error si la llamada no fue exitosa
            System.debug('Error en la llamada a la API: ' + response.getStatus() + ' - ' + response.getStatusCode());
            return null;
        }
    }
}