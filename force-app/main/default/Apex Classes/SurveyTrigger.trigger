trigger SurveyTrigger  on Survey__c (after insert, before update, before delete) {
List<Survey__c> existingRecords = new List<Survey__c>();
Map<Id, Integer> targetReviewCount = new Map<Id, Integer>();
Map<Survey__c, Integer> GoogleReviewCount= new Map<Survey__c, Integer>();
List<Id> GoogleReviewIdList = new List<Id>();

if(Trigger.isInsert){
    List<Survey__c> newRecords = Trigger.new;
    for (Survey__c newGoogleReview : newRecords){
        GoogleReviewIdList.add(newGoogleReview.Id);
    }

    List<Survey__c> existingRecords = [SELECT Target__c FROM Survey__c WHERE Survey__c.Id IN :GoogleReviewIdList];
    for (Survey__c record : existingRecords) {
        if (!GoogleReviewCount.containsKey(record)) {
            GoogleReviewCount.put(record, 1);
        } else {
            GoogleReviewCount.put(record, GoogleReviewCount.get(record) + 1);
        }
    }

    for (Survey__c record : newRecords) {
        if(GoogleReviewCount.containsKey(record)){
            Id targetId = record.Target__c;
            targetReviewCount.put(targetId, GoogleReviewCount.get(record));
        }
}
}

if (Trigger.isDelete) {
    List<Survey__c> deletedRecords = Trigger.old;
    for (Survey__c oldGoogleReview : deletedRecords){
        GoogleReviewIdList.add(oldGoogleReview.Id);
    }

    List<Survey__c> existingRecords = [SELECT Target__c FROM Survey__c WHERE Survey__c.Id IN :GoogleReviewIdList];
    for (Survey__c record : existingRecords) {
        if (!GoogleReviewCount.containsKey(record)) {
            GoogleReviewCount.put(record, 1);
        } else {
            GoogleReviewCount.put(record, GoogleReviewCount.get(record) + 1);
        }
    }

    for (Survey__c record : deletedRecords) {
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