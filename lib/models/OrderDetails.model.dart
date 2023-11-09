import 'dart:convert';

import 'package:management/models/orderItem.model.dart';

class OrderDetails {
  final String name;
  final int numberOfPersons;
  final List<OrderItem> orderItems;
  final double totalBill;
  final String transactionType;
  final bool isFlagged;
  final String remarks;
  final DateTime date;


  OrderDetails({
    required this.name,
    required this.numberOfPersons,
    required this.orderItems,
    required this.totalBill,
    required this.transactionType,
    required this.isFlagged,
    required this.remarks,
    required this.date

  });


}
