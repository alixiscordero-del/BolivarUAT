@IsTest
public class CoIT_MilestoneCalculatorTest {

    @TestSetup
    static void setupTestData() {
        // Crear un perfil de prueba
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User' LIMIT 1];

        // Crear un usuario de prueba para poder usar System.runAs
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.com',
            Username = 'testuser' + DateTime.now().getTime() + '@example.com',
            Alias = 'tuser',
            TimeZoneSidKey = 'GMT',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = p.Id,
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;

        // Insertar WorkOrders primero, ya que son objetos no configurables.
        WorkOrder woEmergency = new WorkOrder(
            CoIT_Expected_Travel_Start__c = System.now().addMinutes(10),
            CoIT_Expected_InProgress_Start__c = System.now().addMinutes(30),
            Duration = 60,
            CoIT_WOM_Scheduling_type__c = 'Emergency',
            CoIT_Numero_Siniestro__c = '34565435'
        );
        insert woEmergency;

        WorkOrder woProgrammed = new WorkOrder(
            CoIT_Expected_Travel_Start__c = System.now().addMinutes(10),
            CoIT_Expected_InProgress_Start__c = System.now().addMinutes(30),
            Duration = 60,
            CoIT_WOM_Scheduling_type__c = 'Programmed',
            CoIT_Numero_Siniestro__c = '34565436'
        );
        insert woProgrammed;

        // Insertar MilestoneTypes en un contexto de usuario diferente para evitar MIXED_DML_OPERATION
        System.runAs(testUser) {
            // Generar un sufijo único basado en la hora actual
            String uniqueSuffix = String.valueOf(DateTime.now().getTime());

            // Crear MilestoneTypes con nombres únicos
            MilestoneType mtTravel = new MilestoneType(Name = 'Esperando por En Viaje ' + uniqueSuffix);
            MilestoneType mtInProgress = new MilestoneType(Name = 'Esperando por En Progreso ' + uniqueSuffix);
            MilestoneType mtCompleted = new MilestoneType(Name = 'Esperando por Completado ' + uniqueSuffix);
            insert new List<MilestoneType>{mtTravel, mtInProgress, mtCompleted};
        }
    }

    @IsTest
    static void testCalculateMilestoneTriggerTimeEmergencyTravel() {
        List<WorkOrder> woList = [SELECT Id FROM WorkOrder WHERE CoIT_WOM_Scheduling_type__c = 'Emergency' LIMIT 1];
        List<MilestoneType> mtList = [SELECT Id FROM MilestoneType WHERE Name LIKE 'Esperando por En Viaje%' LIMIT 1];
        
        if (!woList.isEmpty() && !mtList.isEmpty()) {
            WorkOrder wo = woList[0];
            MilestoneType mt = mtList[0];
            
            CoIT_MilestoneCalculator calculator = new CoIT_MilestoneCalculator();
            Integer result = calculator.calculateMilestoneTriggerTime(wo.Id, mt.Id);
            
            System.assert(result > 0);
        } else {
            System.assert(false, 'Required test data not found.');
        }
    }

    @IsTest
    static void testCalculateMilestoneTriggerTimeEmergencyInProgress() {
        List<WorkOrder> woList = [SELECT Id FROM WorkOrder WHERE CoIT_WOM_Scheduling_type__c = 'Emergency' LIMIT 1];
        List<MilestoneType> mtList = [SELECT Id FROM MilestoneType WHERE Name LIKE 'Esperando por En Progreso%' LIMIT 1];
        
        if (!woList.isEmpty() && !mtList.isEmpty()) {
            WorkOrder wo = woList[0];
            MilestoneType mt = mtList[0];
            
            CoIT_MilestoneCalculator calculator = new CoIT_MilestoneCalculator();
            Integer result = calculator.calculateMilestoneTriggerTime(wo.Id, mt.Id);
            
            System.assert(result > 0);
        } else {
            System.assert(false, 'Required test data not found.');
        }
    }


    @IsTest
    static void testCalculateMilestoneTriggerTimeProgrammedTravel() {
        List<WorkOrder> woList = [SELECT Id FROM WorkOrder WHERE CoIT_WOM_Scheduling_type__c = 'Programmed' LIMIT 1];
        List<MilestoneType> mtList = [SELECT Id FROM MilestoneType WHERE Name LIKE 'Esperando por En Viaje%' LIMIT 1];
        
        if (!woList.isEmpty() && !mtList.isEmpty()) {
            WorkOrder wo = woList[0];
            MilestoneType mt = mtList[0];
            
            CoIT_MilestoneCalculator calculator = new CoIT_MilestoneCalculator();
            Integer result = calculator.calculateMilestoneTriggerTime(wo.Id, mt.Id);
            
            System.assert(result > 0);
        } else {
            System.assert(false, 'Required test data not found.');
        }
    }

    @IsTest
    static void testCalculateMilestoneTriggerTimeProgrammedInProgress() {
        List<WorkOrder> woList = [SELECT Id FROM WorkOrder WHERE CoIT_WOM_Scheduling_type__c = 'Programmed' LIMIT 1];
        List<MilestoneType> mtList = [SELECT Id FROM MilestoneType WHERE Name LIKE 'Esperando por En Progreso%' LIMIT 1];
        
        if (!woList.isEmpty() && !mtList.isEmpty()) {
            WorkOrder wo = woList[0];
            MilestoneType mt = mtList[0];
            
            CoIT_MilestoneCalculator calculator = new CoIT_MilestoneCalculator();
            Integer result = calculator.calculateMilestoneTriggerTime(wo.Id, mt.Id);
            
            System.assert(result > 0);
        } else {
            System.assert(false, 'Required test data not found.');
        }
    }

    @IsTest
    static void testCalculateMilestoneTriggerTimeNullValues() {
        WorkOrder wo = new WorkOrder(
            CoIT_WOM_Scheduling_type__c = 'Emergency',
            CoIT_Numero_Siniestro__c = '34565436'
            
        );
        insert wo;

        List<MilestoneType> mtList = [SELECT Id FROM MilestoneType WHERE Name LIKE 'Esperando por En Viaje%' LIMIT 1];

        if (!mtList.isEmpty()) {
            MilestoneType mt = mtList[0];

            CoIT_MilestoneCalculator calculator = new CoIT_MilestoneCalculator();
            Integer result = calculator.calculateMilestoneTriggerTime(wo.Id, mt.Id);

            System.assertEquals(5, result);
        } else {
            System.assert(false, 'Required test data not found.');
        }
    }

    @IsTest
    static void testCalculateMilestoneTriggerTimeInvalidIds() {
        CoIT_MilestoneCalculator calculator = new CoIT_MilestoneCalculator();
        
        try {
            calculator.calculateMilestoneTriggerTime(null, null);
            System.assert(false, 'Expected IllegalArgumentException for null IDs');
        } catch (IllegalArgumentException e) {
            System.assertEquals('Work Order ID and Milestone Type ID must not be null or empty.', e.getMessage());
        }
    }
}