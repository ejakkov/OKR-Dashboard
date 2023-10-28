public with sharing class displayObjectiveController {
    @AuraEnabled(cacheable=true)
    public static List<Objective__c> getObjective(String userId) {
        List<Objective__c> objectives = new List<Objective__c>();
        try {
            objectives = [SELECT Name, Id FROM Objective__c WHERE User__c = :userId];
        } catch (Exception e) {
            System.debug('Error: ' + e.getMessage());
            throw new AuraHandledException('An error occurred while fetching objectives.');
        }
        return objectives;
    }
}