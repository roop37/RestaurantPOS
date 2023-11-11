import 'package:flutter/material.dart';
import 'package:gravitea_pos/app_colors.dart';
import 'package:gravitea_pos/models/OrderDetails.model.dart';
import 'package:gravitea_pos/widgets/OrderHistoryPopup.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  DateTime selectedDate = DateTime.now();
  String selectedOrderType = 'all';
  String selectedPaymentMode = 'all';
  String selectedFlagged = 'all';

  List<OrderDetails> orderList = [];

  @override
  void initState() {
    super.initState();
    // Fetch orders when the widget is initialized
    fetchOrdersFromLocalStorage();
  }

  Future<void> fetchOrdersFromLocalStorage() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> storedOrders = prefs.getStringList('orderList') ?? [];

      setState(() {
        orderList = storedOrders
            .map((orderJson) =>
            OrderDetails.fromJson(json.decode(orderJson)))
            .toList();
      });
      print('Successfully fetched orders: $orderList');
    } catch (e) {
      print('Error fetching order data: $e');
    }
  }

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
          selectedOrderType.toLowerCase() == 'all' ||
              order.orderType.toLowerCase() == selectedOrderType.toLowerCase();

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
        title: const Text('History'),
        backgroundColor: AppColors.primaryColor, // Set app bar background color

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
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          const Text('Date: '),
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
            style: ElevatedButton.styleFrom(
              primary: AppColors.primaryColor, // Set the button color
            ),
            child: Text(
              '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildDropdown(
                label: 'Order Type',
                value: selectedOrderType,
                items: ['all', 'Dine in', 'Take away', 'Online Order'],
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
              Row(
                children: [
                  const Text('Flagged: '),
                  Switch(
                    value: selectedFlagged == 'flagged',
                    onChanged: (value) {
                      setState(() {
                        selectedFlagged = value ? 'flagged' : 'all';
                      });
                    },
                    activeColor: AppColors.primaryColor,
                  )

                ],
              ),
            ],
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
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return OrderHistoryPopup(orderData: orders[index], onClose: () {

                      setState(() {
                        fetchOrdersFromLocalStorage();
                      });
                    });                    // Use the actual order data for the selected item
                  },
                );
              },


              child: Padding(
                padding: const EdgeInsets.all(16.0),
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
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          if (order.name.isNotEmpty) Text('Name: ${order.name}'),
                          Text('Order Type: ${order.orderType}'),
                          Text('Check in Time: ${order.date.hour}:${order.date.minute}'),
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
                            '₹ ${order.totalBill.toStringAsFixed(2)} ',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                          ),
                          if (order.isFlagged) const Icon(Icons.flag, color: Colors.red, size: 16.0),
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
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.primaryColor, // Set your desired background color
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Earnings',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              color: Colors.white, // Set your desired text color
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            '₹ ${totalEarnings.toStringAsFixed(2)} ',
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Set your desired text color
            ),
          ),
        ],
      ),
    );
  }

}
