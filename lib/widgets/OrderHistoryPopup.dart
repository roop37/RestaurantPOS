import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gravitea_pos/app_colors.dart';
import 'package:gravitea_pos/models/OrderDetails.model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderHistoryPopup extends StatefulWidget {
  final OrderDetails orderData;
  final VoidCallback onClose;

  OrderHistoryPopup({required this.orderData, required this.onClose});

  @override
  _OrderHistoryPopupState createState() => _OrderHistoryPopupState();
}

class _OrderHistoryPopupState extends State<OrderHistoryPopup> {
  bool isFlagged = false;

  @override
  void initState() {
    super.initState();
    isFlagged = widget.orderData.isFlagged;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.primaryColor, // Add background color
      title: Text(
        'Order Details',
        style: TextStyle(color: Colors.white), // Title text color
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildText('Customer Name: ${widget.orderData.name}'),
            _buildText('Number of Persons: ${widget.orderData.numberOfPersons}'),
            _buildText('Total Bill: ₹ ${widget.orderData.totalBill.toStringAsFixed(2)} '),
            _buildText('Transaction Type: ${widget.orderData.transactionType}'),
            _buildText('Is Flagged: ${isFlagged ? 'Yes' : 'No'}'),
            _buildText('Remarks: ${widget.orderData.remarks}'),
            _buildText('Order Items:'),
            for (var item in widget.orderData.orderItems) _buildText('- ${item.menuItem} x ${item.quantity}'),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            _toggleFlagStatus();
          },
          style: ElevatedButton.styleFrom(
            primary: isFlagged ? AppColors.accentColor : AppColors.accentColor, // Flag/Unflag button color
          ),
          child: Text(isFlagged ? 'Unflag Order' : 'Flag Order'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Close',
            style: TextStyle(color: AppColors.accentColor), // Close button color
          ),
        ),
      ],
    );
  }

  Widget _buildText(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: TextStyle(color: Colors.white), // Text color
      ),
    );
  }

  void _toggleFlagStatus() {
    setState(() {
      isFlagged = !isFlagged;
    });
    _updateOrderFlagStatus();
  }

  void _updateOrderFlagStatus() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> orderListJson = prefs.getStringList('orderList') ?? [];

      List<OrderDetails> orderList = orderListJson
          .map((orderJson) => OrderDetails.fromJson(json.decode(orderJson)))
          .toList();

      OrderDetails targetOrder = orderList.firstWhere(
            (order) => order.name == widget.orderData.name,
        orElse: () => OrderDetails(
          name: '',
          numberOfPersons: 0,
          orderItems: [],
          totalBill: 0.0,
          transactionType: '',
          isFlagged: false,
          remarks: '',
          date: DateTime.now(),
          orderType: '',
        ),
      );

      if (targetOrder != null) {
        OrderDetails updatedOrder = targetOrder.copyWith(isFlagged: !targetOrder.isFlagged);
        int index = orderList.indexOf(targetOrder);
        orderList[index] = updatedOrder;
        orderListJson = orderList.map((order) => json.encode(order.toJson())).toList();
        prefs.setStringList('orderList', orderListJson);

        setState(() {
          isFlagged = updatedOrder.isFlagged;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(updatedOrder.isFlagged ? 'Order flagged' : 'Order unflagged'),
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        print('Order not found with name: ${widget.orderData.name}');
      }
    } catch (e) {
      print('Error updating order flagged status: $e');
    }
  }

}
