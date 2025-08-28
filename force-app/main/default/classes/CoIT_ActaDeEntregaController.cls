public class CoIT_ActaDeEntregaController {
private ApexPages.StandardController stdCtrl {get; set;}
    public List<WorkOrderLineItem> Wolis {get; set;}
    public Map<Id, List<ProductRequired>> mapProductRequired {get; set;}
    public Map<Id, List<Expense>> mapExpense {get; set;}
    public String contIdChosen {get; set;}
    private Integer i;
    
    public CoIT_ActaDeEntregaController(ApexPages.StandardController std)
    {
        stdCtrl=std;
        setupWorkOrderLineItem();
    }
    
    public void setupWorkOrderLineItem()
    {
        mapProductRequired = new Map<Id, List<ProductRequired>>();
        mapExpense = new Map<Id, List<Expense>>();
        
        
        Wolis=[select id, LineItemNumber, Subject, Description, CoIT_WorkType_Name__c FROM WorkOrderLineItem where WorkOrderId=:stdCtrl.getId() order by LineItemNumber ASC];
        
        for (i=0; i< Wolis.size();i++) {
            List<ProductRequired> queryProductRequired;
    		List<Expense> queryExpense;
    		queryProductRequired=[select id, CoIT_ZoneName__c, CoIT_Quantity_Affected__c, QuantityRequired FROM ProductRequired where ParentRecordId =:Wolis[i].id];
        	queryExpense=[select id, CoIT_ZoneName__c, Description, Quantity FROM Expense where CoIT_WorkOrderLineItemId__c =:Wolis[i].id];
            system.debug(queryProductRequired);	
            system.debug(queryExpense);	
            mapProductRequired.put(Wolis[i].id, queryProductRequired);
            mapExpense.put(Wolis[i].id, queryExpense);
		}
    }
    
    public PageReference delCont()
    {
        WorkOrderLineItem toDel=new WorkOrderLineItem(id=contIdChosen);
        delete todel;
        setupWorkOrderLineItem();
        return null;
    }
}