public class AccountService {
    public static void updateAccountRevenue(List<Account> scope) {
        //List<Account> accountsToUpdate = [SELECT Id, Chiffre_d_affaire__c, (SELECT Id, TotalAmount FROM Orders) FROM Account WHERE Id IN :accountIds];
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
                    acc.Chiffre_d_affaire__c = (acc.Chiffre_d_affaire__c != null) ? acc.Chiffre_d_affaire__c + amount : amount;
                    accountsToUpdate.add(acc);
                }
            }
        }
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
}
