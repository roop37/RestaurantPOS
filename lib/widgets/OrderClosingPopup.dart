import 'package:flutter/material.dart';

class OrderClosingPopup extends StatefulWidget {
  final int tableNumber;
  final double totalBill;

  OrderClosingPopup({required this.tableNumber, required this.totalBill});

  @override
  _OrderClosingPopupState createState() => _OrderClosingPopupState();
}

class _OrderClosingPopupState extends State<OrderClosingPopup> {
  final TextEditingController transactionTypeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Table ${widget.tableNumber} - Order Closing'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Total Bill: ${widget.totalBill.toStringAsFixed(2)} INR',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          TextField(
            controller: transactionTypeController,
            decoration: InputDecoration(labelText: 'Transaction Type'),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            // Handle order closing confirmation here
            // You can access the transaction type using transactionTypeController.text
            // Close the popup
            Navigator.of(context).pop();
          },
          child: Text('Confirm Closing of Order'),
        ),
      ],
    );
  }
}
