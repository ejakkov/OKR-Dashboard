trigger GoogleReviewTrigger on GoogleReview__c (after insert, before update, before delete) {

    List<GoogleReview__c> existingRecords = new List<GoogleReview__c>();
    Map<Id, Integer> targetReviewCount = new Map<Id, Integer>();
    Map<GoogleReview__c, Integer> GoogleReviewCount= new Map<GoogleReview__c, Integer>();
    List<Id> GoogleReviewIdList = new List<Id>();

    if(Trigger.isInsert){
        List<GoogleReview__c> newRecords = Trigger.new;
        for (GoogleReview__c newGoogleReview : newRecords){
            GoogleReviewIdList.add(newGoogleReview.Id);
        }
        System.debug(GoogleReviewIdList);
        List<GoogleReview__c> existingRecords = [SELECT Target__c FROM GoogleReview__c WHERE GoogleReview__c.Id IN :GoogleReviewIdList];
        System.debug(existingRecords);
        for (GoogleReview__c record : existingRecords) {
            if (!GoogleReviewCount.containsKey(record)) {
                GoogleReviewCount.put(record, 1);
            } else {
                GoogleReviewCount.put(record, GoogleReviewCount.get(record) + 1);
            }
        }
        System.debug(GoogleReviewCount);
        for (GoogleReview__c record : newRecords) {
            if(GoogleReviewCount.containsKey(record)){
                Id targetId = record.Target__c;
                targetReviewCount.put(targetId, GoogleReviewCount.get(record));
            }
        System.debug(targetReviewCount);
    }
    }
    
    if (Trigger.isDelete) {
        List<GoogleReview__c> deletedRecords = Trigger.old;
        for (GoogleReview__c oldGoogleReview : deletedRecords){
            GoogleReviewIdList.add(oldGoogleReview.Id);
        }

        List<GoogleReview__c> existingRecords = [SELECT Target__c FROM GoogleReview__c WHERE GoogleReview__c.Id IN :GoogleReviewIdList];
        for (GoogleReview__c record : existingRecords) {
            if (!GoogleReviewCount.containsKey(record)) {
                GoogleReviewCount.put(record, 1);
            } else {
                GoogleReviewCount.put(record, GoogleReviewCount.get(record) + 1);
            }
        }

        for (GoogleReview__c record : deletedRecords) {
            if(GoogleReviewCount.containsKey(record)){
                Id targetId = record.Target__c;
                targetReviewCount.put(targetId, GoogleReviewCount.get(record));
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
