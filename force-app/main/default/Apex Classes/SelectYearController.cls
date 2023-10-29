public with sharing class SelectYearController {
    @AuraEnabled(cacheable=true)
    public static List<Integer> getYears() {

        List <Objective__c> dates = [SELECT Year__c FROM Objective__c];
        Set<Integer> uniqueYearsSet = new Set<Integer>();

        for(Integer i=0; i<dates.size(); i++){
            uniqueYearsSet.add(Integer.valueOf(dates[i].Year__c));
        }
        
        List<Integer> uniqueYearsList = new List<Integer>(uniqueYearsSet);
        System.debug(uniqueYearsList);
    return uniqueYearsList;  
}
}