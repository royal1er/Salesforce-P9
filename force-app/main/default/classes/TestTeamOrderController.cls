@isTest(seeAllData=false)
private class TestTeamOrdersController {
    // Méthode de configuration pour les données de test
    @TestSetup
    static void setupTestData() {
        Account testAccount = TestDataFactory.createTestAccount('Test Account');
        Order testOrder = TestDataFactory.createTestOrder(testAccount.Id, 'Ordered', 200, 50);
    }

    @isTest
    static void testTeamOrdersController() {
        TeamOrdersController controller = new TeamOrdersController();
        Decimal expectedSumOrders = 200;

        System.assertNotEquals(expectedSumOrders, controller.SumOrders, 'SumOrders should not be null');

        List<TeamOrdersController.OrdersBySalesRep> ordersBySalesRepList = controller.OrdersBySalesRep;
        System.assertEquals(1, ordersBySalesRepList.size(), 'There should be 1 OrdersBySalesRep record');
        System.assertEquals(200, ordersBySalesRepList[0].Total, 'Total for the SalesRep should match the expected value');
    }
}
