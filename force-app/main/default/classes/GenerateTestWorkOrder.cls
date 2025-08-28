global class GenerateTestWorkOrder  {
    @InvocableMethod(label='Generate Work Offer Details Test Details')
    global static List<Results> execute(List<Requests> requestList){
        List<Results> responsesList = new List<Results>();
        
        for (Requests request : requestList) {
            Results response = new Results();
            
            try {
                FSL.GradeSlotsService slotService = new FSL.GradeSlotsService(request.schedulingPolicyId, request.serviceAppointmentId);
                FSL.AdvancedGapMatrix resultMatrix = slotService.getGradedMatrix(true);
                Map<Id, FSL.ResourceScheduleData> resourceScheduleMap = resultMatrix.ResourceIDToScheduleData;
                
                List<WOM_WorkOfferDetail__c> wOffers = new List<WOM_WorkOfferDetail__c>();
                
                for (Id resourceId : resourceScheduleMap.keySet()) {
                    FSL.ResourceScheduleData scheduleData = resourceScheduleMap.get(resourceId);
                    if (scheduleData.SchedulingOptions != null && !scheduleData.SchedulingOptions.isEmpty()) {
                        FSL.SchedulingOption option = scheduleData.SchedulingOptions[0];
                        
                        wOffers.add(new WOM_WorkOfferDetail__c(
                            WOM_Interval_Start__c = option.Interval.Start,
                            WOM_Interval_Finish__c = option.Interval.Finish,
                            WOM_Grade__c = option.Grade,
                            WOM_Acceptance_Status__c = 'Pending',
                            ServiceAppointment__c = request.serviceAppointmentId,
                            WOM_Service_Resource__c = resourceId
                        ));
                    }
                }
                
                if (!wOffers.isEmpty()) {
                    response.wOffers = wOffers;
                }
                
            } catch (Exception e) {
                response.error = e.getMessage();
            }
            
            responsesList.add(response);
        }
        
        return responsesList;
    }
    global class Requests {
        @InvocableVariable(label='Scheduling Policy Id' required=true)
        public String schedulingPolicyId;
        @InvocableVariable(label='Service Appointment Id' required=true)
        public String serviceAppointmentId;
    }
    global class Results {
        @InvocableVariable(label='Work Offers')
        public List<WOM_WorkOfferDetail__c> wOffers;
        @InvocableVariable(label='Error')
        public String error;
    }
}