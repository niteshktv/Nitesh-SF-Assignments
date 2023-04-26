public with sharing class OrderTriggerHandler {
    public static void createAssetRecord(List<order> orderList, Map<Id, Order> oldOrderMap){
        Set<ID> orderIdSet = new set<Id>();
        for(Order order : orderList){
            if(oldOrderMap.containskey(order.Id) && oldOrderMap.get(order.Id).Status == 'Draft' && order.Status=='Activated'){
                orderIdSet.add(order.Id);
            }
        }
        BusinessHours  bussinessHours = [SELECT Id, Name FROM BusinessHours WHERE Name='Test Bussiness Hours' LIMIT 1];
        List<OrderItem> orderItemList = [SELECT id, Product2.Name, Product2.ProductCode , Order.AccountId, Order.OpportunityId, Order.CreatedDate,Product2.POC__c, UnitPrice, Quantity FROM OrderItem WHERE OrderId IN :orderIdSet AND Product2.Family='Software'];
        List<Asset> assetList = new List<Asset>();
        Set<Id> opportunityIdSet = new Set<Id>();
        Map<String, Entitlement> assetNameWithEntitlementMap = new Map<String, Entitlement>();
        Map<Id,Map<String,Entitlement>> mapOfAccountEntitlement = new Map<Id,Map<String,Entitlement>>();
        for(OrderItem orderItem : orderItemList){
            for(Integer i=0; i<orderItem.Quantity; i++ ){
                Asset asset = new Asset();
                asset.Name = 'Asset '+ orderItem.Product2.Name + ' ' +orderItem.Product2.ProductCode + ' ' + i;
                asset.AccountId = orderItem.Order.AccountId;
                asset.Product2Id = orderItem.Product2Id;
                asset.Opportunity__c = orderItem.Order.OpportunityId;
                asset.Price = orderItem.UnitPrice;
                asset.PurchaseDate = Date.newInstance(orderItem.Order.CreatedDate.year(), orderItem.Order.CreatedDate.month(),orderItem.Order.CreatedDate.day());
                asset.Status = 'Purchased';
                asset.Quantity = 1;

                //Create Entitlement record
                Entitlement entitlement = new Entitlement();
                entitlement.Name = 'Ent ' + orderItem.Product2.Name+' '+ orderItem.Product2.ProductCode+' '+i;
                entitlement.AccountId = orderItem.Order.AccountId;
                entitlement.StartDate = Date.newInstance(orderItem.Order.CreatedDate.year(), orderItem.Order.CreatedDate.month(),orderItem.Order.CreatedDate.day());
                if(orderItem.Product2.POC__C){
                    entitlement.EndDate = Date.newInstance(orderItem.Order.CreatedDate.year(), orderItem.Order.CreatedDate.month(),orderItem.Order.CreatedDate.day()+90);
                }else{
                    entitlement.EndDate = Date.newInstance(orderItem.Order.CreatedDate.year(), orderItem.Order.CreatedDate.month(),orderItem.Order.CreatedDate.day()+365);
                }
                entitlement.BusinessHoursId = bussinessHours.Id;

                assetList.add(asset);
                opportunityIdSet.add(orderItem.Order.OpportunityId);
                assetNameWithEntitlementMap.put(asset.Name, entitlement);

            }
            mapOfAccountEntitlement.put(orderItem.Order.AccountId, assetNameWithEntitlementMap);

        }
        insert assetList;
        List<Entitlement> entitlementsToInsert=new List<Entitlement>();
        for(OrderItem ord : orderItemList)
        {
            for(Asset asset : assetList){
                mapOfAccountEntitlement.get(ord.Order.AccountId).get(asset.Name).AssetId = asset.Id;
                entitlementsToInsert.add(mapOfAccountEntitlement.get(ord.Order.AccountId).get(asset.Name));
            }
        }

        insert entitlementsToInsert;

        List<OpportunityContactRole> opportunityContactRoleList = [SELECT Id,ContactId,OpportunityId, IsPrimary, Role FROM OpportunityContactRole WHERE role='Primary Support' and OpportunityId IN :opportunityIdSet];
        List<EntitlementContact> entitlementContactList = new List<EntitlementContact>();
        for(OpportunityContactRole opportunityContactRole : opportunityContactRoleList){
            for(Entitlement entitlement : entitlementsToInsert){
                EntitlementContact entitlementContact = new EntitlementContact();
                entitlementContact.ContactId = opportunityContactRole.ContactId;
                entitlementContact.EntitlementId = entitlement.Id;

                entitlementContactList.add(entitlementContact);
            }
        }
        insert entitlementContactList;
    }

    public static void updateAssetStatus(List<Order> orderList, Map<Id, Order> oldOrderMap){
        Set<Id> orderIdSet = new Set<Id>();
        for(Order order: orderList){
            if(oldOrderMap.containskey(order.Id) && oldOrderMap.get(order.Id).Status == 'Activated' && order.Status == 'Shipped'){
                orderIdSet.add(order.Id);
            }
        }
        Set<String> assetNameSet = new Set<String>();
        List<OrderItem> orderItemList = [SELECT Id, Product2.Name, Product2.ProductCode, Quantity FROM OrderItem WHERE OrderId IN :orderIdSet];
        for(OrderItem orderItem : orderItemList){
            for(Integer i=0; i<orderItem.Quantity; i++){
                String assetName = 'Asset '+orderItem.Product2.Name + ' ' + orderItem.Product2.ProductCode + ' %';
                assetNameSet.add(assetName);
            }
        }

        //get asset Record
        List<Asset> assetList = [SELECT Id, Name, Status, Actual_Ship_Date__c FROM Asset WHERE Name LIKE :assetNameSet];
        for(Asset asset : assetList){
            asset.Status = 'Shipped';
            asset.Actual_Ship_Date__c = Date.today();
        }
        update assetList;
    }

    public static void addContactsToDripCampagin(List<Order> orderList){
        set<Id> opportunityIdSet = new set<Id>();
        for(Order order: orderList){
            if(order.Status == 'Shipped' && order.OpportunityId != null){
                opportunityIdSet.add(order.OpportunityId);
            }
        }
        List<OpportunityContactRole> opportunityContactRoleList = [SELECT Id, Contact.Id, Contact.Name, Contact.Email, Contact.DripCampaign__c, OpportunityId, Role FROM OpportunityContactRole WHERE ROle='Primary Support'and OpportunityId IN :opportunityIdSet and Contact.DripCampaign__c = false];

        Set<Id> contactIdSet = new Set<Id>();
        for(OpportunityContactRole opportunityContactRole : opportunityContactRoleList){
            contactIdSet.add(opportunityContactRole.Contact.Id);
        }
        List<Contact> contactList = [SELECT Id, DripCampaign__c FROM Contact WHERE Id IN :contactIdSet];
        for (Contact contact : contactList) {
            contact.DripCampaign__c = true;
        }

        update contactList;
    }

    public static void checkUserRecords(List<Order> orderList) {
        Set<Id> opportunityIdSet = new Set<Id>();
        for (Order order : orderList) {
            if (order.Status == 'Shipped' && order.OpportunityId != null) {
                opportunityIdSet.add(order.OpportunityId);
            }
        }

        List<OpportunityContactRole> opportunityContactRoleList = [SELECT Id, Contact.Id, Contact.Name, Contact.Email, OpportunityId, IsPrimary,Role FROM OpportunityContactRole WHERE Role = 'Primary Support' and OpportunityId IN :opportunityIdSet and Contact.Email != null];

        Map<String, String> usernameToNameMap = new Map<String, String>();
        for (OpportunityContactRole opportunityContactRole : opportunityContactRoleList) {
            usernameToNameMap.put(opportunityContactRole.Contact.Email, opportunityContactRole.Contact.Name);
        }

        if (usernameToNameMap.size() == 0) return;

        Profile customerCommunityLoginUserProfile = [SELECT Id, Name FROM Profile WHERE Name = 'Customer Community Login User' LIMIT 1];

        List<User> userList = [SELECT Id, Name, Email, Username, IsActive FROM User WHERE Username IN :usernameToNameMap.keySet()];
        Map<String,User> usernameToUserMap=new Map<String,User>();
        for(User user : userList)
        {
            usernameToUserMap.put(user.Username,user);
        }
        Set<Id> userIdSet = new Set<Id>();
        List<User> newUserList = new List<User>();
        for (String username : usernameToNameMap.keySet()) {
            Boolean isUserExists = false;
           
            if(usernameToUserMap.containskey(username)) {
                isUserExists = true;
                // User Exists
                if (usernameToUserMap.get(username).IsActive == false) {
                    usernameToUserMap.get(username).IsActive = true;
                    userIdSet.add(usernameToUserMap.get(username).Id);
                }
            }
            

            if (!isUserExists) {
                Id contactId;
                for (OpportunityContactRole opportunityContactRole : opportunityContactRoleList) {
                    if (opportunityContactRole.Contact.Email == username) {
                        contactId = opportunityContactRole.Contact.Id;
                        break;
                    }
                }
                User user = new User();
                user.Username = username;
                user.FirstName = usernameToNameMap.get(username);
                user.LastName = usernameToNameMap.get(username);
                user.Alias = usernameToNameMap.get(username).substring(0, 5);
                user.Email = username;
                user.TimeZoneSidKey = 'America/New_York';
                user.LocaleSidKey = 'en_US';
                user.EmailEncodingKey = 'ISO-8859-1';
                user.ProfileId = customerCommunityLoginUserProfile.Id;
                user.LanguageLocaleKey = 'en_US';
                user.IsActive = true;
                user.ContactId = contactId;

                newUserList.add(user);
            }
        }

        if (userIdSet.size() != 0) {
            updateUserToActive(userIdSet);
        }
        if (newUserList.size() != 0) {
            insert newUserList;
        }
    }

    @future
    static void updateUserToActive(Set<Id> userIdSet) {
        List<User> userList = [SELECT Id, IsActive FROM User WHERE Id IN :userIdSet];

        for (User user : userList) {
            user.IsActive = true;
        }

        update userList;
    }
}