global class UpdateAccountRevenueBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext info) {
        // Requête sur les comptes qui ont au moins une commande avec le statut 'Ordered'
        return Database.getQueryLocator('SELECT Id FROM Account WHERE Id IN (SELECT AccountId FROM Order WHERE Status = \'Ordered\')');
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