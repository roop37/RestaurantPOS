import 'package:management/models/order.model.dart';
import 'package:management/models/orderItem.model.dart';


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

  TableModel copyWith({bool? isOccupied, Order? order}) {
    return TableModel(
      tableNumber: this.tableNumber,
      isOccupied: isOccupied ?? this.isOccupied,
      order: order ?? this.order,
      customerName: this.customerName,
      numberOfPersons: this.numberOfPersons,
      checkInTime: this.checkInTime,
    );
  }


  factory TableModel.vacant(int tableNumber) {
    return TableModel(
      tableNumber: tableNumber,
      isOccupied: false,
      numberOfPersons: 0,
    );
  }
}

