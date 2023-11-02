trigger EventsTrigger on Event__c (after insert, before update, before delete) {

    List<Event__c> existingRecords = new List<Event__c>();
    Map<Id, Integer> targetReviewCount = new Map<Id, Integer>();
    Map<Event__c, Integer> GoogleReviewCount= new Map<Event__c, Integer>();
    List<Id> GoogleReviewIdList = new List<Id>();

    if(Trigger.isInsert){
        List<Event__c> newRecords = Trigger.new;
        for (Event__c newGoogleReview : newRecords){
            GoogleReviewIdList.add(newGoogleReview.Id);
        }

        List<Event__c> existingRecords = [SELECT Target__c FROM Event__c WHERE Event__c.Id IN :GoogleReviewIdList];
        for (Event__c record : existingRecords) {
            if (!GoogleReviewCount.containsKey(record)) {
                GoogleReviewCount.put(record, 1);
            } else {
                GoogleReviewCount.put(record, GoogleReviewCount.get(record) + 1);
            }
        }

        for (Event__c record : newRecords) {
            if(GoogleReviewCount.containsKey(record)){
                Id targetId = record.Target__c;
                targetReviewCount.put(targetId, GoogleReviewCount.get(record));
            }
    }
    }
    
    if (Trigger.isDelete) {
        List<Event__c> deletedRecords = Trigger.old;
        for (Event__c oldGoogleReview : deletedRecords){
            GoogleReviewIdList.add(oldGoogleReview.Id);
        }

        List<Event__c> existingRecords = [SELECT Target__c FROM Event__c WHERE Event__c.Id IN :GoogleReviewIdList];
        for (Event__c record : existingRecords) {
            if (!GoogleReviewCount.containsKey(record)) {
                GoogleReviewCount.put(record, 1);
            } else {
                GoogleReviewCount.put(record, GoogleReviewCount.get(record) + 1);
            }
        }

        for (Event__c record : deletedRecords) {
            if(GoogleReviewCount.containsKey(record)){
                Id targetId = record.Target__c;
                targetReviewCount.put(targetId, GoogleReviewCount.get(record)-1);
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
