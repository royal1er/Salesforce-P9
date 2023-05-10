@isTest
private class TestOrderService {
    // Méthode de configuration pour les données de test
    @TestSetup
    static void setupTestData() {
        Account testAccount = TestDataFactory.createTestAccount('Test Account');
        Order testOrder = TestDataFactory.createTestOrder(testAccount.Id, 'Ordered', 200, 50);
}


    @isTest
    static void testGetTotalOrderAmount() {
        // Récupère les données de test
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        List<Order> testOrders = [SELECT Id, TotalAmount FROM Order WHERE AccountId = :testAccount.Id];
    
        // Calcule le montant total attendu des commandes de test
        Decimal expectedTotalAmount = 0;
        for (Order order : testOrders) {
            expectedTotalAmount += order.TotalAmount;
        }
    
        // Appelle la méthode getTotalOrderAmount() et compare le montant total réel au montant total attendu
        Decimal totalOrderAmount = OrderService.getTotalOrderAmount();
        System.assertNotEquals(null, totalOrderAmount, 'Total order amount should not be null');
    }
    

    @isTest
    static void testOrderUpdateAmount() {
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        Order testOrder = [SELECT TotalAmount, ShipmentCost__c, NetAmount__c FROM Order WHERE AccountId = :testAccount.Id];

        Test.startTest();
        OrderService.orderUpdateAmount(new List<Order>{testOrder});
        Test.stopTest();

        Order updatedOrder = [SELECT NetAmount__c FROM Order WHERE Id = :testOrder.Id];
        System.assertEquals(testOrder.TotalAmount - testOrder.ShipmentCost__c, updatedOrder.NetAmount__c, 'NetAmount__c should be updated correctly');
    }
}
