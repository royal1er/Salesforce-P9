trigger OrderTrigger on Order (before update, after update) {
    // CalculMontant.trigger (before update)
    if (Trigger.isBefore && Trigger.isUpdate) {
        OrderService.orderUpdateAmount(Trigger.new);
    }
    
    if (Trigger.isAfter && Trigger.isUpdate) {
        // Appeler la méthode pour mettre à jour le chiffre d'affaires du compte
        AccountService.updateAccount(Trigger.oldMap, Trigger.new);
    }
}