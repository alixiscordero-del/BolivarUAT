global class CoIT_MilestoneCalculator implements Support.MilestoneTriggerTimeCalculator {
    
    Integer diferenciaEnMinutos = 5;  // Variable global del método
    
    global Integer calculateMilestoneTriggerTime(String woId, String milestoneTypeId){
        if (String.isBlank(woId) || String.isBlank(milestoneTypeId)) {
            throw new IllegalArgumentException('Work Order ID and Milestone Type ID must not be null or empty.');
        }
        
        WorkOrder w = [SELECT Id, CoIT_Expected_Travel_Start__c, CoIT_Expected_InProgress_Start__c, DurationInMinutes, CoIT_WOM_Scheduling_type__c FROM WorkOrder WHERE Id =:woId];
        MilestoneType mt = [SELECT Name FROM MilestoneType WHERE Id = :milestoneTypeId];
        
        List<EntityMilestone> emtList =[SELECT TargetResponseInMins FROM EntityMilestone WHERE ParentEntityId =:woId and Name=:mt.Name];
		if (emtList.size() > 0){ // Validación para evitar que procesos asincronos modifiquen el Milestone 
            diferenciaEnMinutos = emtList[0].TargetResponseInMins;
        } else if(mt.Name != null && mt.Name.equals('Esperando por En Viaje') && w.CoIT_Expected_InProgress_Start__c != null){
            Long diferenciaMS;
            if (w.CoIT_Expected_Travel_Start__c != null){ // Si el campo Estimated Travel Time (Minutes) del Assigned Resource no es nulo
                diferenciaMS = w.CoIT_Expected_Travel_Start__c.getTime() - System.now().getTime(); // Se toma la fecha esperada de inicio de viaje 
            }else{ // si es nulo
                diferenciaMS = w.CoIT_Expected_InProgress_Start__c.getTime() - System.now().getTime(); // Se toma la fecha esperada de inicio del servicio (inicio agendado) 
            }
            diferenciaEnMinutos = (Integer) (diferenciaMS / (1000 * 60)) + 5; 
            if (diferenciaEnMinutos < 5) { // Asegura que siempre se le den minimo 5 min al tecnico para iniciar el viaje
                diferenciaEnMinutos = 5;
            }
        } else if (mt.Name != null && mt.Name.equals('Esperando por En Progreso') && w.CoIT_Expected_InProgress_Start__c != null){
            Long diferenciaMS = w.CoIT_Expected_InProgress_Start__c.getTime() - System.now().getTime();
            diferenciaEnMinutos = (Integer) (diferenciaMS / (1000 * 60));
        } else if(mt.Name != null && mt.Name.equals('Esperando por Completado') && w.DurationInMinutes != null){
            diferenciaEnMinutos =  w.DurationInMinutes.intValue();
        }else if (w.CoIT_Expected_InProgress_Start__c == null || w.DurationInMinutes == null){
            diferenciaEnMinutos = 5;
        }
        if (diferenciaEnMinutos <= 0) {
            diferenciaEnMinutos = 5;
        }
        System.debug(diferenciaEnMinutos);
        return diferenciaEnMinutos; // Devuelve la diferencia calculada
    } 
}