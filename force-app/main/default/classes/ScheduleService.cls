global class ScheduleService {

    global class InputResult {
        @InvocableVariable(required=true)
        public String policyId; 
        @InvocableVariable(required=true)
        public String serviceId;
    }

    global class OutputResult {
        @InvocableVariable
        public String resultMessage;
         @InvocableVariable
        public String scheduledResourceId ;
    }

    @InvocableMethod(label='Schedule Service from Flow' description='Invokes Schedule Service from a Flow passing Policy and Service IDs')
    global static List<OutputResult> testSchedule(List<InputResult> inputList) 
    {
        List<OutputResult> results = new List<OutputResult>();
        for (InputResult input : inputList) 
        {
            // Llamada al método ScheduleExtended
            List<FSL.ScheduleResult> extendedResults = FSL.ScheduleService.ScheduleExtended(input.policyId, input.serviceId);
            System.debug('Resultados Extendidos: ' + extendedResults);

            // Crear resultado de salida
            OutputResult result = new OutputResult();
            result.resultMessage = 'Result Message: ' + extendedResults ;
            if (!extendedResults.isEmpty()) {
            	FSL.ScheduleResult scheduleResult = extendedResults[0];
                ServiceResource serviceResource = scheduleResult.Resource;
                result.scheduledResourceId = serviceResource.Id;
            }
            results.add(result);
        }
        return results;
    }
}