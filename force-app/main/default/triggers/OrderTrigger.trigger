trigger OrderTrigger on Order (after update) {
    OrderTriggerHandler.createAssetRecord(Trigger.new, Trigger.oldMap);
    OrderTriggerHandler.updateAssetStatus(Trigger.new, Trigger.oldMap);
    OrderTriggerHandler.addContactsToDripCampagin(Trigger.new);
    OrderTriggerHandler.checkUserRecords(Trigger.new);
}