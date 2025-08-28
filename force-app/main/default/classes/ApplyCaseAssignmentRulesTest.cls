@isTest 
      public class ApplyCaseAssignmentRulesTest{
      static testMethod void createnewcase() {
      
      Test.startTest();    
      Case caseToCreate =new Case();
      List<id> Ids= New List<Id>();
      caseToCreate.Subject='Salesforce Time';
      caseToCreate.Description='Salesforce Time - ApplyCaseAssignmentRulesTest';
      caseToCreate.CoIT_Numero_del_Siniestro__c = '123456';
      insert caseToCreate; 
      
      Ids.add(caseToCreate.id);
      ApplyCaseAssignmentRules.CaseAssign(Ids);
      
      Test.stopTest();
   }
}