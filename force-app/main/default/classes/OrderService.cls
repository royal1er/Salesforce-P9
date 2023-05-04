public class OrderService {
    public static Decimal getTotalOrderAmount() {
        AggregateResult groupedResults = [SELECT SUM(TotalAmount) total FROM Order];
        return (Decimal)groupedResults.get('total');
    }

    public static void orderUpdateAmount(List<Order> newOrders) {
        for (Order newOrder : newOrders) {
            newOrder.NetAmount__c = newOrder.TotalAmount - newOrder.ShipmentCost__c;
        }
    }
}