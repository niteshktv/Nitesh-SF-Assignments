public with sharing class OrderTriggerHandler {
    public static void createAssetRecord(List<order> orderList, Map<Id, Order> oldOrderMap){
        Set<ID> orderIdSet = new set<Id>();
        for(Order order : orderList){
            if(oldOrderMap.containskey(order.Id) && oldOrderMap.get(order.Id).Status == 'Draft' && order.Status=='Activated'){
                orderIdSet.add(order.Id);
            }
        }
        BusinessHours  bussinessHours = [SELECT Id, Name FROM BusinessHours Where Name='Test Bussiness Hours' limit 1]; 
        List<OrderItem> orderItemList = [select id, Product2.Name, Product2.ProductCode , Order.AccountId, Order.OpportunityId, Order.CreatedDate,Product2.POC__c, UnitPrice, Quantity from OrderItem Where OrderId IN :orderIdSet AND Product2.Family='Software'];
        List<Asset> assetList = new List<Asset>();
        Set<Id> opportunityIdSet = new Set<Id>();
        Map<String, Entitlement> assetToEntitlementMap = new Map<String, Entitlement>();
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
                if(orderItem.Product2.POC__C==true){
                    entitlement.EndDate = Date.newInstance(orderItem.Order.CreatedDate.year(), orderItem.Order.CreatedDate.month(),orderItem.Order.CreatedDate.day()+90);
                }else{
                    entitlement.EndDate = Date.newInstance(orderItem.Order.CreatedDate.year(), orderItem.Order.CreatedDate.month(),orderItem.Order.CreatedDate.day()+365);
                }
                entitlement.BusinessHoursId = bussinessHours.Id;
                
                assetList.add(asset);
                opportunityIdSet.add(orderItem.Order.OpportunityId);
                assetToEntitlementMap.put(asset.Name, entitlement);
            }
        }  
        insert assetList;
        for(Asset asset : assetList){
            assetToEntitlementMap.get(asset.Name).AssetId = asset.Id;
        }
        insert assetToEntitlementMap.values();

        List<OpportunityContactRole> opportunityContactRoleList = [SELECT Id,ContactId,OpportunityId, IsPrimary, Role FROM OpportunityContactRole WHERE role='Primary Support' and OpportunityId IN :opportunityIdSet];
        List<EntitlementContact> entitlementContactList = new List<EntitlementContact>();
        for(OpportunityContactRole opportunityContactRole : opportunityContactRoleList){
            for(Entitlement entitlement : assetToEntitlementMap.values()){
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
            if(oldOrderMap.containskey(Order.Id) && oldOrderMap.get(Order.Id).Status == 'Activited' && Order.Status == 'Shipped'){
                orderIdSet.add(order.Id);
            }
        }
        Set<String> assetNameSet = new Set<String>();
        List<OrderItem> orderItemList = [SELECT Id, Product2.Name, Product2.ProductCode, Quantity from OrderItem WHERE OrderId IN :orderIdSet];
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
    List<OpportunityContactRole> opportunityContactRoleList = [Select Id, Contact.Id, Contact.Name, Contact.Email, Contact.DripCampaign__c, OpportunityId, Role from OpportunityContactRole where ROle='Primary Support' and OpportunityId in :opportunityIdSet and Contact.DripCampaign__c = false];
    
    Set<Id> contactIdSet = new Set<Id>();
    for(OpportunityContactRole opportunityContactRole : opportunityContactRoleList){
        contactIdSet.add(opportunityContactRole.Contact.Id);
    }
    List<Contact> contactList = [Select Id, DripCampaign__c from Contact where Id in :contactIdSet];
    for (Contact contact : contactList) {
        contact.DripCampaign__c = true;
    }

    update contactList;
   }
   public static void checkUserRecords(List<Order> orderList) {
    Set<Id> oppIdSet = new Set<Id>();
    for (Order order : orderList) {
        if (order.Status == 'Shipped' && order.OpportunityId != null) {
            oppIdSet.add(order.OpportunityId);
        }
    }

    List<OpportunityContactRole> opportunityContactRoleList = [Select Id, Contact.Id, Contact.Name, Contact.Email, OpportunityId, IsPrimary,Role from OpportunityContactRole where Role = 'Primary Support' and OpportunityId in :oppIdSet and Contact.Email != null];

    Map<String, String> usernameToNameMap = new Map<String, String>();
    for (OpportunityContactRole opportunityContactRole : opportunityContactRoleList) {
        usernameToNameMap.put(opportunityContactRole.Contact.Email, opportunityContactRole.Contact.Name);
    }

    if (usernameToNameMap.size() == 0) return;

    Profile customerCommunityLoginUserProfile = [Select Id, Name from Profile where Name = 'Customer Community Login User' limit 1];

    List<User> userList = [Select Id, Name, Email, Username, IsActive from User where Username in :usernameToNameMap.keySet()];
    Set<Id> userIdSet = new Set<Id>();
    List<User> newUserList = new List<User>();
    for (String username : usernameToNameMap.keySet()) {
        Boolean isUserExists = false;
        for (User iteratedUser : userList) {
            if (iteratedUser.Username == username) {
                isUserExists = true;
                // User Exists
                if (iteratedUser.IsActive != null && iteratedUser.IsActive == false) {
                    iteratedUser.IsActive = true;
                    userIdSet.add(iteratedUser.Id);
                }
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
    List<User> userList = [Select Id, IsActive from User where Id in :userIdSet];

    for (User user : userList) {
        user.IsActive = true;
    }

    update userList;
}
}