import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gravitea_pos/app_colors.dart';
import 'package:gravitea_pos/models/OrderDetails.model.dart';
import 'package:gravitea_pos/models/orderItem.model.dart';
import 'package:gravitea_pos/models/table.model.dart';
import 'package:gravitea_pos/redux/App_state.dart';
import 'package:gravitea_pos/redux/actions.dart';
import 'package:gravitea_pos/widgets/OrderDetailsClosing.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderClosingPopup extends StatefulWidget {
  final int tableNumber;
  final TableModel tableData;
  final double totalBill;
  final DateTime date;

  OrderClosingPopup({
    required this.tableNumber,
    required this.tableData,
    required this.totalBill,
    required this.date,
  });

  @override
  _OrderClosingPopupState createState() => _OrderClosingPopupState();
}

class _OrderClosingPopupState extends State<OrderClosingPopup> {
  final TextEditingController transactionTypeController =
  TextEditingController();
  final TextEditingController remarksController = TextEditingController();
  bool isFlagged = false;
  String selectedTransactionType = 'Cash';
  String selectedOrderType = 'Dine in';

  Future<void> saveOrderDataToLocal(OrderDetails orderData) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> orderList = prefs.getStringList('orderList') ?? [];

      // Convert OrderDetails to JSON and add it to the list
      final orderJson = json.encode(orderData.toJson());
      orderList.add(orderJson);
      print('Saved order: $orderJson');

      // Save the updated list to shared preferences
      prefs.setStringList('orderList', orderList);
      print('Updated orderList: $orderList');
    } catch (e) {
      print('Error saving order data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final customerName = widget.tableData.order?.customerName ?? '';
    final numberOfPersons = widget.tableData.numberOfPersons ?? 0;
    final orderItems = widget.tableData.order?.items ?? <OrderItem>[];

    return AlertDialog(
      title: Text('Table ${widget.tableNumber} - Order Closing'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Total Bill: ₹ ${widget.totalBill.toStringAsFixed(2)} ',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('Transaction Type: '),
                DropdownButton<String>(
                  value: selectedTransactionType,
                  onChanged: (value) {
                    setState(() {
                      selectedTransactionType = value!;
                    });
                  },
                  items: <String>['Cash', 'Online']
                      .map<DropdownMenuItem<String>>(
                        (String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ),
                  )
                      .toList(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('Is Flagged: '),
                Switch(
                  value: isFlagged,
                  onChanged: (value) {
                    setState(() {
                      isFlagged = value;
                    });
                  },
                  activeColor: AppColors.primaryColor,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('Order Type: '),
                DropdownButton<String>(
                  value: selectedOrderType,
                  onChanged: (value) {
                    setState(() {
                      selectedOrderType = value!;
                    });
                  },
                  items: <String>['Dine in', 'Take away', 'Online Order']
                      .map<DropdownMenuItem<String>>(
                        (String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ),
                  )
                      .toList(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            isFlagged
                ? TextField(
              controller: remarksController,
              decoration: const InputDecoration(labelText: 'Remarks'),
            )
                : const SizedBox.shrink(),
          ],
        ),
      ),
      actions: [
        Container(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              final remarks = remarksController.text;
              final orderData = OrderDetails(
                date: widget.date,
                name: customerName,
                numberOfPersons: numberOfPersons,
                orderItems: orderItems, // Serialize items
                transactionType: selectedTransactionType,
                isFlagged: isFlagged,
                remarks: remarks,
                totalBill: widget.totalBill,
                orderType: selectedOrderType, // Set the orderType property
              );

              saveOrderDataToLocal(orderData);

              final updatedTable = widget.tableData.copyWith(
                isOccupied: false,
                order: null,
              );
              StoreProvider.of<AppState>(context)
                  .dispatch(UpdateTableAction(updatedTable));

              Navigator.of(context).pop();
              showModalBottomSheet(
                context: context,
                builder: (context) => OrderDetailsClosing(
                  orderData: orderData,
                ), // Pass the orderData
              );
            },
            style: ElevatedButton.styleFrom(
              primary: AppColors.primaryColor, // Set your primary color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: const Text('Confirm Closing of Order'),
          ),
        ),
      ],
    );
  }
}
