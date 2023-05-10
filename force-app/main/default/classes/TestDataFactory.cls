public class TestDataFactory {

    public static Account createTestAccount(String accountName) {
        Account testAccount = new Account(Name = accountName);
        insert testAccount;
        return testAccount;
    }

    public static Order createTestOrder(Id accountId, String status, Decimal totalAmount, Decimal shipmentCost) {
        Order testOrder = new Order(AccountId = accountId, Status = status, TotalAmount = totalAmount, ShipmentCost__c = shipmentCost);
        insert testOrder;
        return testOrder;
    }
    public static Account createTestAccountWithOrder() {
        Account testAccount = createTestAccount();
        createTestOrder(testAccount.Id);
        return testAccount;
    }

}
