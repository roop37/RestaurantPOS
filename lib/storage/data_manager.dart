// data_manager.dart

import 'dart:convert';
import 'package:management/storage/menu_serialization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:management/models/menu.model.dart';

Future<List<MenuItem>> fetchMenuList() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? storedMenu = prefs.getString('menuList');

  if (storedMenu != null) {
    try {
      final List<dynamic> menuJson = json.decode(storedMenu);
      return menuJson.map((item) => MenuItem.fromJson(item)).toList();
    } catch (e) {
      print('Error decoding menu list: $e');
    }
  }

  return dummyMenuList;
}
Future<void> updateMenuList(List<MenuItem> updatedMenuList) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  try {
    final String updatedMenuJson = updatedMenuList.toJson();

    prefs.setString('menuList', updatedMenuJson);
  } catch (e) {
    print('Error encoding menu list: $e');
  }
}


List<MenuItem> dummyMenuList = [
  MenuItem(name: "Cappuccino", price: 10),
  MenuItem(name: "Croissant", price: 20),
  MenuItem(name: "Avocado Toast", price: 15),
  MenuItem(name: "Muffin", price:30),
  MenuItem(name: "Club Sandwich", price: 100),
  MenuItem(name: "Smoothie", price: 50),
  MenuItem(name: "Fruit Salad", price: 30),
  MenuItem(name: "Iced Tea", price: 20),
  // Add more items as needed
];

