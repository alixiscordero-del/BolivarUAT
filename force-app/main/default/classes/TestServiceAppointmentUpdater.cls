@isTest
public class TestServiceAppointmentUpdater {

    @testSetup
    static void setupTestData() {
        WorkOrder wo = new WorkOrder(
            CoIT_Numero_Siniestro__c = '123456', 
            Status = 'Open'
        );
        insert wo;

        ServiceAppointment sa = new ServiceAppointment(
            FSSK__FSK_Work_Order__c = wo.Id,
            FSL__Auto_Schedule__c = false
        );
        insert sa;
    }

    @isTest
    static void testServiceAppointmentUpdate() {
        WorkOrder wo = [SELECT Id FROM WorkOrder LIMIT 1];
        
        AutoSchedule_ServiceAppointment__e autoScheduleEvent = new AutoSchedule_ServiceAppointment__e(
            WorkOrderId__c = wo.Id
        );
        
        Test.startTest();
        EventBus.publish(autoScheduleEvent);
        Test.stopTest();

        ServiceAppointment updatedAppointment = [SELECT Id, FSL__Auto_Schedule__c FROM ServiceAppointment WHERE FSSK__FSK_Work_Order__c = :wo.Id LIMIT 1];
        
        System.assertEquals(true, updatedAppointment.FSL__Auto_Schedule__c, 'El campo FSL__Auto_Schedule__c debería estar en true');
    }
}