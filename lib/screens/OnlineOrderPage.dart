import 'package:flutter/material.dart';
import 'package:management/screens/HomePage.dart';
import 'package:management/screens/ProfilePage.dart';
import 'package:management/widgets/BottomNavB.dart';

class OnlineOrderPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: ElevatedButton(
          onPressed: (){

          },
          child: Text("Take online/Take-Away order"),
        )
      ),
      bottomNavigationBar: MyBottomNavigationBar(currentIndex: 1, onTabTapped: (int index) {
        if (index == 0) {
          // Navigate to the OrderOnlinePage when the "Order Online" tab is tapped
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
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
      },), // Add the navigation bar
    );
  }
}
