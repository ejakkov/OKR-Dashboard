public with sharing class SelectUserController {
    @AuraEnabled(cacheable=true)
    public static List<User> getUsers() {
        return [SELECT Name, Id FROM User WHERE Name != 'Automated Process' AND Name != 'Data.com Clean'
         AND Name != 'Integration User' AND Name != 'Security User' AND Name != 'Platform Integration User'
         AND Name != 'Chatter Expert'];
    }
}