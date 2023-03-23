public with sharing class Exercise3 {
    public static List<Consultant__c> getConsultantsToEmployer(ID accountId) {
        List<Consultant__c> consultantsList = [SELECT  Name FROM Consultant__c WHERE Employer__r.Id = :accountId];
        return consultantsList;
    }
}