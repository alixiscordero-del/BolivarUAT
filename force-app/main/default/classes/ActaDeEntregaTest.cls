@isTest
public class ActaDeEntregaTest {
    @isTest
    public static void testCoIT_RepairPlanController() {
        // Create a WorkOrder record to link to the WorkOrderLineItem
        WorkOrder workOrder = new WorkOrder(
            Subject = 'Test Work Order',
            Status = 'Open', // or another valid status value
            CoIT_Numero_Siniestro__c = '1235'
        );
        insert workOrder;

        // Create a WorkOrderLineItem record
        WorkOrderLineItem woli = new WorkOrderLineItem(
            WorkOrderId = workOrder.Id, // Using the inserted WorkOrder Id
            Subject = 'Test Subject',
            Description = 'Test Description'
        );
        insert woli;

        // Create a ProductRequired record
        ProductRequired productRequired = new ProductRequired(
            Product2Id = '01t8M000002zDzvQAE',
            CoIT_Quantity_Affected__c = 10,
            QuantityRequired = 5,
            ParentRecordId = woli.WorkOrderId
        );
        insert productRequired;

        // Create an Expense record
        Expense expense = new Expense(
            Amount = 20000,
            TransactionDate = system.today(),
            Description = 'Test Expense',
            Quantity = 3,
            CoIT_WorkOrderLineItemId__c = woli.Id
        );
        insert expense;

        // Initialize the controller instance
        Test.startTest();
        PageReference pageRef = Page.CoIT_ActaDeEntrega_PDF;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController stdController = new ApexPages.StandardController(woli);
        CoIT_ActaDeEntregaController controller = new CoIT_ActaDeEntregaController(stdController);

        // Execute the method
        controller.setupWorkOrderLineItem();

        // Set contIdChosen and call delCont
        controller.contIdChosen = woli.Id;
        pageRef = controller.delCont();

        // Assert the updated values
        System.assertEquals('Test Expense', expense.Description);
        System.assertEquals(system.today(), expense.TransactionDate);
        System.assertEquals(3, expense.Quantity);
        System.assertEquals(20000, expense.Amount);

        Test.stopTest();
    }
}