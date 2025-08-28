@isTest
public class ServicioCreacionCasoTest {

    @isTest static void testCrearCaseConContactoNuevo() {
        // Preparación de datos de prueba
        ServicioCreacionCaso.CrearCaseRequest req = new ServicioCreacionCaso.CrearCaseRequest();
        req.CodigoRamo = '100'; // Supongamos que corresponde a Hogares
        req.DocumentoTomador = '1234567890';
        req.NombreTomador = 'Juan Perez';
        req.CorreoTomador = 'juan@example.com';
        req.TelefonoTomador = '3001234567';
        // Añadir más campos según sea necesario...

        Test.startTest();
        // Ejecutar el método que se está probando
        String resultado = ServicioCreacionCaso.crearCase(req);
        Test.stopTest();

        // Aserciones para verificar el resultado esperado
        System.assert(resultado.contains('Caso creado con éxito'), 'Debería haber creado un caso.');
    }

    @isTest static void testCrearCaseConContactoExistente() {
        // Crear contacto existente
        Contact contactoExistente = new Contact(
            LastName = 'Perez',
            CoIT_N_Documento__c = '1234567890',
            Email = 'juan@example.com',
            Phone = '3001234567'
        );
        insert contactoExistente;

        ServicioCreacionCaso.CrearCaseRequest req = new ServicioCreacionCaso.CrearCaseRequest();
        req.DocumentoTomador = '1234567890'; // Debería encontrar este contacto
        // Configurar otros campos necesarios

        Test.startTest();
        // Ejecutar
        String resultado = ServicioCreacionCaso.crearCase(req);
        Test.stopTest();

        // Aserciones
        System.assert(resultado.contains('Contacto creado/actualizado'), 'Debería actualizar el contacto existente.');
    }

    @isTest static void testCrearCaseSinRecordType() {
        ServicioCreacionCaso.CrearCaseRequest req = new ServicioCreacionCaso.CrearCaseRequest();
        req.CodigoRamo = '999'; // Código inexistente

        Test.startTest();
        // Intentar crear un caso con un código de ramo inexistente
        String resultado = ServicioCreacionCaso.crearCase(req);
        Test.stopTest();

        // Verificar manejo de errores
        System.assertEquals('Error: No se encontró un RecordType asociado al código de ramo: 999', resultado);
    }

    // Puedes añadir más pruebas para cubrir diferentes escenarios, como errores de inserción, etc.
}