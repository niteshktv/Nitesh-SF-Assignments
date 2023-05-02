public with sharing class GetDesignationRecords {
    @AuraEnabled(cacheable=true)
    public static List<Contribution__c> getContactAssociatedWithDesignation(String designationId){
        List<Designation__c> designationList  = [Select Id, Name, Contact__r.LastName, Contact__r.Id FROM Designation__c WHERE Id= :designationId ];
        Set<Id> contactIdSet = new Set<Id>();
        for(Designation__c designation : designationList) {
            contactIdSet.add(designation.Contact__r.Id);
        }

        List<Contribution__c> contributionList = [SELECT Id,Name, Expertise__c, Generosity__c,Pillars__c, Leadership__c, Advocacy__c, Assessment__c, Date__c, Details__c, Contact__r.Id 
                FROM Contribution__c 
                WHERE Contact__r.Id IN :contactIdSet];
        
        return contributionList;
    }
}