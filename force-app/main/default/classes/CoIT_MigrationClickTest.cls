@IsTest
private class CoIT_MigrationClickTest {

    @IsTest
    static void testCrearSFSMigrationClick() {
        // Crear datos de prueba para Attachments
        List<CoIT_MigrationClick.AttachmentData> attachments = new List<CoIT_MigrationClick.AttachmentData>();
        CoIT_MigrationClick.AttachmentData attachment1 = new CoIT_MigrationClick.AttachmentData();
        attachment1.FileName = 'TestFile1.pdf';
        attachment1.TimeAttached = DateTime.now();
        attachment1.UploadedBy = 'Test User';
        attachment1.ExternalKey_SO = 'KEY001';
        attachment1.ExternalURL_SO = 'http://example.com/file1';
        attachment1.CallIDatt = 'CALL001';
        attachments.add(attachment1);

        // Crear la solicitud
        CoIT_MigrationClick.CreateRequest request = new CoIT_MigrationClick.CreateRequest();
        request.NumeroCasoSIAB = '123456';
        request.CallID = 'CALL001';
        request.NumeroServicio = 7890;
        request.Causa = 'Test Cause';
        request.Direccion = 'Test Address';
        request.BLPUDO = true;
        request.CiudadCliente = 'Test City';
        request.FechaCompletada = DateTime.now().addDays(-1);
        request.DocumentoCustomer = '12345678';
        request.EmailCustomer = 'customer@example.com';
        request.NombreCustomer = 'Test Customer';
        request.TelefonoCustomer = '1234567890';
        request.Descripcion = 'Test Description';
        request.DocumentoProveedor = '87654321';
        request.Latitude = '37.7749';
        request.Longitude = '-122.4194';
        request.FechaEnSitio = DateTime.now();
        request.FechaAbierto = DateTime.now().addDays(-2);
        request.RToken = 'RTOKEN001';
        request.TaskStatus = 'None';
        request.DocumentoSupervisor = 'SUP123';
        request.NombreSupervisor = 'Supervisor Name';
        request.DocumentoTecnico = 'TECH123';
        request.NombreTecnico = 'Technician Name';
        request.TipoTareaClick = 'Migration';
        request.FechaTravel = DateTime.now().addHours(2);
        request.FechaAssignmentStart = DateTime.now().addHours(3);
        request.FechaAssignmentFinish = DateTime.now().addHours(5);
        request.Attachments = attachments;

        // Ejecutar la prueba
        Test.startTest();
        String result = CoIT_MigrationClick.crearSFSMigrationClick(request);
        Test.stopTest();

        // Debug del resultado retornado
        System.debug('Resultado retornado: ' + result);

        // Validar que el resultado indique éxito
        System.assert(result.contains('Creación exitosa del objeto') || result.contains('No se realizó ninguna acción'),
            'El resultado no indica éxito ni una acción específica. Resultado: ' + result);
    }
}