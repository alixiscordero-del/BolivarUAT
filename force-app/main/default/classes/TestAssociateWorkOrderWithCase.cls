@isTest
public class TestAssociateWorkOrderWithCase {
    @testSetup
    static void setupTestData() {
        // Obtener los RecordTypes de WorkOrder que ya existen
        RecordType hogaresRecordType = [SELECT Id FROM RecordType WHERE DeveloperName = 'Hogares' AND SObjectType = 'WorkOrder' LIMIT 1];
        RecordType autosRecordType = [SELECT Id FROM RecordType WHERE DeveloperName = 'Autos' AND SObjectType = 'WorkOrder' LIMIT 1];

        // Obtener los RecordTypes de Case que ya existen
        RecordType caseHogaresRecordType = [SELECT Id FROM RecordType WHERE DeveloperName = 'Hogares' AND SObjectType = 'Case' LIMIT 1];
        RecordType caseAutosRecordType = [SELECT Id FROM RecordType WHERE DeveloperName = 'Autos' AND SObjectType = 'Case' LIMIT 1];

        // Crear un Case con el RecordType "Hogares"
        Case caseHogares = new Case(CoIT_Numero_del_Siniestro__c = 'S001', RecordTypeId = caseHogaresRecordType.Id);
        insert caseHogares;

        // Crear un Case con el RecordType "Autos"
        Case caseAutos = new Case(CoIT_Numero_del_Siniestro__c = 'S002', RecordTypeId = caseAutosRecordType.Id);
        insert caseAutos;
    }

    @isTest
    static void testAssociateWorkOrderWithCase() {
        // Obtener los RecordTypes de WorkOrder que ya existen
        RecordType hogaresRecordType = [SELECT Id FROM RecordType WHERE DeveloperName = 'Hogares' AND SObjectType = 'WorkOrder' LIMIT 1];
        RecordType autosRecordType = [SELECT Id FROM RecordType WHERE DeveloperName = 'Autos' AND SObjectType = 'WorkOrder' LIMIT 1];
        
        // Crear una WorkOrder que debería asociarse con el Case de "Hogares"
        WorkOrder woHogares = new WorkOrder(CoIT_Numero_Siniestro__c = 'S001');
        
        // Crear una WorkOrder que debería asociarse con el Case de "Autos"
        WorkOrder woAutos = new WorkOrder(CoIT_Numero_Siniestro__c = 'S002');

        // Ejecutar la inserción para activar el trigger
        insert new List<WorkOrder>{woHogares, woAutos};

        // Verificar que las WorkOrders se hayan asociado correctamente con los Cases
        List<WorkOrder> insertedWorkOrders = [SELECT Id, CaseId, RecordTypeId FROM WorkOrder WHERE CoIT_Numero_Siniestro__c IN ('S001', 'S002')];

        // Asegurarnos de que las WorkOrders tengan los CaseId correctos y el RecordType correcto
        System.assertEquals('S001', [SELECT CoIT_Numero_del_Siniestro__c FROM Case WHERE Id = :insertedWorkOrders[0].CaseId LIMIT 1].CoIT_Numero_del_Siniestro__c);
        System.assertEquals(hogaresRecordType.Id, insertedWorkOrders[0].RecordTypeId);
        
        System.assertEquals('S002', [SELECT CoIT_Numero_del_Siniestro__c FROM Case WHERE Id = :insertedWorkOrders[1].CaseId LIMIT 1].CoIT_Numero_del_Siniestro__c);
        System.assertEquals(autosRecordType.Id, insertedWorkOrders[1].RecordTypeId);
    }

    @isTest
    static void testNoMatchingRecordType() {
        // Crear un Case con un RecordType no mapeado en el trigger
        RecordType unMappedRecordType = [SELECT Id FROM RecordType WHERE DeveloperName = 'Unmapped' AND SObjectType = 'Case' LIMIT 1];

        Case caseUnmapped = new Case(CoIT_Numero_del_Siniestro__c = 'S003', RecordTypeId = unMappedRecordType.Id);
        insert caseUnmapped;

        // Crear una WorkOrder asociada al caso no mapeado
        WorkOrder woUnmapped = new WorkOrder(CoIT_Numero_Siniestro__c = 'S003');
        insert woUnmapped;

        // Verificar que la WorkOrder se asoció con el Case pero no se le asignó un RecordType
        WorkOrder insertedWorkOrder = [SELECT Id, CaseId, RecordTypeId FROM WorkOrder WHERE CoIT_Numero_Siniestro__c = 'S003' LIMIT 1];
        System.assertNotEquals(null, insertedWorkOrder.CaseId);
        System.assertEquals(null, insertedWorkOrder.RecordTypeId, 'No se debe asignar un RecordType si no coincide');
    }
}