@isTest
private class TestUpdateAccountRevenue {
    // Méthode de configuration pour les données de test
    @TestSetup
    static void setupTestData() {
        Account testAccount = new Account(Name = 'Test Account 1');
        insert testAccount;

        Product2 testProduct = new Product2(Name = 'Chemise Verte longue XYX', Family = 'Chemise');
        Insert testProduct;

        // Créer PricebookEntry
        PricebookEntry testPricebookEntry = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = testProduct.Id,
            UnitPrice = 1020,
            IsActive = true
        );
        Insert testPricebookEntry;

        Order testOrder = new Order(AccountId = testAccount.Id, Status = 'Ordered');
        insert testOrder;

        OrderItem testOrderItem1 = new OrderItem(OrderId = testOrder.Id, PricebookEntryId = testPricebookEntry.Id, Quantity = 10, UnitPrice = 150);
        insert testOrderItem1;
        OrderItem testOrderItem2 = new OrderItem(OrderId = testOrder.Id, PricebookEntryId = testPricebookEntry.Id, Quantity = 20, UnitPrice = 1000);
        insert testOrderItem2;
    }

    // Test mise à jour du Chiffre d'Affaire
    @isTest
    static void testUpdateAccountRevenue() {
        // Récupérer les données de test
        Account testAccount = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Name = 'Test Account 1' LIMIT 1];
        Decimal expectedRevenue = 150 * 10 + 1000 * 20;

        Test.startTest();
        AccountService.updateAccountRevenue(new Set<Id>{testAccount.Id});
        Test.stopTest();

        // Récupérer les données mises à jour
        Account updatedAccount = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :testAccount.Id];

        // Vérifier que le Chiffre d'Affaire a été mis à jour correctement
        System.assertEquals(expectedRevenue, updatedAccount.Chiffre_d_affaire__c, 'Chiffre d\'Affaire should be updated correctly');
    }
}
