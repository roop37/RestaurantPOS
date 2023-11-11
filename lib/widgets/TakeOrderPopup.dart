import 'package:flutter/material.dart';
import 'package:gravitea_pos/models/menu.model.dart';
import 'package:gravitea_pos/models/order.model.dart';
import 'package:gravitea_pos/models/table.model.dart';
import 'package:gravitea_pos/screens/MenuPage.dart';
import 'package:gravitea_pos/storage/data_manager.dart';

class TakeOrderPop extends StatefulWidget {
  final TableModel table;

  TakeOrderPop({required this.table});

  @override
  _TakeOrderPopState createState() => _TakeOrderPopState();
}

class _TakeOrderPopState extends State<TakeOrderPop> {
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController numberOfPersonsController = TextEditingController();
  List<MenuItem> menuList = [];

  @override
  void initState() {
    super.initState();

    // Initialize text fields with existing values
    final String customerName = widget.table.customerName ?? '';
    numberOfPersonsController.text = widget.table.numberOfPersons.toString();
    fetchMenuData();
  }

  void fetchMenuData() async {
    List<MenuItem> fetchedMenu = await fetchMenuList();
    setState(() {
      menuList = fetchedMenu;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order for Table ${widget.table.tableNumber}',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: customerNameController,
            decoration: InputDecoration(
              labelText: 'Customer Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0), // Set border radius here
              ),
            ),
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: numberOfPersonsController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Number of Persons',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0), // Set border radius here
              ),
            ),
          ),

          SizedBox(height: 8.0),
          Expanded(
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  final String customerName = customerNameController.text;
                  final int numberOfPersons =
                      int.tryParse(numberOfPersonsController.text) ?? 0;

                  // Create an Order object
                  final Order order = Order(
                    customerName: customerName,
                    numberOfPersons: numberOfPersons,
                  );

                  // Update the table's order field
                  final updatedTable = TableModel(
                    tableNumber: widget.table.tableNumber,
                    isOccupied: widget.table.isOccupied,
                    order: order,
                    numberOfPersons: widget.table.numberOfPersons,
                  );

                  // Navigate to the menu page with the updated information
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MenuPage(
                        menuList: menuList,
                        table: updatedTable,
                        selectedItems: [], // Pass the table argument to MenuPage
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor, // Use the primary color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // Set border radius here
                  ),
                ),
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.7, // Set the width factor as needed
                  child: Center(
                    child: Text('Add Items'),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
