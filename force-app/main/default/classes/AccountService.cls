public class AccountService {
    public static void updateAccountRevenue(List<Account> scope) {
        Map<Id,AggregateResult> totalSumOrder = new Map<Id,AggregateResult>([
            SELECT accountId, SUM(TotalAmount) total 
            FROM Order 
            WHERE AccountId IN :scope 
            GROUP BY accountId
            ]);

        List<Account> accountsToUpdate = new List<Account>(); 
        for (Account acc : scope) {
            AggregateResult result = totalSumOrder.get(acc.Id);
            if (result != null) {
                Decimal amount = (Decimal)result.get('total');
                if (amount != null) {
                    acc.Chiffre_d_affaire__c = (acc.Chiffre_d_affaire__c != null) ? acc.Chiffre_d_affaire__c + amount : 0;
                    accountsToUpdate.add(acc);
                }
            }
        }
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
    public static void updateAccount(Map<Id,sObject> oldOrders, List<Order> newOrders) { //Mettre un map à la place , Map<sObject>
        Set<Id> accountIds = new Set<Id>();
        Map<Id, Decimal> accountIdToAmountDifference = new Map<Id, Decimal>();
    
        for (Order ord : newOrders) {
            if(ord.status == 'Ordered' && ord.status != oldOrders.get(ord.Id).get('status')){
                Decimal amountDifference = ord.TotalAmount - (Decimal)oldOrders.get(ord.Id).get('TotalAmount');
                accountIdToAmountDifference.put(ord.accountId,amountDifference);
            }
        }
    
        if (!accountIdToAmountDifference.isEmpty()) {
            List<Account> accountList = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :accountIdToAmountDifference.keySet()];
            List<Account> accountsToUpdate = new List<Account>();
            for (Account acc : accountList) {
                Decimal amountDifference = accountIdToAmountDifference.get(acc.Id);
                if (amountDifference != null) {
                    acc.Chiffre_d_affaire__c = (acc.Chiffre_d_affaire__c != null) ? acc.Chiffre_d_affaire__c + amountDifference : 0;
                    accountsToUpdate.add(acc);
                }
                
            }
            update accountsToUpdate;
        }
    }
}
