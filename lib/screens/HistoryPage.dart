import 'package:flutter/material.dart';
import 'package:management/models/OrderDetails.model.dart';
import 'dart:math';

import 'package:management/models/orderItem.model.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  DateTime selectedDate = DateTime.now();
  String selectedOrderType = 'all';
  String selectedPaymentMode = 'all';
  String selectedFlagged = 'all';

  List<OrderDetails> orderList = List.generate(30, (index) {
    // Generate 30 dummy orders with random data
    return OrderDetails(
      name: 'Customer $index',
      numberOfPersons: Random().nextInt(5) + 1, // Random number of persons between 1 and 5
      orderItems: List.generate(3, (itemIndex) {
        return OrderItem(
          menuItem: 'Item $itemIndex',
          quantity: Random().nextInt(3) + 1, // Random quantity between 1 and 3
        );
      }),
      totalBill: Random().nextDouble() * 100, // Random total bill between 0 and 100
      transactionType: ['dine in', 'take-away', 'online order'][Random().nextInt(3)], // Random transaction type
      isFlagged: Random().nextBool(), // Random flagged value
      remarks: 'Remarks for order $index', // Remarks with order index
      date: DateTime.now().subtract(Duration(days: Random().nextInt(2))), // Random date (today or yesterday)
    );
  });

  @override
  Widget build(BuildContext context) {
    // Filter the orders based on selected filters
    List<OrderDetails> filteredOrders = orderList.where((order) {
      // Filter by date
      bool filterByDate = order.date.day == selectedDate.day &&
          order.date.month == selectedDate.month &&
          order.date.year == selectedDate.year;

      // Filter by order type
      bool filterByOrderType =
          selectedOrderType == 'all' || order.transactionType.toLowerCase() == selectedOrderType;

      // Filter by payment mode
      bool filterByPaymentMode =
          selectedPaymentMode == 'all' || order.transactionType.toLowerCase() == selectedPaymentMode;

      // Filter by flagged
      bool filterByFlagged = selectedFlagged == 'all' || (order.isFlagged && selectedFlagged == 'flagged');

      // Apply all filters
      return filterByDate && filterByOrderType && filterByPaymentMode && filterByFlagged;
    }).toList();


    // Calculate total earnings
    double totalEarnings = filteredOrders.fold(0.0, (sum, order) => sum + order.totalBill);

    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDatePicker(),
          _buildFilters(),
          _buildOrderList(filteredOrders),
          _buildTotalEarnings(totalEarnings),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          Text('Date: '),
          ElevatedButton(
            onPressed: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null && pickedDate != selectedDate) {
                setState(() {
                  selectedDate = pickedDate;
                });
              }
            },
            child: Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildDropdown(
            label: 'Order Type',
            value: selectedOrderType,
            items: ['all', 'dine in', 'take-away', 'online order'],
            onChanged: (String? value) {
              if (value != null) {
                setState(() {
                  selectedOrderType = value;
                });
              }
            },
          ),
          _buildDropdown(
            label: 'Payment Mode',
            value: selectedPaymentMode,
            items: ['all', 'cash', 'online'],
            onChanged: (String? value) {
              if (value != null) {
                setState(() {
                  selectedPaymentMode = value;
                });
              }
            },
          ),
          _buildDropdown(
            label: 'Flagged',
            value: selectedFlagged,
            items: ['all', 'flagged'],
            onChanged: (String? value) {
              if (value != null) {
                setState(() {
                  selectedFlagged = value;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        DropdownButton<String>(
          value: value,
          items: items.map<DropdownMenuItem<String>>((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
  Widget _buildOrderList(List<OrderDetails> orders) {
    return Expanded(
      child: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          OrderDetails order = orders[index];
          // Customize how each order is displayed in the list
          return Card(
            child: InkWell(
              onTap: () {
                // Handle card tap (if needed)
              },
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left part: Date, Name, OrderType, and Number of Persons
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${order.date.day}/${order.date.month}/${order.date.year}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          if (order.name.isNotEmpty) Text('Name: ${order.name}'),
                          Text('Order Type: ${order.transactionType}'),
                          Text('No. of Persons: ${order.numberOfPersons}'),
                        ],
                      ),
                    ),
                    // Middle part: Payment Type and No. of Persons
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Payment Type: ${order.transactionType}'),
                          if (order.numberOfPersons > 0) Text('No. of Persons: ${order.numberOfPersons}'),
                        ],
                      ),
                    ),
                    // Right part: Total Bill and Flag (if flagged)
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${order.totalBill.toStringAsFixed(2)} INR',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                          ),
                          if (order.isFlagged) Icon(Icons.flag, color: Colors.red, size: 16.0),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }



  Widget _buildTotalEarnings(double totalEarnings) {
    return Card(
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Earnings', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('${totalEarnings.toStringAsFixed(2)} INR'),
          ],
        ),
      ),
    );
  }
}
