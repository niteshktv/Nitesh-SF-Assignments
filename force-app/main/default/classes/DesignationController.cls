public with sharing class DesignationController {
    @AuraEnabled(cacheable=true)
    public static Map<Integer , List<Contribution__c>>  getContributionsAssociatedWithDesignation(String designationId){
        List<Designation__c> designationList  = [Select Id, Name, Contact__r.LastName, Contact__r.Id FROM Designation__c WHERE Id= :designationId ];
        Set<Id> contactIdSet = new Set<Id>();
        for(Designation__c designation : designationList) {
            contactIdSet.add(designation.Contact__r.Id);
        }

        List<Contribution__c> contributionList = [SELECT Id,Name, Expertise__c, Generosity__c,Pillars__c, Leadership__c, Advocacy__c, Assessment__c, Date__c, Details__c, Contact__r.Id 
                FROM Contribution__c 
                WHERE Contact__r.Id IN :contactIdSet ];

        Map<Integer , List<Contribution__c>>  yearToContributionMap = new Map<Integer, List<Contribution__c>>();
        for(Contribution__c contribution : contributionList){
            if (yearToContributionMap.containsKey(contribution.Date__c.year())) {
                yearToContributionMap.get(contribution.Date__c.year()).add(contribution);
            } else {
                List<Contribution__c> newContributionListList = new List<Contribution__c>();
                newContributionListList.add(contribution);
                yearToContributionMap.put(contribution.Date__c.year(), newContributionListList);
            }
        }     
        
        return yearToContributionMap;
    }

    @AuraEnabled(cacheable=true)
    public static Map<Integer, List<Feedback__c>> getSelfFeedbackAssociateWithDesignation(String designationId){
        List<Designation__c> designationList  = [Select Id,Contact__r.Id FROM Designation__c WHERE Id= :designationId ];
        Set<Id> contactIdSet = new Set<Id>();
        for(Designation__c designation : designationList) {
            contactIdSet.add(designation.Contact__r.Id);
        }

        List<Feedback__c> feedbackList = [SELECT Id,Date__c,RecordType.Name, Nominator__r.Id,Nominator__r.Name
                FROM Feedback__c 
                WHERE Nominator__r.Id IN :contactIdSet AND RecordType.Name='Self-Feedback'];

        Map<Integer , List<Feedback__c>>  yearToFeedbackMap = new Map<Integer, List<Feedback__c>>();
        for(Feedback__c feedback : feedbackList){
            if (yearToFeedbackMap.containsKey(feedback.Date__c.year())) {
                yearToFeedbackMap.get(feedback.Date__c.year()).add(feedback);
            } else {
                List<Feedback__c> newFeedbackList = new List<Feedback__c>();
                newFeedbackList.add(feedback);
                yearToFeedbackMap.put(feedback.Date__c.year(), newFeedbackList);
            }
        }     
        
        return yearToFeedbackMap;
    }

    @AuraEnabled(cacheable=true)
    public static Map<Integer, List<Feedback__c>>  getFeedbackAssociateWithDesignation(String designationId){
        Id contactId  = [Select Id,Contact__r.Id FROM Designation__c WHERE Id= :designationId limit 1].Contact__r.Id;

        List<Feedback__c> feedbackList = [SELECT Id,Date__c,RecordType.Name,Advocacy_Rating__c,Expertise_Rating__c,Generosity_Rating__c,Leadership_Rating__c, Nominator__r.Id,Nominator__r.Name
                FROM Feedback__c 
                WHERE Nominator__r.Id = :contactId AND RecordType.Name='Feedback'];

        Map<Integer , List<Feedback__c>>  yearToFeedbackMap = new Map<Integer, List<Feedback__c>>();
        for(Feedback__c feedback : feedbackList){
            if (yearToFeedbackMap.containsKey(feedback.Date__c.year())) {
                yearToFeedbackMap.get(feedback.Date__c.year()).add(feedback);
            } else {
                List<Feedback__c> newFeedbackList = new List<Feedback__c>();
                newFeedbackList.add(feedback);
                yearToFeedbackMap.put(feedback.Date__c.year(), newFeedbackList);
            }
        }     
        
        return yearToFeedbackMap;
    }
}