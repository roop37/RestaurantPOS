import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:management/models/MenuList.dart';
import 'package:management/models/menu.model.dart';
import 'package:management/models/table.model.dart';
import 'package:management/redux/App_state.dart';
import 'package:management/screens/MenuEdit.dart';
import 'package:management/screens/ProfilePage.dart';
import 'package:management/screens/TablePage.dart';
import 'package:management/storage/data_manager.dart';
import 'package:management/widgets/BottomNavB.dart';
import 'package:management/widgets/TableRectangles.dart';
import 'package:redux/redux.dart';

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
                      builder: (context) => TablePage(table: table, menuList: menuList),
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
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: _currentIndex,
        onTabTapped: _onTabTapped,
      ),
    );
  }
}
