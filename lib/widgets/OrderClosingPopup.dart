
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:management/models/OrderDetails.model.dart';
import 'package:management/models/orderItem.model.dart';
import 'package:management/models/table.model.dart';
import 'package:management/redux/App_state.dart';
import 'package:management/redux/actions.dart';
import 'package:management/widgets/OrderDetailsClosing.dart';

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
  final TextEditingController transactionTypeController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();
  bool isFlagged = false;
  String selectedTransactionType = 'Cash';
  String selectedOrderType = 'Dine in';


  void saveScreenshot() {
    // Implement saving a screenshot here
  }

  @override
  Widget build(BuildContext context) {
    final customerName = widget.tableData.order?.customerName ?? '';
    final numberOfPersons = widget.tableData.numberOfPersons ?? 0;
    final orderItems = widget.tableData.order?.items ?? <OrderItem>[];

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
          Row(
            children: [
              Text('Transaction Type: '),
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
          SizedBox(height: 20),
          Row(
            children: [
              Text('Is Flagged: '),
              Switch(
                value: isFlagged,
                onChanged: (value) {
                  setState(() {
                    isFlagged = value;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Text('Order Type: '),
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
          SizedBox(height: 20),
          isFlagged
              ? TextField(
            controller: remarksController,
            decoration: InputDecoration(labelText: 'Remarks'),
          )
              : SizedBox.shrink(),
        ],
      ),
      actions: [
        ElevatedButton(
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

            );
            final updatedTable = widget.tableData.copyWith(isOccupied: false, order: null);
            StoreProvider.of<AppState>(context).dispatch(UpdateTableAction(updatedTable));

            Navigator.of(context).pop();
            showModalBottomSheet(
              context: context,
              builder: (context) => OrderDetailsClosing(orderData: orderData), // Pass the orderData
            );
          },
          child: Text('Confirm Closing of Order'),
        ),


      ],
    );
  }
}
