trigger ServiceAppointmentUpdater on AutoSchedule_ServiceAppointment__e (after insert) {
    

    Set<Id> workOrderIds = new Set<Id>();
    for (AutoSchedule_ServiceAppointment__e event : Trigger.new) {
        workOrderIds.add(event.WorkOrderId__c);
    }

    List<ServiceAppointment> appointmentsToUpdate = [SELECT Id, FSSK__FSK_Work_Order__c, FSL__Auto_Schedule__c FROM ServiceAppointment WHERE FSSK__FSK_Work_Order__c IN :workOrderIds];
 
    for (ServiceAppointment sa : appointmentsToUpdate) {
        for (AutoSchedule_ServiceAppointment__e event : Trigger.new) {
            if (sa.FSSK__FSK_Work_Order__c == event.WorkOrderId__c) {
                sa.FSL__Auto_Schedule__c = true; // Actualiza el campo durante ejecución normal
            }
        }
    }

    if (!appointmentsToUpdate.isEmpty()) {
        update appointmentsToUpdate;
    }
}