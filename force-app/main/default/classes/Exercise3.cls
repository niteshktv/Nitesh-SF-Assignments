public with sharing class Exercise3 {
    // returns all names of the consultants working for that employer as a list
    public static List<Consultant__c> getConsultantsToEmployer(ID accountId) {
        List<Consultant__c> consultantsList = [SELECT  Name FROM Consultant__c WHERE Employer__r.Id = :accountId];
        return consultantsList;
    }

    public static Map<Account, Set<Id>> getEmployerAndConsultants(){
       Map<Account, Set<Id>> employerConsultantMap = new Map<Account, Set<Id>>();
        List<Account> accountList=[Select Id, (Select Id from Consultants__r) from Account where Id IN (Select Employer__c from Consultant__c)];
        Set<Id> ConsultantIdSet;
        for(Account account:accountList){
            consultantIdSet = new Set<Id>();
            for(Consultant__c consultant:account.Consultants__r){
                ConsultantIdSet.add(consultant.Id);
            }
            employerConsultantMap.put(account, consultantIdSet);
        }
        //for(Account acc: employerConsultantMap.keySet()){
            //System.debug('Id-->' + acc.Id + 'set'+ employerConsultantMap.get(acc));
       //}
        return employerConsultantMap;
    }

    public static Integer getWorkingDaysBetween(Date startDate, Date endDate) {
        Integer workingDays = 0;
        Integer daysBetween = startDate.daysBetween(endDate);
        
        for (Integer i = 0; i < daysBetween; i++) {
            DateTime currentDate = (DateTime)startDate.addDays(i);
            if (!currentDate.format('E').equals('Sat') && !currentDate.format('E').equals('Sun')) {
                workingDays++;
            }
        }
        
        return workingDays; 
    }
}