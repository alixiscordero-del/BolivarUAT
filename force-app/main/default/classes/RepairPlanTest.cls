@isTest
public class RepairPlanTest{
    @isTest
    public static void testCoIT_RepairPlanController() {
       
         // Crear un registro de WorkOrderLineItem 
        WorkOrderLineItem woli = new WorkOrderLineItem(
            WorkOrderId = '0WOO8000005JDWXOA4',
            Subject = 'Test Subject',
            Description = 'Test Description'
            
        );
        insert woli;

        // Crear un registro de ProductRequired
        ProductRequired productRequired = new ProductRequired(
            Product2Id = '01t8M000002zDzvQAE',
            CoIT_Quantity_Affected__c = 10,
            QuantityRequired = 5,
            ParentRecordId = woli.WorkOrderId
        );
        insert productRequired;

        // Crear un registro de Expense 
        Expense expense = new Expense(
            Amount= 20000,
            TransactionDate = system.today(),
			Description = 'Test Expense',
            Quantity = 3,
            CoIT_WorkOrderLineItemId__c = woli.Id
        );
        insert expense;
       
   
        // Inicialización de la instancia del controlador
        Test.startTest();
        PageReference pageRef = Page.CoIT_RepairPlan_PDF;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController stdController = new ApexPages.StandardController(woli);
        CoIT_RepairPlanController controller = new CoIT_RepairPlanController(stdController);
        //Ejecución del metodo 
        controller.setupWorkOrderLineItem();
         // Llamada al método delCont con el ID del registro a eliminar
        controller.contIdChosen = woli.Id;
      	pageRef = controller.delCont();

        //Prueba de mapas actualizados

        System.assertEquals('Test Expense', Expense.Description);
        System.assertEquals(system.today(), Expense.TransactionDate);
      	System.assertEquals(3, Expense.Quantity);
        System.assertEquals(20000, Expense.Amount);
        
        
        
        

        Test.stopTest();
    }
}