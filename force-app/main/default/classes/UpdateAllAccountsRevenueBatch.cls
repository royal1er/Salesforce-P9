global class UpdateAllAccountsRevenueBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext info) {
        return Database.getQueryLocator('SELECT Id FROM Account');
    }

    global void execute(Database.BatchableContext info, List<Account> scope) {
        AccountService.updateAccountRevenue(scope);
    }

    global void finish(Database.BatchableContext info) {
        List<TemporaryRecord__c> tempRecordsToDelete = [SELECT Id FROM TemporaryRecord__c WHERE CreatedDate <= LAST_N_DAYS:30];
        if (!tempRecordsToDelete.isEmpty()) {
            delete tempRecordsToDelete;
        }
    }
}