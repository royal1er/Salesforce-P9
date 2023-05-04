@isTest
private class TestAccountService {
    // Méthode de configuration pour les données de test
    @TestSetup
    static void setupTestData() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Order testOrder = new Order(AccountId = testAccount.Id, Status = 'Ordered', TotalAmount = 200, ShipmentCost__c = 50);
        insert testOrder;
    }

    @isTest
    static void testUpdateAccountRevenue() {
        Account testAccount = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Name = 'Test Account' LIMIT 1];
        Decimal expectedRevenue = 200;

        Test.startTest();
        AccountService.updateAccountRevenue(new List<Account>{testAccount});
        Test.stopTest();

        Account updatedAccount = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals(expectedRevenue, updatedAccount.Chiffre_d_affaire__c, 'Chiffre d\'Affaire should be updated correctly');
    }

    @isTest
    static void testUpdateAccount() {
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        Order testOrder = [SELECT Id, AccountId, TotalAmount, Status FROM Order WHERE AccountId = :testAccount.Id LIMIT 1];
        Decimal oldTotalAmount = testOrder.TotalAmount;
        testOrder.TotalAmount = 300;
        testOrder.Status = 'Ordered';

        Test.startTest();
        AccountService.updateAccount(new Map<Id, sObject>{testOrder.Id => testOrder}, new List<Order>{testOrder});
        Test.stopTest();

        Account updatedAccount = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals(oldTotalAmount + 100, updatedAccount.Chiffre_d_affaire__c, 'Chiffre d\'Affaire should be updated correctly');
    }
}
