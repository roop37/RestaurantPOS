import 'package:management/models/table.model.dart';

class Order {
  final String? customerName;
  final int? numberOfPersons;
  final DateTime? orderTime;
  final List<OrderItem>? items;

  Order({this.customerName, this.numberOfPersons, this.orderTime, this.items});
}
