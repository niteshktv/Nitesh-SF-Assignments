trigger OrderTrigger on Order (after update) {
    if(Trigger.isAfter){
        if(Trigger.isUpdate){
            OrderTriggerHandler.createAssetRecord(Trigger.new, Trigger.oldMap);
            OrderTriggerHandler.updateAssetStatus(Trigger.new, Trigger.oldMap);
            OrderTriggerHandler.addContactsToDripCampagin(Trigger.new);
            OrderTriggerHandler.checkUserRecords(Trigger.new);
        }
    }  
}
