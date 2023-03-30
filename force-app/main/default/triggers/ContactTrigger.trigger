trigger ContactTrigger on Contact ( after insert,after update) {
    ContactAccountHandler.isPrimaryContact(Trigger.new);
    ContactAccountHandler.setParentAccountsEmail(Trigger.new);
    ContactAccountHandler.getContactsWithAccount(Trigger.new);
}
