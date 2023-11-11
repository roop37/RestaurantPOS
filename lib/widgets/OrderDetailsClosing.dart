import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:gravitea_pos/app_colors.dart';
import 'package:gravitea_pos/models/OrderDetails.model.dart';
import 'package:gravitea_pos/screens/HomePage.dart';
import 'package:path_provider/path_provider.dart';

class OrderDetailsClosing extends StatelessWidget {
  final OrderDetails orderData;

  OrderDetailsClosing({required this.orderData});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: key,
      child: AlertDialog(
        title: Text(
          'Order Details',
          style: TextStyle(color: AppColors.primaryColor), // Customize title color
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Customer Name', orderData.name),
              _buildDetailRow(
                'Number of Persons',
                orderData.numberOfPersons.toString(),
              ),
              _buildDetailRow(
                'Total Bill',
                '₹ ${orderData.totalBill.toStringAsFixed(2)} ',
              ),
              _buildDetailRow('Transaction Type', orderData.transactionType),
              _buildDetailRow(
                'Is Flagged',
                orderData.isFlagged ? 'Yes' : 'No',
              ),
              _buildDetailRow('Remarks', orderData.remarks),
              Text('Order Items:', style: TextStyle(fontWeight: FontWeight.bold)),
              for (var item in orderData.orderItems)
                _buildDetailRow(
                  '- ${item.menuItem} x ${item.quantity}',
                  '',
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Close the OrderDetailsClosing popup and navigate back to HomeScreen
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
              );
            },
            style: TextButton.styleFrom(
              primary: AppColors.primaryColor, // Customize button text color
            ),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),

    );
  }
}
