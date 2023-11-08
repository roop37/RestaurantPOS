import 'package:flutter/material.dart';

class MyBottomNavigationBar extends StatefulWidget {
  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _currentIndex = 0; // Index of the selected tab

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, color: _currentIndex == 0 ? Colors.blue : Colors.grey),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.pedal_bike_outlined, color: _currentIndex == 1 ? Colors.blue : Colors.grey),
          label: 'Online',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, color: _currentIndex == 2 ? Colors.blue : Colors.grey),
          label: 'Profile',
        ),
      ],
    );
  }
}
