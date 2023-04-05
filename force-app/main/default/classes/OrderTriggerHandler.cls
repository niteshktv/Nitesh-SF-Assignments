public with sharing class OrderTriggerHandler {
    public static void createAssetRecord(List<order> orderList, Map<Id, Order> oldOrderMap){
        Set<ID> orderIdSet = new set<Id>();
        for(Order order : orderList){
            if(oldOrderMap.containskey(order.Id) && oldOrderMap.get(order.Id).Status == 'Draft' && order.Status=='Activated'){
                orderIdSet.add(order.Id);
            }
        }
        BusinessHours  bussinessHours = [SELECT Id, Name FROM BusinessHours Where Name='Test Bussiness Hours' limit 1]; 
        List<OrderItem> orderItemList = [select id, Product2.Name, Product2.ProductCode , Order.AccountId, Order.OpportunityId, Order.EffectiveDate, TotalPrice, Quantity from OrderItem Where OrderId IN :orderIdSet AND Product2.Family='Software'];
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
                entitlement.EndDate = Date.newInstance(orderItem.Order.CreatedDate.year(), orderItem.Order.CreatedDate.month(),orderItem.Order.CreatedDate.day()+365);

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
        
        List<OpportunityContactRole> opportunityContactRoleList = [SELECT Id,ContactId,OpportunityId, IsPrimary, Role FROM OpportunityContactRole WHERE IsPrimary=true and OpportunityId IN :opportunityIdSet];
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
}