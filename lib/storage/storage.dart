import 'package:management/models/OrderDetails.model.dart';
import 'package:management/models/orderItem.model.dart';

extension OrderDetailsSerialization on OrderDetails {
  String toJson() {
    return '''
      {
        "name": "$name",
        "numberOfPersons": $numberOfPersons,
        "totalBill": $totalBill,
        "transactionType": "$transactionType",
        "isFlagged": $isFlagged,
        "remarks": "$remarks",
        "date": "$date",
        "orderItems": [
          ${orderItems.map((item) => item.toJson()).join(',')}
        ]
      }
    ''';
  }
}

// Add a toJson method in your OrderItem class
extension OrderItemSerialization on OrderItem {
  String toJson() {
    return '''
      {
        "menuItem": "$menuItem",
        "quantity": $quantity
      }
    ''';
  }
}