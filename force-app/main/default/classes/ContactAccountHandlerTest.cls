@isTest
public with sharing class ContactAccountHandlerTest {
    @isTest static void isPrimaryTest(){
        Account acc1 = new Account(Name='Demo');
        insert acc1;
        
        Account acc2 = new Account(Name='Demo 1', ParentId=acc1.Id);
        insert acc2;
        
        List<Contact> contactList = new List<Contact>();
        for(Integer i=0; i<10; i++){
            Contact contact = new Contact();
            contact.LastName='Demo Contact '+i;
            contact.AccountId=acc1.id;
            if(i>5){
                contact.Is_Primary__c= true;
            }
            contactList.add(contact);
        }
        
        Test.startTest();
        List<Database.SaveResult> results = Database.insert(contactList, false);
        Test.stopTest();
        for (Database.SaveResult sr : results) {
            if (!sr.isSuccess()) {
                for(Database.Error err : sr.getErrors()) {                
                    System.assertEquals(true,err.getMessage().contains('Primary Contact Already Exists'));
                }
            }
        }
        
        system.assertEquals(5, [SELECT id from Contact].size());
    }
    
    @isTest static void copyParentsPrimaryContactEmailTest(){
        Account acc1 = new Account(Name='Demo');
        insert acc1;
        
        Account acc2 = new Account(Name='Demo 1', ParentId=acc1.Id);
        insert acc2;
        
        Contact contact1 = new Contact(LastName='Test Contact 1',Is_Primary__c=true, AccountId=acc2.Id, Email='test@demo.com');
        insert contact1;
        Contact contact2 = new Contact(LastName='Test Contact 2',Is_Primary__c=true, AccountId=acc1.Id);
        insert contact2;

        contact1.LastName = 'Nitesh Kumar';
        update contact1;
        
        system.debug([SELECT id, Email,Name From Contact WHERE LastName='Test Contact 2' limit 1]);
        system.assertEquals('test@demo.com', [SELECT id, Email From Contact WHERE LastName='Test Contact 2' limit 1].Email);
    }
}