trigger ContactTrigger on Contact ( after insert,after update) {
    ContactAccountHandler.isPrimaryContact(Trigger.new);
    ContactAccountHandler.setParentAccountEmail(Trigger.new);
    ContactAccountHandler.getContactsWithAccount(Trigger.new);
}
