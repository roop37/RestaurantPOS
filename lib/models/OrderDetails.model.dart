
import 'package:gravitea_pos/models/orderItem.model.dart';

class OrderDetails {
  final String name;
  final int numberOfPersons;
  final List<OrderItem> orderItems;
  final double totalBill;
  final String transactionType;
  final bool isFlagged;
  final String remarks;
  final DateTime date;
  final String orderType; // New field for order type


  OrderDetails({
    required this.name,
    required this.numberOfPersons,
    required this.orderItems,
    required this.totalBill,
    required this.transactionType,
    required this.isFlagged,
    required this.remarks,
    required this.date,
    required this.orderType, // Initialize order type

  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'numberOfPersons': numberOfPersons,
      'orderItems': orderItems.map((item) => item.toJson()).toList(),
      'totalBill': totalBill,
      'transactionType': transactionType,
      'isFlagged': isFlagged,
      'remarks': remarks,
      'date': date.toIso8601String(),
      'orderType': orderType, // Serialize order type

    };
  }
  static OrderDetails fromJson(Map<String, dynamic> json) {
    return OrderDetails(
      name: json['name'] ?? '', // Use an empty string if 'name' is null
      numberOfPersons: json['numberOfPersons'] ?? 0, // Use 0 if 'numberOfPersons' is null
      orderItems: (json['orderItems'] as List<dynamic>?)
          ?.map((item) => OrderItem.fromJson(item))
          .toList() ?? [], // Use an empty list if 'orderItems' is null
      totalBill: json['totalBill'] ?? 0.0, // Use 0.0 if 'totalBill' is null
      transactionType: json['transactionType'] ?? '', // Use an empty string if 'transactionType' is null
      isFlagged: json['isFlagged'] ?? false, // Use false if 'isFlagged' is null
      remarks: json['remarks'] ?? '', // Use an empty string if 'remarks' is null
      date: DateTime.parse(json['date'] ?? ''), // Use current date if 'date' is null
      orderType: json['orderType'] ?? '', // Use an empty string if 'orderType' is null
    );
  }

  OrderDetails copyWith({
    bool? isFlagged,
    // Add other fields you want to be able to update
  }) {
    return OrderDetails(
      name: this.name,
      numberOfPersons: this.numberOfPersons,
      orderItems: this.orderItems,
      totalBill: this.totalBill,
      transactionType: this.transactionType,
      isFlagged: isFlagged ?? this.isFlagged,
      remarks: this.remarks,
      date: this.date,
      orderType: this.orderType,
    );
  }




}
