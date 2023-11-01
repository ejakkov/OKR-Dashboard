trigger TargetTrigger on Target__c (before insert, before update) {
    List<Target__c> newTargetList = Trigger.new;
    List<Id> keyResultIdList = new List<Id>();

    Map<Id, String> keyResultNameMap = new Map<Id, String>();
    for (Target__c newTarget : newTargetList) {
        keyResultIdList.add(newTarget.Key_Result__c);
    }

    List<KeyResult__c> keyResultList = [SELECT Id, Name FROM KeyResult__c WHERE Id IN :keyResultIdList];

    for (KeyResult__c currentKeyResult : keyResultList) {
        keyResultNameMap.put(currentKeyResult.Id, currentKeyResult.Name);
    }

    for (Target__c newTarget : newTargetList) {
        if (keyResultNameMap.containsKey(newTarget.Key_Result__c)) {
            newTarget.Name = keyResultNameMap.get(newTarget.Key_Result__c) + ' | ' + newTarget.Type__c;
        }
    }
}