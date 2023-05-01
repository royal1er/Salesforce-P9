trigger OrderTrigger on Order (before update, after update) {
    // CalculMontant.trigger (before update)
    if (Trigger.isBefore && Trigger.isUpdate) {
        for (Order newOrder : Trigger.new) {
            newOrder.NetAmount__c = newOrder.TotalAmount - newOrder.ShipmentCost__c;
        }
    }
    
    // UpdateAccountCA.trigger (after update)
    if (Trigger.isAfter && Trigger.isUpdate) {
        Set<Id> accountIds = new Set<Id>();
        for (Order newOrder : Trigger.new) {
            accountIds.add(newOrder.AccountId);
        }

        // Appeler la méthode du service pour mettre à jour le Chiffre d'Affaire
        AccountService.updateAccountRevenue(accountIds);
    }
}