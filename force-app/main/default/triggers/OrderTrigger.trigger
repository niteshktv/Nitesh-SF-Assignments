trigger OrderTrigger on Order (after update) {
    OrderTriggerHandler.createAssetRecord(Trigger.new, Trigger.oldMap);
}