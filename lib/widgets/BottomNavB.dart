import 'package:flutter/material.dart';

class MyBottomNavigationBar extends StatefulWidget {
  final int currentIndex; // Added currentIndex parameter
  final Function(int) onTabTapped; // Added onTabTapped parameter

  MyBottomNavigationBar({
    required this.currentIndex,
    required this.onTabTapped,
  });

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.currentIndex, // Use currentIndex from the widget
      onTap: widget.onTabTapped, // Use onTabTapped from the widget
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, color: widget.currentIndex == 0 ? Colors.blue : Colors.grey),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.pedal_bike_outlined, color: widget.currentIndex == 1 ? Colors.blue : Colors.grey),
          label: 'Order Online',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, color: widget.currentIndex == 2 ? Colors.blue : Colors.grey),
          label: 'Profile',
        ),
      ],
    );
  }
}
