public without sharing class TeamOrdersController {
    public Decimal SumOrders {
        get {
            AggregateResult groupedResults = [SELECT SUM(TotalAmount) total FROM Order];
            return (Decimal)groupedResults.get('total');
        }
        set;
    }

    public List<OrdersBySalesRep> OrdersBySalesRep {
        get {
            List<OrdersBySalesRep> ordersBySalesRepsList = new List<OrdersBySalesRep>();
            for (AggregateResult ar : [
                SELECT SUM(TotalAmount) total, Owner.Name salesRep
                FROM Order
                GROUP BY Owner.Name
                ]) {
                    ordersBySalesRepsList.add(new OrdersBySalesRep(ar));
            }
            return ordersBySalesRepsList;
        }
        set;
    }

    public class OrdersBySalesRep {
        public String SalesRep { get; set; }
        public Decimal Total { get; set; }

        public OrdersBySalesRep(AggregateResult ar) {
            SalesRep = (String)ar.get('salesRep');
            Total = (Decimal)ar.get('total');
        }
    }
}
