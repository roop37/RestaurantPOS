
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gravitea_pos/app_colors.dart';
import 'package:gravitea_pos/models/menu.model.dart';
import 'package:gravitea_pos/models/order.model.dart';
import 'package:gravitea_pos/models/orderItem.model.dart';
import 'package:gravitea_pos/redux/App_state.dart';
import 'package:gravitea_pos/redux/actions.dart';
import 'package:gravitea_pos/models/table.model.dart';
import 'package:gravitea_pos/storage/data_manager.dart';

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
  List<MenuItem> menuList = [];
  Map<String, int> quantityMap = {};
  String searchTerm = ''; // Add a searchTerm variable
  List<OrderItem> selectedItems = [];
  @override
  void initState() {
    super.initState();
    fetchMenuData();
  }

  void fetchMenuData() async {
    List<MenuItem> fetchedMenu = await fetchMenuList();
    setState(() {
      menuList = fetchedMenu;
    });
  }

  void updateQuantity(MenuItem menuItem, int newQuantity) {
    if (newQuantity >= 0) {
      setState(() {
        quantityMap[menuItem.name ?? ""] = newQuantity;
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
          item.name!.toLowerCase().contains(searchTerm.toLowerCase()))
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
        builder: (context) => TablePage(table: updatedTable, menuList: menuList),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        backgroundColor: AppColors.primaryColor, // Set app bar background color

      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              margin: const EdgeInsets.all(8),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Search',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: AppColors.bod,
                      width: 2.0, // Set the border thickness
                    ),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchTerm = value;
                  });
                },
              ),
            ),

          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredMenuList.length,
              itemBuilder: (context, index) {
                final menuItem = filteredMenuList[index];
                final quantity = quantityMap[menuItem.name] ?? 0;

                return Card(
                  elevation: 6.0,
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: const BorderSide(color: AppColors.bod),
                  ),
                  child: ListTile(
                    title: Text(
                      menuItem.name ?? "",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    subtitle: Text(
                      'Price: ₹ ${menuItem.price} ',
                      style: const TextStyle(fontSize: 14.0),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            updateQuantity(menuItem, quantity - 1);
                          },
                        ),
                        Text(quantity.toString()),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            updateQuantity(menuItem, quantity + 1);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: confirmSelection,
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    'Confirm Selection',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}