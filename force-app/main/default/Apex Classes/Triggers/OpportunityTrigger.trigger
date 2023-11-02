trigger OpportunityTrigger on Opportunity (after insert, before update, before delete) {
    List<Opportunity> existingRecords = new List<Opportunity>();
    Map<Id, Integer> targetReviewCount = new Map<Id, Integer>();
    Map<Id, Integer> targetRecordCountMap= new Map<Id, Integer>();
    List<Id> targetIdList = new List<Id>();
    if(Trigger.isInsert){
        List<Opportunity> newRecords = Trigger.new;
        for (Opportunity newRecord : newRecords){
            targetIdList.add(newRecord.Target__c);
        }
        List<Opportunity> existingRecords = [SELECT Target__c FROM Opportunity WHERE Opportunity.Target__c IN :targetIdList];
        for (Opportunity record : existingRecords) {
            if (!targetRecordCountMap.containsKey(record.Target__c)) {
                targetRecordCountMap.put(record.Target__c, 1);
            } else {
                targetRecordCountMap.put(record.Target__c, targetRecordCountMap.get(record.Target__c) + 1);
            }
        }
        for (Opportunity record : newRecords) {
            if(targetRecordCountMap.containsKey(record.Target__c)){
                Id targetId = record.Target__c;
                targetReviewCount.put(targetId, targetRecordCountMap.get(record.Target__c));
            }
    }
    }
    
    if (Trigger.isDelete) {
        List<Opportunity> deletedRecords = Trigger.old;
        for (Opportunity oldRecord : deletedRecords){
            targetIdList.add(oldRecord.Target__c);
        }
        List<Opportunity> existingRecords = [SELECT Target__c FROM Opportunity WHERE Opportunity.Target__c IN :targetIdList];

        for (Opportunity record : existingRecords) {
            if (!targetRecordCountMap.containsKey(record.Target__c)) {
                targetRecordCountMap.put(record.Target__c, 1);
            } else {
                targetRecordCountMap.put(record.Target__c, targetRecordCountMap.get(record.Target__c) + 1);
            }
        }

        for (Opportunity record : deletedRecords) {
            if(targetRecordCountMap.containsKey(record.Target__c)){
                Id targetId = record.Target__c;
                targetReviewCount.put(targetId, targetRecordCountMap.get(record.Target__c));
            }
    }
}

    List<Target__c> targetsList = [SELECT Id FROM Target__c WHERE Id IN :targetReviewCount.keySet()];
    List<Target__c> targetsToUpdate = new List<Target__c>();

    for (Target__c targetRecord : targetsList) {
        if (targetReviewCount.containsKey(targetRecord.Id)) {
            targetRecord.CurrentValue__c = targetReviewCount.get(targetRecord.Id);
            targetsToUpdate.add(targetRecord);
        }
    }

    if (!targetsToUpdate.isEmpty()) {
        update targetsToUpdate;
    }
}