@isTest
public class EmailControllerTest {
@isTest
   
    public static void testPdfEmailer() {
		//List<List<String>> args;
       // List<String> nested;
        String[][] args = new String [][]{
            new String[]{'maria.guerrero@colibriit.com','0WO6e000004V3QqGAK'}  
        };
  
		//String email = nested[0] ;
        //String recordId = nested[1];
        String recordId = '0WO6e000004V3QqGAK';
        String[] nested = new String[]{'maria.guerrero@colibriit.com','0WO6e000004V3QqGAK'};
        String email = 'maria.guerrero@colibriit.com';
        
        //nested= {email,recordId} ;
        //args[0]= nested;
        
        
       	//EmailController  con = new EmailController ();    
    
        Test.startTest();
        // Set up a mock PDF body for testing
        Blob mockPdfBlob = Blob.valueOf('Mock PDF content');
        // Set up mock callout response
       
        Test.setCurrentPageReference(new PageReference('/apex/CoIT_RepairPlan_PDF?id=' + recordId ));
        
        // call the method
        try{
            EmailController.generatePDF(args);
        }catch(Exception ex){}
             
        
    
    
        Test.stopTest();
        
      }
    
}