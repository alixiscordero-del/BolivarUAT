public class EmailController {
    @InvocableMethod(label='Email Invoice PDF' description='Generates and Emails an Invoice PDF')
    public static void generatePDF(List<List<String>> args){
        List<String> nested = args[0];
        
        String email = nested[0];
        String recordId = nested[1];
        
        PageReference invoicePDF = new PageReference('/apex/CoIT_RepairPlan_PDF?Id=' + recordId);
        
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setContentType('application/pdf');
        attachment.setFileName('Reporte PDF.pdf');
        
        // Test Methods do not allow getContent calls so pass a blob if test is executing this code
        if(!test.isRunningTest()){
            attachment.body = invoicePDF.getContent();
        } else {
           attachment.body = blob.valueOf('blob');
        }
        
        attachment.setInline(false);
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {email});
        mail.setSubject('Plan de Reparación');
        mail.setHtmlBody('A continuación encontrará adjunto el Plan de Reparación.');
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attachment });
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
    }

}