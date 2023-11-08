import 'package:flutter/material.dart';
import 'package:management/models/menu.model.dart';
import 'package:management/models/table.model.dart';
import 'package:management/screens/HomePage.dart';
import 'package:management/screens/MenuPage.dart';
import 'package:management/widgets/TakeOrderPopup.dart';

class TablePage extends StatelessWidget {
  final TableModel table;
  final List<MenuItem> menuList; // Add this line

  TablePage({required this.table,required this.menuList});


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
          title: Text('Table ${table.tableNumber}'),
        ),
        body: table.isOccupied
            ? occupiedTable(table, menuList , context)
            : vacantTable(context, table),
      ),
    );
  }


  Widget vacantTable(BuildContext context, TableModel table) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Table Number: ${table.tableNumber}'),
          ElevatedButton(
            onPressed: () {
              // Show the "Take Order" popup
              showModalBottomSheet(
                context: context,
                builder: (context) => TakeOrderPop(table: table),
              );
            },
            child: Text('Take Order'),
          ),
        ],
      ),
    );
  }



  Widget occupiedTable(TableModel table, List<MenuItem> menuList, BuildContext context) {
    final List<Widget> orderItemsWidgets = table.order?.items
        ?.map((item) {
      final MenuItem? menuItem = menuList.firstWhere(
            (menu) => menu.name == item.menuItem,
        orElse: () => MenuItem(name: '', price: 0.0), // Default value
      );

      final double price = menuItem?.price ?? 0.0;
      final double totalPrice = price * item.quantity;

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${item.menuItem} x ${item.quantity}'),
          Text('Price: $price INR'),
          Text('Total: $totalPrice INR'),
        ],
      );
    })
        .toList() ?? [];

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

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Table Number: ${table.tableNumber}'),
        Text('Customer Name: ${table.customerName ?? 'N/A'}'),
        Text('Number of Persons: ${table.numberOfPersons}'),
        Text('Check-In Time: ${table.checkInTime ?? 'Not checked in'}'),
        Divider(),
        Column(children: orderItemsWidgets),
        Text('Total Price: $totalBill INR'),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MenuPage(
                  menuList: menuList, // Pass the entire menuList
                  table: table,
                  selectedItems: table.order?.items ?? [],
                ),
              ),
            );
          },
          child: Text('Add more items'),
        ),

        ElevatedButton(
          onPressed: () {
            // Handle "Complete Order" button
          },
          child: Text('Complete Order'),
        ),
      ],
    );
  }

}

