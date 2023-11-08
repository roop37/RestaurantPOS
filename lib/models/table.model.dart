import 'package:management/models/order.model.dart';

class OrderItem {
  final String menuItem;
  final int quantity;
  OrderItem({required this.menuItem, required this.quantity });
}
class TableModel {
  final int tableNumber;
  final bool isOccupied;
  final String? customerName;
  final int numberOfPersons;
  final DateTime? checkInTime;
  final Order? order; // Changed to include an order
  final OrderItem? orderItem;

  TableModel({
    required this.tableNumber,
    required this.isOccupied,
    this.customerName, // Optional customerName property
    required this.numberOfPersons,
    this.checkInTime,
    this.order,    // Optional checkInTime property
    this.orderItem
  });

  factory TableModel.vacant(int tableNumber) {
    return TableModel(
      tableNumber: tableNumber,
      isOccupied: false,
      numberOfPersons: 0,
    );
  }
}

