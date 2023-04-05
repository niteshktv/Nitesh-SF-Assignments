public with sharing class OrderTriggerHandler {
    public static void createAssetRecord(List<order> orderList, Map<Id, Order> oldOrderMap){
        Set<ID> orderIdSet = new set<Id>();
        for(Order order : orderList){
            if(oldOrderMap.containskey(order.Id) && oldOrderMap.get(order.Id).Status == 'Draft' && order.Status=='Activated'){
                orderIdSet.add(order.Id);
            }
        }
        List<OrderItem> orderItemList = [select id, Product2.Name, Product2.ProductCode , Order.AccountId, Order.OpportunityId, Order.EffectiveDate, TotalPrice, Quantity from OrderItem Where OrderId IN :orderIdSet AND Product2.Family='Software'];
        List<Asset> assetList = new List<Asset>();
        
        for(OrderItem orderItem : orderItemList){
            for(Integer i=0; i<orderItem.Quantity; i++ ){
                Asset asset = new Asset();
                asset.Name = 'Asset '+ orderItem.Product2.Name + ' ' +orderItem.Product2.ProductCode + ' ' + i;
                asset.AccountId = orderItem.Order.AccountId;
                asset.Product2Id = orderItem.Product2Id;
                asset.Price = orderItem.UnitPrice;
                asset.PurchaseDate = Date.newInstance(orderItem.CreatedDate.year(), orderItem.CreatedDate.month(),orderItem.CreatedDate.day());
                asset.Status = 'Purchased';
                asset.Quantity = 1;

                assetList.add(asset);
            }
            insert assetList;
        }  
    }
}