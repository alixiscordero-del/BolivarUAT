public class EjemploMap {

    // Clase interna para definir los parámetros de entrada y salida
    public class LocationInput {
        @InvocableVariable(required=true)
        public Double latitude;  // Latitud enviada desde el flujo

        @InvocableVariable(required=true)
        public Double longitude;  // Longitud enviada desde el flujo
    }
    
    public class LocationOutput {
        @InvocableVariable
        public String city;  // Ciudad devuelta al flujo
        
        @InvocableVariable
        public String state;  // Estado devuelto al flujo
    }

    // Método invocable que será llamado desde el flujo
    @InvocableMethod(label='Obtener Ubicación' description='Obtiene ciudad y estado basado en latitud y longitud')
    public static List<LocationOutput> obtenerUbicacion(List<LocationInput> inputs) {
        // Lista de resultados para devolver al flujo
        List<LocationOutput> resultados = new List<LocationOutput>();

        // Iteramos sobre las entradas del flujo
        for(LocationInput input : inputs) {
            LocationOutput resultado = new LocationOutput();
            
            // Llamada al servicio de Google Maps para obtener la respuesta JSON
            String responseBody = GoogleMapsService.getLocationData(input.latitude, input.longitude);

            // Si la respuesta no es nula
            if (responseBody != null) {
                // Deserializar la respuesta JSON
                Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
                List<Object> results = (List<Object>) jsonResponse.get('results');
                
                if (!results.isEmpty()) {
                    // Iteramos sobre los componentes de la dirección
                    for (Object result : results) {
                        Map<String, Object> resultMap = (Map<String, Object>) result;
                        List<Object> addressComponents = (List<Object>) resultMap.get('address_components');

                        for (Object component : addressComponents) {
                            Map<String, Object> componentMap = (Map<String, Object>) component;
                            List<Object> types = (List<Object>) componentMap.get('types');

                            // Buscamos el componente con el tipo 'locality'
                            if (types.contains('locality')) {
                                resultado.city = (String) componentMap.get('long_name');
                            }

                            // Buscamos el componente con el tipo 'administrative_area_level_1' para el estado
                            if (types.contains('administrative_area_level_1')) {
                                resultado.state = (String) componentMap.get('long_name');
                            }
                        }
                    }

                    System.debug('Ciudad: ' + resultado.city);
                    System.debug('Estado: ' + resultado.state);
                } else {
                    resultado.city = 'No se encontró ciudad';
                    resultado.state = 'No se encontró estado';
                }
            } else {
                resultado.city = 'No se encontró ciudad';
                resultado.state = 'No se encontró estado';
            }
            
            // Añadimos el resultado a la lista de salida
            resultados.add(resultado);
        }

        // Devolvemos los resultados al flujo
        return resultados;
    }
}