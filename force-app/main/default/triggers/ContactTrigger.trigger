trigger ContactTrigger on Contact ( after update) {
    ContactAccountHandler.isPrimaryContact(Trigger.new);
    ContactAccountHandler.setParentAccountsEmail(Trigger.new);
    ContactAccountHandler.getContactsWithAccount(Trigger.new);
}
