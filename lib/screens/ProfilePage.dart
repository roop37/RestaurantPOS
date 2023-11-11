import 'package:flutter/material.dart';
import 'package:gravitea_pos/screens/AnalyticsPage.dart';
import 'package:gravitea_pos/screens/HistoryPage.dart';
import 'package:gravitea_pos/screens/HomePage.dart';
import 'package:gravitea_pos/screens/MenuEdit.dart';
import 'package:gravitea_pos/widgets/BottomNavB.dart';
import '../app_colors.dart'; // Import the color file

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.nav, AppColors.bod],
          ),
        ),
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Your branding or logo could go here
                const Text(
                  "GRAVITEA BILL MANAGEMENT SYSTEM",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor, // Use your primary color
                  ),
                ),

                const SizedBox(height: 20.0), // Add spacing

                const Text(
                  "Profile Page",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accentColor, // Use your secondary color
                  ),
                ),

                const SizedBox(height: 40.0), // Add spacing

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HistoryPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.primaryColor, // Set button background color
                    padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 16.0), // Adjust padding
                  ),
                  child: const Text('History'),
                ),

                const SizedBox(height: 20.0), // Add spacing

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AnalyticsPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.primaryColor, // Set button background color
                    padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0), // Adjust padding
                  ),
                  child: const Text('Analytics Corner'),
                ),
              ],
            ),
          ),
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
        backgroundColor: Colors.transparent, // Set bottom navigation bar background color
      ),
    );
  }
}
