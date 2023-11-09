import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:management/models/MenuList.dart';
import 'package:management/models/menu.model.dart';
import 'package:management/models/order.model.dart';
import 'package:management/models/orderItem.model.dart';
import 'package:management/redux/App_state.dart';
import 'package:management/redux/actions.dart';
import 'package:management/models/table.model.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'TablePage.dart';

class MenuPage extends StatefulWidget {
  final List<MenuItem> menuList;
  final TableModel table;
  final List<OrderItem> selectedItems;



  MenuPage({required this.menuList, required this.table, required this.selectedItems});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<MenuItem> menuList = dummyMenuList;
  Map<String, int> quantityMap = {};
  String searchTerm = ''; // Add a searchTerm variable
  List<OrderItem> selectedItems = [];

  void updateQuantity(MenuItem menuItem, int newQuantity) {
    if (newQuantity >= 0) {
      setState(() {
        quantityMap[menuItem.name] = newQuantity;
      });
    }
  }

  List<MenuItem> get filteredMenuList {
    // Filter the menuList based on the searchTerm
    if (searchTerm.isEmpty) {
      return menuList;
    } else {
      return menuList
          .where((item) =>
          item.name.toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();
    }
  }

  void confirmSelection() async{
    final List<OrderItem> newItems = [];

    quantityMap.forEach((itemName, quantity) {
      if (quantity > 0) {
        newItems.add(OrderItem(menuItem: itemName, quantity: quantity));
      }
    });

    // Merge the new items with the previously selected items
    final List<OrderItem> allItems = List.from(widget.table.order?.items ?? [])..addAll(newItems);

    final DateTime currentTime = DateTime.now();
    final Order order = Order(
      customerName: widget.table.order?.customerName ?? '',
      numberOfPersons: widget.table.order?.numberOfPersons ?? 0,
      orderTime: currentTime,
      items: allItems, // Use the merged items here
    );

    final updatedTable = TableModel(
      tableNumber: widget.table.tableNumber,
      isOccupied: true,
      customerName: widget.table.order?.customerName ?? '',
      numberOfPersons: widget.table.order?.numberOfPersons ?? 0,
      checkInTime: currentTime,
      order: order,
    );

    StoreProvider.of<AppState>(context).dispatch(UpdateTableAction(updatedTable));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => TablePage(table: updatedTable, menuList: dummyMenuList),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchTerm = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredMenuList.length,
              itemBuilder: (context, index) {
                final menuItem = filteredMenuList[index];
                final quantity = quantityMap[menuItem.name] ?? 0;

                return ListTile(
                  title: Text(menuItem.name),
                  subtitle: Text('Price: ${menuItem.price} INR'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          updateQuantity(menuItem, quantity - 1);
                        },
                      ),
                      Text(quantity.toString()),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          updateQuantity(menuItem, quantity + 1);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: confirmSelection,
              child: Text('Confirm Selection'),
            ),
          ],
        ),
      ),
    );
  }
}

