import 'package:flutter/material.dart';
import 'package:management/screens/AddMenuItemPage.dart';
import 'package:management/screens/HistoryPage.dart';
import 'package:management/screens/HomePage.dart';
import 'package:management/screens/OnlineOrderPage.dart';
import 'package:management/widgets/BottomNavB.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: [
          SizedBox(height: 100,),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoryPage(),
                ),
              );
            },
            child: Text('History'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AddMenuItemPage(),
                ),
              );
            },
            child: Text('Add New Menu Item'),
          ),
        ],
      ),
      bottomNavigationBar: MyBottomNavigationBar(currentIndex: 2, onTabTapped: (int index) {
        if (index == 0) {
          // Navigate to the OrderOnlinePage when the "Order Online" tab is tapped
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
          );
        } else if (index == 1) {
          // Navigate to the ProfilePage when the "Profile" tab is tapped
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OnlineOrderPage(),
            ),
          );
        }
      },), // Add the navigation bar
    );
  }
}
