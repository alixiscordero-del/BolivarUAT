global class CoIT_WOM_GenerateWorkOfferDetails {

    @InvocableMethod(label='Generate Work Offer Details')
    global static List<Results> execute(List<Requests> requestList){

        List<Results> responsesList = new List<Results>();

        for(Requests request : requestList){
            Results response = new Results();

            try{
                Set<String> serviceResourcesIds = new Set<String>();
                List<WOM_WorkOfferDetail__c> wOffers = new List<WOM_WorkOfferDetail__c>();

                FSL.GradeSlotsService mySlotService = new FSL.GradeSlotsService(request.schedulingPolicyId, request.serviceAppointmentId);
                FSL.AdvancedGapMatrix myResultMatrix = mySlotService.getGradedMatrix(true);
                Map<Id, FSL.ResourceScheduleData> mySRGradedTimeSlotMap = myResultMatrix.ResourceIDToScheduleData;

                for(Id i : mySRGradedTimeSlotMap.keySet()){
                    String s = i;
                    serviceResourcesIds.add(s);
                }

                for (Id thisresourceid : serviceResourcesIds){
                    FSL.SchedulingOption thisso = mySRGradedTimeSlotMap.get(thisresourceid).SchedulingOptions[0];
                    WOM_WorkOfferDetail__c wOffer = new WOM_WorkOfferDetail__c(
                        WOM_Interval_Start__c = thisso.Interval.Start,
                        WOM_Interval_Finish__c = thisso.Interval.Finish,
                        WOM_Grade__c = thisso.Grade,
                        WOM_Acceptance_Status__c = 'Pending',
                        ServiceAppointment__c = request.serviceAppointmentId,
                        WOM_Service_Resource__c = thisresourceid
                    );
                    wOffers.add(wOffer);
                }

                if(wOffers.size() > 0){
                    response.wOffers = wOffers;
                }
                else{
                    response.wOffers = null;
                }
            }
            catch(Exception e){
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