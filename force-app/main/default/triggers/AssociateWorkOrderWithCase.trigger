trigger AssociateWorkOrderWithCase on WorkOrder (before insert) {
    // Mapeo de valores de Line_de_Negocio__c a RecordType DeveloperName
    Map<String, String> lineaNegocioToRecordTypeMap = new Map<String, String>{
        'Hogares' => 'Hogares',
        'Autos' => 'Autos'
    };

    // Obtener mapeo de DeveloperName de RecordType a Id
    Map<String, Id> recordTypeMap = new Map<String, Id>();
    for (RecordType rt : [SELECT Id, DeveloperName FROM RecordType WHERE SObjectType = 'WorkOrder']) {
        recordTypeMap.put(rt.DeveloperName, rt.Id);
    }

    List<Case> relatedCasesToUpdate = new List<Case>();

    // Recorre todas las órdenes de trabajo insertadas
    for (WorkOrder wo : Trigger.new) {
        // Busca los casos correspondientes basados en el número de siniestro externo
        List<Case> relatedCases = [SELECT Id, RecordType.Name FROM Case WHERE CoIT_Numero_del_Siniestro__c = :wo.CoIT_Numero_Siniestro__c];

        // Asocia las órdenes de trabajo con los casos encontrados
        for (Case c : relatedCases) {
            
             wo.CaseId = c.Id;
             relatedCasesToUpdate.add(c);
            
            if (lineaNegocioToRecordTypeMap.containsKey(c.RecordType.Name)) {
                // Asignar el RecordTypeId basado en la Line_de_Negocio__c
                String recordTypeDeveloperName = lineaNegocioToRecordTypeMap.get(c.RecordType.Name);
                if (recordTypeMap.containsKey(recordTypeDeveloperName)) {
                    wo.RecordTypeId = recordTypeMap.get(recordTypeDeveloperName);
                   
                } else {
                    // Manejar el caso donde no se encuentra el RecordType
                    System.debug('No se encontró el RecordType para el DeveloperName: ' + recordTypeDeveloperName);
                    // Aquí podrías manejar este caso de manera diferente, según tus necesidades
                }
            } else {
                // Manejar el caso donde no se encuentra una línea de negocio correspondiente
                System.debug('No se encontró una línea de negocio correspondiente: ' + c.RecordType.Name);
                // Aquí podrías manejar este caso de manera diferente, según tus necesidades
            }
        }
    }

    // Actualiza los casos asociados con las órdenes de trabajo
    if (!relatedCasesToUpdate.isEmpty()) {
        update relatedCasesToUpdate;
    }
}