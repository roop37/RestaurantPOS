import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:management/models/OrderDetails.model.dart';
import 'package:management/screens/HomePage.dart';
import 'package:screenshot/screenshot.dart';

class OrderDetailsClosing extends StatelessWidget {
  final OrderDetails orderData;

  OrderDetailsClosing({required this.orderData});
  final ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Order Details'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Customer Name: ${orderData.name}'),
            Text('Number of Persons: ${orderData.numberOfPersons}'),
            Text('Total Bill: ${orderData.totalBill.toStringAsFixed(2)} INR'),
            Text('Transaction Type: ${orderData.transactionType}'),
            Text('Is Flagged: ${orderData.isFlagged ? 'Yes' : 'No'}'),
            Text('Remarks: ${orderData.remarks}'),
            Text('Order Items:'),
            for (var item in orderData.orderItems)
              Text('- ${item.menuItem} x ${item.quantity}'),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            onPressed: () async {
              final Uint8List? screenshot = await screenshotController
                  .capture();
              if (screenshot != null) {
                // Save the screenshot or perform other actions
              }

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Screenshot saved successfully!'),
                  duration: Duration(seconds: 3),
                ),
              );
            };
          },
          child: Text('Save a Screenshot'),
        ),
        TextButton(
          onPressed: () {
            // Close the OrderDetailsClosing popup and navigate back to HomeScreen
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
            );          },
          child: Text('Close'),
        ),
      ],
    );
  }
}
