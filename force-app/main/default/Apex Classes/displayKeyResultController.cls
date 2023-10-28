public with sharing class displayKeyResultController {
    @AuraEnabled(cacheable=true)
    public static Map<Objective__c, Map<KeyResult__c, List<Target__c>>> getKeyResult(List<Objective__c> objectivesList) {
        List<KeyResult__c> keyResults = new List<KeyResult__c>();
        Map<Objective__c, Map<KeyResult__c, List<Target__c>>> objectiveAndKeyResults = new Map<Objective__c, Map<KeyResult__c, List<Target__c>>>();
        
        List<Target__c> targetList = new List<Target__c>();
        try{
           for(Objective__c objective : objectivesList){
            Map<KeyResult__c, List<Target__c>> keyResultsAndTargets = new Map<KeyResult__c, List<Target__c>>();
            keyResults = [SELECT Id, Name FROM KeyResult__c WHERE Objective__c=: objective.Id];
            System.debug(keyResults);
            for(KeyResult__c keyResult : keyResults){
                targetList = [SELECT Name, TargetValue__c, CurrentValue__c, Type__c FROM Target__c WHERE Key_Result__c=: keyResult.Id];
                system.debug(targetList);
                keyResultsAndTargets.put(keyResult, targetList);
                system.debug(keyResultsAndTargets);
            }
            objectiveAndKeyResults.put(objective, keyResultsAndTargets);
        } 
        }catch (Exception e) {
            System.debug('Error: ' + e.getMessage());
            throw new AuraHandledException('An error occurred while fetching objects');
        }
        

        return objectiveAndKeyResults;
    }
}