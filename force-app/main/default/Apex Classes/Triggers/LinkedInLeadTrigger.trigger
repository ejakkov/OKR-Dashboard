trigger LinkedInLeadTrigger  on LinkedInLead__c (after insert, before update, before delete) {
    List<LinkedInLead__c> existingRecords = new List<LinkedInLead__c>();
    Map<Id, Integer> targetReviewCount = new Map<Id, Integer>();
    Map<Id, Integer> targetRecordCountMap= new Map<Id, Integer>();
    List<Id> targetIdList = new List<Id>();
    if(Trigger.isInsert){
        List<LinkedInLead__c> newRecords = Trigger.new;
        for (LinkedInLead__c newRecord : newRecords){
            targetIdList.add(newRecord.Target__c);
        }
        List<LinkedInLead__c> existingRecords = [SELECT Target__c FROM LinkedInLead__c WHERE LinkedInLead__c.Target__c IN :targetIdList];
        for (LinkedInLead__c record : existingRecords) {
            if (!targetRecordCountMap.containsKey(record.Target__c)) {
                targetRecordCountMap.put(record.Target__c, 1);
            } else {
                targetRecordCountMap.put(record.Target__c, targetRecordCountMap.get(record.Target__c) + 1);
            }
        }
        for (LinkedInLead__c record : newRecords) {
            if(targetRecordCountMap.containsKey(record.Target__c)){
                Id targetId = record.Target__c;
                targetReviewCount.put(targetId, targetRecordCountMap.get(record.Target__c));
            }
    }
    }
    
    if (Trigger.isDelete) {
        List<LinkedInLead__c> deletedRecords = Trigger.old;
        for (LinkedInLead__c oldRecord : deletedRecords){
            targetIdList.add(oldRecord.Target__c);
        }
        List<LinkedInLead__c> existingRecords = [SELECT Target__c FROM LinkedInLead__c WHERE LinkedInLead__c.Target__c IN :targetIdList];

        for (LinkedInLead__c record : existingRecords) {
            if (!targetRecordCountMap.containsKey(record.Target__c)) {
                targetRecordCountMap.put(record.Target__c, 1);
            } else {
                targetRecordCountMap.put(record.Target__c, targetRecordCountMap.get(record.Target__c) + 1);
            }
        }

        for (LinkedInLead__c record : deletedRecords) {
            if(targetRecordCountMap.containsKey(record.Target__c)){
                Id targetId = record.Target__c;
                targetReviewCount.put(targetId, targetRecordCountMap.get(record.Target__c)-1);
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