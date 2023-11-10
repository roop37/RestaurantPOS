import 'package:flutter/material.dart';
import 'package:management/screens/AnalyticsPage.dart';
import 'package:management/screens/HistoryPage.dart';
import 'package:management/screens/HomePage.dart';
import 'package:management/screens/MenuEdit.dart';
import 'package:management/widgets/BottomNavB.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Your branding or logo could go here
            Text(
              "GRAVITEA BILL MANAGEMENT SYSTEM",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue, // Adjust color based on your design
              ),
            ),

            Text(
              "Profile Page",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AnalyticsPage(),
                  ),
                );
              },
              child: Text('Analytics Corner'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: 2,
        onTabTapped: (int index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MenuEditPage(),
              ),
            );
          }
        },
      ),
    );
  }
}
