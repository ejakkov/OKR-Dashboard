trigger AllTriggers on GoogleReview__c (after insert, before update, before delete) {

    
    List<GoogleReview__c> existingRecords = new List<GoogleReview__c>();

    Map<Id, Integer> targetReviewCount = new Map<Id, Integer>();

    if(Trigger.isInsert){
        List<GoogleReview__c> newRecords = Trigger.new;
        Set<Id> targetIdSet = new Set<Id>();
        for (GoogleReview__c record : newRecords) {
            targetIdSet.add(record.Target__c);
        }

        

        for (GoogleReview__c record : newRecords) {
            existingRecords = [SELECT Target__c FROM GoogleReview__c WHERE Target__c = :record.Target__c];
            Id targetId = record.Target__c;
            targetReviewCount.put(targetId, existingRecords.size());
    }
    }
    
    if (Trigger.isDelete) {
        List<GoogleReview__c> deletedRecords = Trigger.old;
        for (GoogleReview__c record : deletedRecords) {
            existingRecords = [SELECT Target__c FROM GoogleReview__c WHERE Target__c = :record.Target__c];
            Id targetId = record.Target__c;
            targetReviewCount.put(targetId, existingRecords.size()-1);
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
