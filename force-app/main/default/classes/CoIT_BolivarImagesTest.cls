@IsTest
private class CoIT_BolivarImagesTest {
    @IsTest
    static void testCreateWorkOrder() {
        // Crear datos de prueba
        List<CoIT_SFS_Attachment_Click__c> attachmentClickList = new List<CoIT_SFS_Attachment_Click__c>();
        attachmentClickList.add(new CoIT_SFS_Attachment_Click__c(
            CoIT_ExternalKey_SO__c = 'TestKey',
            CoIT_ExternalURL_SO__c = 'https://mock-s3-endpoint.com/testfile',
            CoIT_File_Name__c = 'TestFileName'
        ));

        insert attachmentClickList;

        List<CoIT_BolivarImages.ImageInput> inputList = new List<CoIT_BolivarImages.ImageInput>();
        CoIT_BolivarImages.ImageInput input = new CoIT_BolivarImages.ImageInput();
        input.attachmentClickList = attachmentClickList;
        input.workOrderId = '0WOSu000003Ejl7OAC';
        inputList.add(input);

        // Configuración de mock para callout
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        CoIT_BolivarImages.createWorkOrder(inputList);
        Test.stopTest();
    }

    @IsTest
    static void testLoginFailure() {
        // Simular credenciales faltantes en el custom setting
        BolivarConfiguration__c config = new BolivarConfiguration__c();
        config.Username__c = 'mockUser';
        config.Password__c = 'mockPassword';
        insert config;

        Test.startTest();
        Boolean exceptionThrown = false;
        try {
            CoIT_BolivarImages.login();
        } catch (CalloutException e) {
            exceptionThrown = true;
        }
        Test.stopTest();

        System.assert(exceptionThrown, 'La excepción de credenciales debería haberse lanzado.');
    }
		public class MockHttpResponseGenerator implements HttpCalloutMock {
    	public HTTPResponse respond(HTTPRequest req) {
        	HttpResponse res = new HttpResponse();
        	res.setHeader('Content-Type', 'application/json');
        	res.setBody('{"AccessKeyId":"mockAccessKeyId","SecretAccessKey":"mockSecretAccessKey","Token":"mockSessionToken"}');
        	res.setStatusCode(200);
        return res;
    }
}
}