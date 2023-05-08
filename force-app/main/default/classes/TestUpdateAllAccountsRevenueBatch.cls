@isTest
private class TestUpdateAllAccountsRevenueBatch {
    // Méthode de configuration pour les données de test
    @TestSetup
    static void setupTestData() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Order testOrder = new Order(AccountId = testAccount.Id, Status = 'Ordered', TotalAmount = 200, ShipmentCost__c = 50);
        insert testOrder;
    }

    @isTest
    static void testUpdateAllAccountsRevenueBatch() {
        Test.startTest();
        UpdateAllAccountsRevenueBatch batch = new UpdateAllAccountsRevenueBatch();
        Id batchJobId = Database.executeBatch(batch);
        Test.stopTest();

        Account updatedAccount = [SELECT Chiffre_d_affaire__c FROM Account WHERE Name = 'Test Account' LIMIT 1];
        System.assertEquals(200, updatedAccount.Chiffre_d_affaire__c, 'Chiffre d\'Affaire should be updated correctly');
    }
}
