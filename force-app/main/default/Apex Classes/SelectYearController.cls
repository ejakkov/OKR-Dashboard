public with sharing class SelectYearController {
    @AuraEnabled(cacheable=true)
    public static List<Integer> getYears() {

        List <Objective__c> dates = [SELECT Date__c FROM Objective__c];
        List<Integer> listOfYears = new List<Integer>();
        Set<Integer> uniqueYearsSet = new Set<Integer>();

        for(integer i=0; i<dates.size(); i++){
            listOfYears.add(dates[i].Date__c.year());
        }

        for (Integer year : listOfYears) {
            uniqueYearsSet.add(year);
        }

        List<Integer> uniqueYearsList = new List<Integer>(uniqueYearsSet);
    return listOfYears;  
}
}