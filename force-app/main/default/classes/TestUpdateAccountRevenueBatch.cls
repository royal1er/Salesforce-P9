@isTest
private class TestUpdateAccountRevenueBatch {
    // Méthode de configuration pour les données de test
    @TestSetup
    static void setupTestData() {
        Account testAccount = TestDataFactory.createTestAccount('Test Account');
        Order testOrder = TestDataFactory.createTestOrder(testAccount.Id, 'Ordered', 200, 50);
    }

    @isTest
    static void testUpdateAccountRevenueBatch() {
        Test.startTest();
        UpdateAccountRevenueBatch batch = new UpdateAccountRevenueBatch();
        Id batchJobId = Database.executeBatch(batch);
        Test.stopTest();

        Account updatedAccount = [SELECT Chiffre_d_affaire__c FROM Account WHERE Name = 'Test Account' LIMIT 1];
        System.assertEquals(200, updatedAccount.Chiffre_d_affaire__c, 'Chiffre d\'Affaire should be updated correctly');
    }
}
