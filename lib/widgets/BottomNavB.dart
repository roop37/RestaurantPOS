import 'package:flutter/material.dart';
import 'package:gravitea_pos/app_colors.dart';

class MyBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTabTapped;
  final Color backgroundColor; // Added backgroundColor parameter

  MyBottomNavigationBar({
    required this.currentIndex,
    required this.onTabTapped,
    required this.backgroundColor, // Add the new parameter
  });

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      onTap: widget.onTabTapped,
      backgroundColor: AppColors.nav, // Use backgroundColor from the widget
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, color: widget.currentIndex == 0 ? Colors.black : Colors.grey),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book,color: widget.currentIndex == 1 ? Colors.black : Colors.grey),
          label: 'My Menu',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, color: widget.currentIndex == 2 ? Colors.black : Colors.grey),
          label: 'Profile',
        ),
      ],
    );
  }
}
