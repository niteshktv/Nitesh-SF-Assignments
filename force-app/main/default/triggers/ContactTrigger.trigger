trigger ContactTrigger on Contact ( after update) {
    ContactWithAccount.isPrimaryContact(Trigger.new);
    ContactWithAccount.setParentAccountsEmail(Trigger.new);
    ContactWithAccount.getContactsWithAccount(Trigger.new);
}
