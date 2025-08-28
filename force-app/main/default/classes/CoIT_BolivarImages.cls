public class CoIT_BolivarImages implements Database.Batchable<CoIT_BolivarImages.asyncRequest>, Database.AllowsCallouts {

    private static String accessKeyId;
    private static String secretAccessKey;
    private static String accessToken;

    public class ImageInput {
        @InvocableVariable(required=true)
        public List<CoIT_SFS_Attachment_Click__c> attachmentClickList;

        @InvocableVariable(required=true)
        public String workOrderId;
    }

    public class ImageResult {
        @InvocableVariable
        public String status;
        @InvocableVariable
        public String message;
        @InvocableVariable
        public String response;
    }

    public class asyncRequest {
        public String endpoint;
        public String canonicalUri;
        public String accessKeyId;
        public String secretAccessKey;
        public String region;
        public String service;
        public String sessionToken;
        public String workOrderId;
        public CoIT_SFS_Attachment_Click__c input;
    }

    private List<asyncRequest> requests;

    public CoIT_BolivarImages(List<asyncRequest> requests) {
        this.requests = requests;
    }

    @InvocableMethod(label='Create Attachment Bolivar' description='Almacenar Attachments Bolivar')
    public static void createWorkOrder(List<ImageInput> inputList) {
        try {
            login();

            if (String.isEmpty(accessKeyId) || String.isEmpty(secretAccessKey) || String.isEmpty(accessToken)) {
                throw new CalloutException('No se pudieron obtener las credenciales de AWS.');
            }

            List<CoIT_SFS_Attachment_Click__c> attachments = inputList[0].attachmentClickList;
            String workOrderId = inputList[0].workOrderId;
            List<asyncRequest> requests = new List<asyncRequest>();

            for (CoIT_SFS_Attachment_Click__c attachment : attachments) {
                if (String.isEmpty(attachment.CoIT_ExternalKey_SO__c)) {
                    throw new CalloutException('El campo ExternalSO es obligatorio para construir el Canonical URI.');
                }

                String canonicalUri = '/asistenciasb/' + EncodingUtil.urlEncode(attachment.CoIT_ExternalKey_SO__c, 'UTF-8').replace('+', '%20');
                asyncRequest request = new asyncRequest();
                request.endpoint = attachment.CoIT_ExternalURL_SO__c;
                request.canonicalUri = canonicalUri;
                request.accessKeyId = accessKeyId;
                request.secretAccessKey = secretAccessKey;
                request.service = 's3';
                request.sessionToken = accessToken;
                request.input = attachment;
                request.workOrderId = workOrderId;
                requests.add(request);
            }

            Database.executeBatch(new CoIT_BolivarImages(requests));
        } catch (Exception e) {
            System.debug('Error: ' + e.getMessage());
        }
    }

    public Iterable<asyncRequest> start(Database.BatchableContext context) {
        return requests;
    }

    public void execute(Database.BatchableContext context, List<asyncRequest> scope) {
        System.debug('Database Execute Batch');
        String jobId = context.getJobId();
        System.debug('Batch Job ID: ' + jobId);

        List<ContentVersion> contentVersionList = new List<ContentVersion>();
        List<CoIT_SFS_Attachment_Click__c> updateRecords = new List<CoIT_SFS_Attachment_Click__c>();

        for (asyncRequest request : scope) {
            try {
                // Obtener respuesta HTTP
                HttpResponse response = sendGetRequest(request);

                if (response != null) {
                    
                    if (response.getStatusCode() == 200) {
                        // Procesar imagen si es exitoso
                        Blob data = response.getBodyAsBlob();
                        ContentVersion contentVersion = new ContentVersion();
                        contentVersion.PathOnClient = '/' + (request.input.CoIT_File_Name__c != null ? request.input.CoIT_File_Name__c : 'ArchivoSinNombre');
                        contentVersion.VersionData = data;
                        contentVersion.FirstPublishLocationId = request.workOrderId;
                        contentVersionList.add(contentVersion);
                    }

                    // Actualizar con código HTTP y mensaje
                    CoIT_SFS_Attachment_Click__c attachment = new CoIT_SFS_Attachment_Click__c(
                        Id = request.input.Id,
                        CoIT_Response__c = 'HTTP Status: ' + response.getStatusCode() + ' - ' + response.getStatus()
                    );
                    updateRecords.add(attachment);
                } else {
                    // Actualizar si no hay respuesta HTTP
                    CoIT_SFS_Attachment_Click__c attachment = new CoIT_SFS_Attachment_Click__c(
                        Id = request.input.Id,
                        CoIT_Response__c = 'HTTP Status: ' + response.getStatusCode() + ' - ' + response.getStatus() + ' - ' + response.getBody()
                    );
                    updateRecords.add(attachment);
                }
            } catch (Exception e) {
                System.debug('Error procesando el request: ' + JSON.serialize(request) + ' - ' + e.getMessage());
                if(request.input != null){
                CoIT_SFS_Attachment_Click__c attachment = new CoIT_SFS_Attachment_Click__c(
                    	Id = request.input.Id,
                    	CoIT_Response__c = 'Error: ' + e.getMessage()
                	);
                    updateRecords.add(attachment);
                }else{
                    CoIT_SFS_Attachment_Click__c attachment = new CoIT_SFS_Attachment_Click__c(
                    	Id = request.input.Id,
                    	CoIT_Response__c = 'Error: Mala Lectura de la Imagen intente de Nuevo ' 
                	);
                    updateRecords.add(attachment);
                }
                
            }
        }

        if (!contentVersionList.isEmpty()) {
            try {
                insert contentVersionList;
                System.debug('ContentVersions insertados correctamente.');
            } catch (Exception e) {
                System.debug('Error al insertar ContentVersions: ' + e.getMessage());
            }
        }

        if (!updateRecords.isEmpty()) {
            try {
                update updateRecords;
                System.debug('Registros actualizados con las respuestas.');
            } catch (Exception e) {
                System.debug('Error al actualizar registros: ' + e.getMessage());
            }
        }
    }

    public void finish(Database.BatchableContext context) {
        System.debug('Batch completado.');
    }

    private static HttpResponse sendGetRequest(asyncRequest request) {
        HttpResponse response = null;
        try {
            String payloadHash = 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855';
            Datetime now = Datetime.now();
            String amzDate = now.formatGMT('yyyyMMdd\'T\'HHmmss\'Z\'');
            String dateStamp = now.formatGMT('yyyyMMdd');

            String canonicalHeaders = 'host:na01-mobile-pr01.s3.amazonaws.com\n' +
                                       'x-amz-content-sha256:' + payloadHash + '\n' +
                                       'x-amz-date:' + amzDate + '\n' +
                                       'x-amz-security-token:' + request.sessionToken + '\n';
            String signedHeaders = 'host;x-amz-content-sha256;x-amz-date;x-amz-security-token';

            String canonicalRequest = 'GET\n' + 
                                        request.canonicalUri + '\n' + 
                                        '' + '\n' + 
                                        canonicalHeaders + '\n' + 
                                        signedHeaders + '\n' + 
                                        payloadHash;

            String credentialScope = dateStamp + '/us-west-1/s3/aws4_request';
            String stringToSign = 'AWS4-HMAC-SHA256\n' + amzDate + '\n' + credentialScope + '\n' + EncodingUtil.convertToHex(Crypto.generateDigest('SHA-256', Blob.valueOf(canonicalRequest)));

            Blob signingKey = getSignatureKey(request.secretAccessKey, dateStamp, 'us-west-1', 's3');
            String signature = EncodingUtil.convertToHex(Crypto.generateMac('HMACSHA256', Blob.valueOf(stringToSign), signingKey));

            String authorizationHeader = 'AWS4-HMAC-SHA256 Credential=' + request.accessKeyId + '/' + credentialScope + ', SignedHeaders=' + signedHeaders + ', Signature=' + signature;

            HttpRequest req = new HttpRequest();
            req.setEndpoint(request.endpoint);
            req.setMethod('GET');
            req.setHeader('Authorization', authorizationHeader);
            req.setHeader('x-amz-content-sha256', payloadHash);
            req.setHeader('x-amz-date', amzDate);
            req.setHeader('x-amz-security-token', request.sessionToken);
            req.setHeader('Connection', 'keep-alive');

            Http http = new Http();
            response = http.send(req);
            System.debug('HTTP Response Code: ' + response.getStatusCode());
        } catch (Exception e) {
            System.debug('Error en sendGetRequest: ' + e.getMessage());
        }
        return response;
    }

    public static void login() {
        try {
            BolivarConfiguration__c credentials = BolivarConfiguration__c.getInstance();
            if (credentials == null) {
                throw new CalloutException('No se encontraron las credenciales de AWS en el Custom Setting.');
            }

            String username = credentials.Username__c;
            String password = credentials.Password__c;

            String auth = username + ':' + password;
            Blob authBlob = Blob.valueOf(auth);
            String authHeader = 'Basic ' + EncodingUtil.base64Encode(authBlob);

            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://fse-na-sb-int01.cloud.clicksoftware.com/SO/api/S3Token');
            req.setMethod('GET');
            req.setHeader('Authorization', authHeader);

            Http http = new Http();
            HttpResponse res = http.send(req);

            if (res.getStatusCode() == 200) {
                Map<String, Object> response = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                accessKeyId = (String) response.get('AccessKeyId');
                secretAccessKey = (String) response.get('SecretAccessKey');
                accessToken = (String) response.get('Token');
            } else {
                throw new CalloutException('Error en login: ' + res.getStatusCode());
            }
        } catch (Exception e) {
            throw new CalloutException('Error en login: ' + e.getMessage());
        }
    }

    private static Blob getSignatureKey(String secretKey, String dateStamp, String regionName, String serviceName) {
        Blob kSecret = Blob.valueOf('AWS4' + secretKey);
        Blob kDate = Crypto.generateMac('HmacSHA256', Blob.valueOf(dateStamp), kSecret);
        Blob kRegion = Crypto.generateMac('HmacSHA256', Blob.valueOf(regionName), kDate);
        Blob kService = Crypto.generateMac('HmacSHA256', Blob.valueOf(serviceName), kRegion);
        return Crypto.generateMac('HmacSHA256', Blob.valueOf('aws4_request'), kService);
    }
}