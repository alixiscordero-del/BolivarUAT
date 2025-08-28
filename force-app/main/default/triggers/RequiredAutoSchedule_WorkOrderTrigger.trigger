trigger RequiredAutoSchedule_WorkOrderTrigger on WorkOrder (after insert) {
    List<AutoSchedule_ServiceAppointment__e> events = new List<AutoSchedule_ServiceAppointment__e>();
    for (WorkOrder wo : Trigger.new) {
       
         if (wo.CoIT_Require_Rescheduled__c != null && wo.CoIT_Require_Rescheduled__c == true){ // Verifica si el campo es verdadero
           
            AutoSchedule_ServiceAppointment__e event = new AutoSchedule_ServiceAppointment__e(
                WorkOrderId__c = wo.Id
            );
            events.add(event);
        }
    }
    if (!events.isEmpty()) {
        EventBus.publish(events);
    }
}