import 'package:management/models/orderItem.model.dart';
import 'package:management/models/table.model.dart';

class Order {
  final String? customerName;
  final int? numberOfPersons;
  final DateTime? orderTime;
  final List<OrderItem>? items;
  final int? tableNumber; // Add tableNumber to associate orders with tables
  final double? totalBill; // Add totalBill to store the total amount

  Order({
    this.customerName,
    this.numberOfPersons,
    this.orderTime,
    this.items,
    this.tableNumber, // Include tableNumber in the constructor
    this.totalBill,   // Include totalBill in the constructor
  });


}
