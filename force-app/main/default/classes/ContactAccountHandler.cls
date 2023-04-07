public with sharing class ContactAccountHandler {
        public static void isPrimaryContact(List<Contact> contactList){
            List<Account> accountList = new List<Account>([Select Account.Name, (SELECT Name, Email, Is_Primary__c FROM Contacts) FROM Account]);
            Map<Id, Contact> contactMap = new Map<Id, Contact>();
            for (Contact contact : contactList) {
                if (contact.Is_Primary__c) {
                    contactMap.put(contact.AccountId, contact);
                }
            }
    
            for (Account account : accountList) {
                Integer primaryContactCount = 0;
                if (contactMap.containsKey(account.Id)) {
                    for (Contact contact : account.Contacts) {
                        if (contact.Is_Primary__c) {
                            primaryContactCount++;
                        }
                    }
                    if (primaryContactCount > 1) {
                        contactMap.get(account.Id).addError('Primary Contact Already Exists');
                    }
                }
            } 
        }
    
        public static void setParentAccountsEmail(List<Contact> contactList){
            Set<Id> accountIdSet = new Set<Id>();
            for (Contact contact : contactList) {
                if (contact.Is_Primary__c) {
                    //add contact account id if contact is primary contact.
                    accountIdSet.add(contact.AccountId);
                }
            }
            List<Account> accountList = [Select Id, Name, ParentId, (Select Id, Name, Email, Is_Primary__c from Contacts) from Account where Id in :accountIdSet];
            //get all accounts
            Map<Id, Account> accountMap = new Map<Id, Account>();
            for (Account account : accountList) {
                accountMap.put(account.Id, account);
            }
            //get parent account
            Set<Id> parentAccountIdSet = new Set<Id>();
            for (Account account : accountList) {
                parentAccountIdSet.add(account.ParentId);
            }
    
            List<Contact> parentAccountContactList = [Select Id, AccountId, Email, Name, Is_Primary__c from Contact where AccountId in :parentAccountIdSet and Is_Primary__c = true];
            //get all contacts of parent accounts
            Map<Id, Contact> parentContactMap = new Map<Id, Contact>();
            for (Contact contact : parentAccountContactList) {
                parentContactMap.put(contact.AccountId, contact);
            }
    
            List<Contact> updatedContactList = new List<Contact>();
            //setting the email of parents accounts primary contacts email
            for (Contact contact : contactList) {
                if (accountMap.containsKey(contact.AccountId) && parentContactMap.containsKey(accountMap.get(contact.AccountId).ParentId)) {
                    Contact parentContact = parentContactMap.get(accountMap.get(contact.AccountId).ParentId);
                    parentContact.Email = contact.Email;
    
                    updatedContactList.add(parentContact);
                }
            }
    
            if (updatedContactList.size() > 0) {
                update updatedContactList;
            }
        }
    
        public static void getContactsWithAccount(List<Contact> contactList){
            Set<Id> accountIdSet = new Set<Id>();
            for (Contact contact : contactList) {
                if (contact.AccountId != null) {
                    accountIdSet.add(contact.AccountId);
                }
            }
            List<Account> accountList = [Select Id, Name From Account where Id in :accountIdSet];
            for(Account account: accountList){
                Integer contactCount = 0;
                for(Contact contact : contactList){
                    if(contact.AccountId == account.Id){
                        contactCount++;
                    }
                }
                account.Contact_Count__c = contactCount;
            }
            update accountList;
        }
}