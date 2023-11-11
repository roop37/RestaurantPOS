import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gravitea_pos/models/menu.model.dart';
import 'package:gravitea_pos/models/table.model.dart';
import 'package:gravitea_pos/redux/App_state.dart';
import 'package:gravitea_pos/screens/MenuEdit.dart';
import 'package:gravitea_pos/screens/ProfilePage.dart';
import 'package:gravitea_pos/screens/TablePage.dart';
import 'package:gravitea_pos/storage/data_manager.dart';
import 'package:gravitea_pos/widgets/BottomNavB.dart';
import 'package:gravitea_pos/widgets/TableRectangles.dart';

import '../app_colors.dart'; // Import the color file

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<MenuItem> menuList = [];

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

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 1) {
      // Navigate to the OrderOnlinePage when the "Order Online" tab is tapped
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MenuEditPage(),
        ),
      );
    } else if (index == 2) {
      // Navigate to the ProfilePage when the "Profile" tab is tapped
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'GraviTEA',
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
        backgroundColor: AppColors.primaryColor, // Set app bar background color
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
                      builder: (context) =>
                          TablePage(table: table, menuList: menuList),
                    ),
                  );
                },
                child: TableWidget(
                  tableNumber: table.tableNumber,
                  isOccupied: table.isOccupied,
                  backgroundColor: AppColors.accentColor, // Set table background color
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: _currentIndex,
        onTabTapped: _onTabTapped,
        backgroundColor: AppColors.primaryColor, // Set bottom navigation bar background color
      ),
    );
  }
}
