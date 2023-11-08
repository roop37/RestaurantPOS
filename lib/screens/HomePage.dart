import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:management/models/MenuList.dart';
import 'package:management/models/table.model.dart';
import 'package:management/redux/App_state.dart';
import 'package:management/screens/TablePage.dart';
import 'package:management/widgets/BottomNavBar.dart';
import 'package:management/widgets/TableRectangles.dart';
import 'package:redux/redux.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GraviTEA'),
      ),
      body: StoreConnector<AppState, List<TableModel>>(
        converter: (store) => store.state.tables,
        builder: (context, tables) {
          return ListView.builder(
            itemCount: tables.length,
            itemBuilder: (context, index) {
              final table = tables[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TablePage(table: table, menuList: dummyMenuList,), // Pass the entire TableModel
                    ),
                  );
                },
                child: TableWidget(
                  tableNumber: table.tableNumber,
                  isOccupied: table.isOccupied,
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: MyBottomNavigationBar(),
    );
  }
}
