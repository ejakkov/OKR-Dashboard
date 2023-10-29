public with sharing class displayKeyResultController {
    @AuraEnabled(cacheable=true)
    public static List<ObjectiveKeyResultWrapper> getKeyResult(String userId, Integer year) {
        List<ObjectiveKeyResultWrapper> objectiveKeyResultList = new List<ObjectiveKeyResultWrapper>();
        
        List<Objective__c> objectivesList = [SELECT Name, Id FROM Objective__c WHERE User__c = :userId AND Year__c =:year];

        try {
            for (Objective__c objective : objectivesList) {
                List<KeyResult__c> keyResults = [SELECT Id, Name FROM KeyResult__c WHERE Objective__c = :objective.Id ];
                List<KeyResultWrapper> keyResultList = new List<KeyResultWrapper>();

                for (KeyResult__c keyResult : keyResults) {
                    List<Target__c> targetList = [SELECT Name, TargetValue__c, CurrentValue__c, Type__c FROM Target__c WHERE Key_Result__c = :keyResult.Id];
                    List<TargetWrapper> targetWrapperList = new List<TargetWrapper>();

                    for (Target__c target : targetList) {
                        TargetWrapper targetWrapper = new TargetWrapper(target.Name, target.TargetValue__c, target.CurrentValue__c, target.Type__c);
                        targetWrapperList.add(targetWrapper);
                    }

                    KeyResultWrapper keyResultWrapper = new KeyResultWrapper(keyResult.Id, keyResult.Name, targetWrapperList);
                    keyResultList.add(keyResultWrapper);
                }

                ObjectiveKeyResultWrapper objectiveKeyResultWrapper = new ObjectiveKeyResultWrapper(objective, keyResultList);
                objectiveKeyResultList.add(objectiveKeyResultWrapper);
            }
        } catch (Exception e) {
            System.debug('Error: ' + e.getMessage());
            throw new AuraHandledException('An error occurred while fetching objects');
        }

        return objectiveKeyResultList;
    }

    public class ObjectiveKeyResultWrapper {
        @AuraEnabled
        public Objective__c objective { get; set; }
        @AuraEnabled
        public List<KeyResultWrapper> keyResults { get; set; }

        public ObjectiveKeyResultWrapper(Objective__c objective, List<KeyResultWrapper> keyResults) {
            this.objective = objective;
            this.keyResults = keyResults;
        }
    }

    public class KeyResultWrapper {
        @AuraEnabled
        public Id keyResultId { get; set; }
        @AuraEnabled
        public String keyResultName { get; set; }
        @AuraEnabled
        public List<TargetWrapper> targets { get; set; }

        public KeyResultWrapper(Id keyResultId, String keyResultName, List<TargetWrapper> targets) {
            this.keyResultId = keyResultId;
            this.keyResultName = keyResultName;
            this.targets = targets;
        }
    }

    public class TargetWrapper {
        @AuraEnabled
        public String name { get; set; }
        @AuraEnabled
        public Decimal targetValue { get; set; }
        @AuraEnabled
        public Decimal currentValue { get; set; }
        @AuraEnabled
        public String type { get; set; }

        public TargetWrapper(String name, Decimal targetValue, Decimal currentValue, String type) {
            this.name = name;
            this.targetValue = targetValue;
            this.currentValue = currentValue;
            this.type = type;
        }
    }
}
