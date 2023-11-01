trigger ReviewTrigger  on Review__c (after insert, before update, before delete) {
    List<Review__c> existingRecords = new List<Review__c>();
    Map<Id, Integer> targetReviewCount = new Map<Id, Integer>();
    Map<Review__c, Integer> GoogleReviewCount= new Map<Review__c, Integer>();
    List<Id> GoogleReviewIdList = new List<Id>();

    if(Trigger.isInsert){
        List<Review__c> newRecords = Trigger.new;
        for (Review__c newGoogleReview : newRecords){
            GoogleReviewIdList.add(newGoogleReview.Id);
        }

        List<Review__c> existingRecords = [SELECT Target__c FROM Review__c WHERE Review__c.Id IN :GoogleReviewIdList];
        for (Review__c record : existingRecords) {
            if (!GoogleReviewCount.containsKey(record)) {
                GoogleReviewCount.put(record, 1);
            } else {
                GoogleReviewCount.put(record, GoogleReviewCount.get(record) + 1);
            }
        }

        for (Review__c record : newRecords) {
            if(GoogleReviewCount.containsKey(record)){
                Id targetId = record.Target__c;
                targetReviewCount.put(targetId, GoogleReviewCount.get(record));
            }
    }
    }
    
    if (Trigger.isDelete) {
        List<Review__c> deletedRecords = Trigger.old;
        for (Review__c oldGoogleReview : deletedRecords){
            GoogleReviewIdList.add(oldGoogleReview.Id);
        }

        List<Review__c> existingRecords = [SELECT Target__c FROM Review__c WHERE Review__c.Id IN :GoogleReviewIdList];
        for (Review__c record : existingRecords) {
            if (!GoogleReviewCount.containsKey(record)) {
                GoogleReviewCount.put(record, 1);
            } else {
                GoogleReviewCount.put(record, GoogleReviewCount.get(record) + 1);
            }
        }

        for (Review__c record : deletedRecords) {
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