@RestResource(urlMapping = '/api/CreateMigrationClick')
global with sharing class CoIT_MigrationClick {

    global class CreateRequest {
        @InvocableVariable(required = true)
        public String NumeroCasoSIAB;
        @InvocableVariable(required = false)
        public String CallID;
        @InvocableVariable(required = false)
        public Integer NumeroServicio;
        @InvocableVariable(required = false)
        public String Causa;
        @InvocableVariable(required = false)
        public String Direccion;
        @InvocableVariable(required = false)
        public Boolean BLPUDO;
        @InvocableVariable(required = false)
        public String CiudadCliente;
        @InvocableVariable(required = false)
        public DateTime FechaCompletada;
        @InvocableVariable(required = false)
        public String DocumentoCustomer;
        @InvocableVariable(required = false)
        public String EmailCustomer;
        @InvocableVariable(required = false)
        public String NombreCustomer;
        @InvocableVariable(required = false)
        public String TelefonoCustomer;
        @InvocableVariable(required = false)
        public String Descripcion;
        @InvocableVariable(required = false)
        public String DocumentoProveedor;
        @InvocableVariable(required = false)
        public String Latitude;
        @InvocableVariable(required = false)
        public String Longitude;
        @InvocableVariable(required = false)
        public DateTime FechaEnSitio;
        @InvocableVariable(required = false)
        public DateTime FechaAbierto;
        @InvocableVariable(required = false)
        public String RToken;
        @InvocableVariable(required = false)
        public String TaskStatus;
        @InvocableVariable(required = false)
        public String DocumentoSupervisor;
        @InvocableVariable(required = false)
        public String NombreSupervisor;
        @InvocableVariable(required = false)
        public String DocumentoTecnico;
        @InvocableVariable(required = false)
        public String NombreTecnico;
        @InvocableVariable(required = false)
        public String TipoTareaClick;
        @InvocableVariable(required = false)
        public DateTime FechaTravel;
        @InvocableVariable(required = false)
        public DateTime FechaAssignmentStart;
        @InvocableVariable(required = false)
        public DateTime FechaAssignmentFinish;
        public List<AttachmentData> Attachments;
    }

    global class AttachmentData {
        public String FileName;
        public DateTime TimeAttached;
        public String UploadedBy;
        public String ExternalKey_SO;
        public String ExternalURL_SO;
        public String CallIDatt;
    }

    @HttpPost
    global static String crearSFSMigrationClick(CreateRequest request) {
        try {
            // Validar si el arreglo de adjuntos es nulo o vacío o si no contiene elementos válidos
            if (request.Attachments == null || request.Attachments.isEmpty()) {
                return 'El arreglo Attachments está vacío o no contiene datos válidos. No se realizó ninguna acción.';
            }

            // Filtrar adjuntos válidos (con ExternalURL_SO no nulo o vacío)
            List<AttachmentData> validAttachments = new List<AttachmentData>();
            for (AttachmentData att : request.Attachments) {
                if (att.ExternalURL_SO != null && !String.isEmpty(att.ExternalURL_SO)) {
                    validAttachments.add(att);
                }
            }

            // Si no hay adjuntos válidos, no hacer nada
            if (validAttachments.isEmpty()) {
                return 'No se encontraron adjuntos válidos en el arreglo Attachments. No se realizó ninguna acción.';
            }

            // Crear la orden de trabajo SFS Migration
            CoIT_SFS_Migration_Click__c nuevaRequisito = crearOrdenDeTrabajo(request);

            // Crear adjuntos asociados (solo con los válidos)
            createCOITAttachments(validAttachments, request.CallID, request.NumeroServicio);

            // Actualizar el campo Ready_to_Process a true
            nuevaRequisito.CoIT_Ready_to_Process__c = true;
            update nuevaRequisito;

            return 'Creación exitosa del objeto Migration Bolivar.';
        } catch (Exception e) {
            return 'Error al procesar la solicitud: ' + e.getMessage();
        }
    }

    private static CoIT_SFS_Migration_Click__c crearOrdenDeTrabajo(CreateRequest request) {
        CoIT_SFS_Migration_Click__c nuevaRequisito = new CoIT_SFS_Migration_Click__c(
            CoIT_Numero_Caso_SIAB__c = request.NumeroCasoSIAB,
            CoIT_Call_ID__c = request.CallID,
            CoIT_Source_Number__c = request.NumeroServicio,
            CoIT_Cause__c = request.Causa,
            CoIT_Client_Address__c = request.Direccion,
            CoIT_Client_City__c = request.CiudadCliente,
            CoIT_Completion_Date__c = request.FechaCompletada,
            CoIT_Customer_Document__c = request.DocumentoCustomer,
            CoIT_BLPUDO__c = request.BLPUDO,
            CoIT_Customer_Email__c = request.EmailCustomer,
            CoIT_Customer_Name__c = request.NombreCustomer,
            CoIT_Customer_Phone_Number__c = request.TelefonoCustomer,
            CoIT_Description__c = request.Descripcion,
            CoIT_Document_Provideer__c = request.DocumentoProveedor,
            CoIT_Latitude__c = request.Latitude,
            CoIT_Longitude__c = request.Longitude,
            CoIT_OnSite_Date__c = request.FechaEnSitio,
            CoIT_Open_Date__c = request.FechaAbierto,
            CoIT_AssignmentStart__c = request.FechaAssignmentStart,
            CoIT_AssignmentFinish__c = request.FechaAssignmentFinish,
            CoIT_RToken__c = request.RToken,
            CoIT_Supervisor_Document__c = request.DocumentoSupervisor,
            CoIT_Supervisor_Name__c = request.NombreSupervisor,
            CoIT_Technicial_Document__c = request.DocumentoTecnico,
            CoIT_Technicial_Name__c = request.NombreTecnico,
            CoIT_Type_Task_Click__c = request.TipoTareaClick,
            CoIT_Travel_Date__c = request.FechaTravel,
            CoIT_Status__c = request.TaskStatus
        );
        insert nuevaRequisito;
        return nuevaRequisito;
    }

    public static void createCOITAttachments(List<AttachmentData> attachments, String CallID,Decimal Numero) {
        List<CoIT_SFS_Attachment_Click__c> attachmentList = new List<CoIT_SFS_Attachment_Click__c>();

        for (AttachmentData att : attachments) {
            if (att.ExternalURL_SO != null && !String.isEmpty(att.ExternalURL_SO)) {
                String sanitizedExternalURL = att.ExternalURL_SO.replace(' ', '%20');
                String santizedFileName = att.FileName != null ? att.FileName.replace(' ', '_') : null;
                CoIT_SFS_Attachment_Click__c newAtt = new CoIT_SFS_Attachment_Click__c(
                    CoIT_File_Name__c = santizedFileName,
                    CoIT_Call_ID__c = CallID,
                    CoIT_Number__c =  Numero,
                    CoIT_Time_Attached__c = att.TimeAttached,
                    CoIT_UploadedBy__c = att.UploadedBy,
                    CoIT_ExternalKey_SO__c = att.ExternalKey_SO,
                    CoIT_ExternalURL_SO__c = sanitizedExternalURL,
                    CoIT_Is_Pending_Upload__c = true
                );
                attachmentList.add(newAtt);
            }
        }

        if (!attachmentList.isEmpty()) {
            insert attachmentList;

            for (CoIT_SFS_Attachment_Click__c attachment : attachmentList) {
                attachment.CoIT_Activation_Click__c = true;
            }

            update attachmentList;
        }
    }
}