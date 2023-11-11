import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gravitea_pos/models/menu.model.dart';
import 'package:gravitea_pos/models/table.model.dart';
import 'package:gravitea_pos/redux/App_state.dart';
import 'package:gravitea_pos/redux/actions.dart';
import 'package:gravitea_pos/screens/HomePage.dart';
import 'package:gravitea_pos/screens/MenuPage.dart';
import 'package:gravitea_pos/widgets/OrderClosingPopup.dart';
import 'package:gravitea_pos/widgets/TakeOrderPopup.dart';

import '../app_colors.dart'; // Import the color file

class TablePage extends StatelessWidget {
  final TableModel table;
  final List<MenuItem> menuList;

  TablePage({required this.table, required this.menuList});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigate to the home page when the back button is pressed
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
              (Route<dynamic> route) => false,
        );
        return false; // Prevent default back button behavior
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Table ${table.tableNumber}',
            style: const TextStyle(color: Colors.white), // Set text color to white
          ),
          backgroundColor: AppColors.primaryColor, // Set app bar background color
        ),
        body: table.isOccupied
            ? occupiedTable(table, menuList, context)
            : vacantTable(context, table),
      ),
    );
  }

  Widget vacantTable(BuildContext context, TableModel table) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Table Number: ${table.tableNumber}',
            style: const TextStyle(fontSize: 23.0, color: AppColors.primaryColor), // Adjust font size and color
          ),
          ElevatedButton(
            onPressed: () {
              // Show the "Take Order" popup
              showModalBottomSheet(
                context: context,
                builder: (context) => TakeOrderPop(table: table),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0), // Set border radius here
              ),// Set button background color
            ),
            child: const Text(
              'Take Order',
              style: TextStyle(fontSize: 16.0),

            ),
          ),
        ],
      ),
    );
  }

  Widget occupiedTable(TableModel table, List<MenuItem> menuList, BuildContext context) {

    final List<Widget> orderItemsWidgets = table.order?.items
        ?.map(
          (item) {
        final MenuItem? menuItem = menuList.firstWhere(
              (menu) => menu.name == item.menuItem,
          orElse: () => MenuItem(name: '', price: 0.0), // Default value
        );

        final double price = menuItem?.price ?? 0.0;
        final double totalPrice = price * item.quantity;

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0), // Add vertical padding
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade300)), // Add a bottom border
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 4, // Adjust the flex values based on your preferred column widths
                child: Text(
                  '${item.menuItem} x ${item.quantity}',
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  'Price: ₹ $price ',
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  'Total: ₹ $totalPrice ',
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
            ],
          ),
        );
      },
    )
        .toList() ??
        [];


    final double totalBill = table.order?.items
        ?.fold<double>(
      0,
          (total, item) {
        final MenuItem? menuItem = menuList.firstWhere(
              (menu) => menu.name == item.menuItem,
          orElse: () => MenuItem(name: '', price: 0.0), // Default value
        );
        final double price = menuItem?.price ?? 0.0;
        return total + price * item.quantity;
      },
    ) ??
        0.0;

    return Container(
      margin: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Table Number: ${table.tableNumber}',
              style: const TextStyle(fontSize: 18.0, color: AppColors.primaryColor),
            ),
            const SizedBox(height: 8.0), // Add spacing between elements
            Text(
              'Customer Name: ${table.customerName ?? 'N/A'}',
              style: const TextStyle(fontSize: 16.0),
            ),
            Text(
              'Number of Persons: ${table.numberOfPersons}',
              style: const TextStyle(fontSize: 16.0),
            ),
            Text(
              'Check-In Time: ${table.checkInTime ?? 'Not checked in'}',
              style: const TextStyle(fontSize: 16.0),
            ),
            const Divider(),
            const SizedBox(height: 10.0), // Add spacing between elements
            Column(children: orderItemsWidgets),
            const SizedBox(height: 10.0), // Add spacing between elements
            Text(
              'Total Bill Amount: ₹ $totalBill',
              style: const TextStyle(fontSize: 20.0 ,color: AppColors.primaryColor,fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0), // Add more spacing after the total price
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MenuPage(
                      menuList: menuList,
                      table: table,
                      selectedItems: table.order?.items ?? [],
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text(
                'Add more items',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            const SizedBox(height: 8.0), // Add spacing between buttons
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return OrderClosingPopup(
                      tableNumber: table.tableNumber,
                      totalBill: totalBill,
                      tableData: table,
                      date: table.checkInTime ?? DateTime.now(),
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                primary: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text(
                'Complete Order',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            const SizedBox(height: 8.0), // Add spacing between buttons
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text(
                        "Confirm Cancellation",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                      content: const Text(
                        "Are you sure you want to cancel the order?",
                        style: TextStyle(fontSize: 16.0),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "No",
                            style: TextStyle(color: Colors.black87, fontSize: 16.0),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            final updatedTable = table.copyWith(isOccupied: false, order: null);
                            StoreProvider.of<AppState>(context).dispatch(UpdateTableAction(updatedTable));
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Yes",
                            style: TextStyle(color: Colors.red, fontSize: 16.0),
                          ),
                        ),
                      ],
                    );
                  },
                );

              },
              style: ElevatedButton.styleFrom(
                primary: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text(
                "Cancel Order",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
    );

  }
}
