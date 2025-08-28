@isTest
public class ServicioCreacionWorkOrderTest {

    // Método helper para crear un request válido
    private static ServicioCreacionWorkOrder.CrearWorkOrderRequest crearRequestValido() {
        ServicioCreacionWorkOrder.CrearWorkOrderRequest request = new ServicioCreacionWorkOrder.CrearWorkOrderRequest();
        request.NombreAsegurado = 'Juan Perez';
        request.DocumentoAsegurado = '123456789';
        request.EmailAsegurado = 'juan.perez@example.com';
        request.TelefonoAsegurado = '555-1234';
        request.StartDate = DateTime.now();
        request.LatitudeDestino = 4.60971;
        request.LongitudeDestino = -74.08175;
        request.Street = 'Calle 123';
        request.City = 'Bogotá';
        request.Country = 'Colombia';
        request.WorkTypeId = '0123xyz';
        request.CodigoServicio = 123;
        request.Distrito = 'Distrito1';
        request.TipoAgendamiento='Emergencia';
        request.Marca = 'Mazda';
        request.PhoneNumbers = '32222345675';
        return request;
    }

    @isTest
    static void testCrearWorkOrder_ValidarCamposObligatorios() {
        ServicioCreacionWorkOrder.CrearWorkOrderRequest request = new ServicioCreacionWorkOrder.CrearWorkOrderRequest();
        // No asignar NombreAsegurado ni DocumentoAsegurado para probar las validaciones
        String resultado = ServicioCreacionWorkOrder.crearWorkOrder(request);
        System.assertEquals('El nombre del solicitante es obligatorio.', resultado);

        request.NombreAsegurado = 'Juan Perez';
        resultado = ServicioCreacionWorkOrder.crearWorkOrder(request);
        System.assertEquals('El número de documento del asegurado es obligatorio.', resultado);
    }

    @isTest
static void testCrearWorkOrder_NuevoContacto() {
    // Crear un tipo de trabajo válido
    WorkType newWorkType = new WorkType(Name = '(AA) Grua Livianos2',EstimatedDuration = 60);
    insert newWorkType;

    // Crear el request con un WorkTypeId válido
    ServicioCreacionWorkOrder.CrearWorkOrderRequest request = crearRequestValido();
    request.WorkTypeId = newWorkType.Id; // Asignar el WorkTypeId correcto

    // Configurar el mock de GoogleMapsService
    Test.setMock(HttpCalloutMock.class, new GoogleMapsServiceMock());

    Test.startTest();
    String resultado = ServicioCreacionWorkOrder.crearWorkOrder(request);
    Test.stopTest();

    System.assert(resultado.startsWith('Orden de Trabajo creada con éxito.'), 
        'Expected success message but received: ' + resultado);
}



    @isTest
    static void testCrearWorkOrder_ActualizarContactoExistente() {
        // Crear un contacto existente
        Contact existingContact = new Contact(
            LastName = 'Existing Contact',
            CoIT_N_Documento__c = '123456789',
            Email = 'existing.contact@example.com',
            Phone = '555-5678'
        );
        insert existingContact;

        ServicioCreacionWorkOrder.CrearWorkOrderRequest request = crearRequestValido();
        request.NombreAsegurado = 'Updated Contact';  // Cambiar el nombre para actualizar el contacto

        // Configurar el mock de GoogleMapsService
        Test.setMock(HttpCalloutMock.class, new GoogleMapsServiceMock());

        Test.startTest();
        String resultado = ServicioCreacionWorkOrder.crearWorkOrder(request);
        Test.stopTest();

        System.assert(resultado.startsWith('Orden de Trabajo creada con éxito. ID:'), 'Expected success message');
        Contact updatedContact = [SELECT LastName FROM Contact WHERE Id = :existingContact.Id];
        System.assertEquals('Updated Contact', updatedContact.LastName);
    }

    @isTest
    static void testCrearWorkOrder_ErrorEnCreacionDeWorkOrder() {
        ServicioCreacionWorkOrder.CrearWorkOrderRequest request = crearRequestValido();
        request.StartDate = null;  // Simular un StartDate inválido para provocar un error

        // Configurar el mock de GoogleMapsService
        Test.setMock(HttpCalloutMock.class, new GoogleMapsServiceMock());

        Test.startTest();
        String resultado = ServicioCreacionWorkOrder.crearWorkOrder(request);
        Test.stopTest();

        System.assert(resultado.startsWith('Error al procesar la solicitud:'), 'Expected error message');
    }
    
}