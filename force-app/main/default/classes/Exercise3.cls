public with sharing class Exercise3 {
    // returns all names of the consultants working for that employer as a list
    public static List<Consultant__c> getConsultantListForEmployer(ID accountId) {
        List<Hiring__c> hiringList = [SELECT Consultant__r.Name FROM Hiring__c WHERE Employer__r.ID = :AccountID ];
        List<String> consultantsNameList = new List<String>();
        for(Hiring__c h : hiringList){
            consultantsNameList.add(h.Consultant__r.Name);
        }
        return consultantsNameList;
    }

    //returns a map where the key is Employer and value is set of ConsultantId in it.
    public static Map<Account, Set<Id>> mapEmployerWithConsultantsIds(){
       Map<Account, Set<Id>> employerWithConsultantIdsMap = new Map<Account, Set<Id>>();
        List<Account> accountList=[Select ID,(select Consultant__c From Hirings__r) from Account];
        Set<Id> consultantIdSet;
        for (Account account : accountList) {
            consultantIdSet = new Set<Id>();
            for (Hiring__c hr : account.Hirings__r) {
                consultantIdSet.add(hr.Consultant__c);
            }
            employerWithConsultantIdsMap.put(account, consultantIdSet);
        }
        return employerWithConsultantIdsMap;
    }

    //returns the number of working days between two dates excluding both days.
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