public class OrderService {
    public static Decimal getTotalOrderAmount() {
        AggregateResult groupedResults = [SELECT SUM(TotalAmount) total FROM Order];
        return (Decimal)groupedResults.get('total');
    }
}