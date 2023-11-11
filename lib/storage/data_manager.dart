// data_manager.dart

import 'dart:convert';
import 'package:gravitea_pos/storage/menu_serialization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gravitea_pos/models/menu.model.dart';

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
  MenuItem(name: "GraviTea special Tea Big", price: 25),
  MenuItem(name: "GraviTea special Tea Small", price: 10),
  MenuItem(name: "Black Tea", price: 20),
  MenuItem(name: "Elalchi tea", price: 50),
  MenuItem(name: "Kesaria Chai", price: 50),
  MenuItem(name: "Rose Chai", price: 50),
  MenuItem(name: "Tandoori Chai", price: 50),
  MenuItem(name: "Chocolate Chai", price: 50),
  MenuItem(name: "Green Chai", price: 30),
  MenuItem(name: "Lemon Chai", price: 30),
  MenuItem(name: "Black Chail", price: 20),
  MenuItem(name: "Black Chai (added honey)", price: 25),
  MenuItem(name: "French Fry", price: 95),
  MenuItem(name: "Onion Pakora", price: 90),
  MenuItem(name: "Paneer Pakora (6pcs)", price: 130),
  MenuItem(name: "Alu Bonda", price: 25),
  MenuItem(name: "Vada Paw", price: 40),
  MenuItem(name: "Crispy Babycorn", price: 120),
  MenuItem(name: "Chilli Paneer (8pcs)", price: 200),
  MenuItem(name: "Bowl Egg Poach", price: 60),
  MenuItem(name: "Egg Cheese Toast", price: 60),
  MenuItem(name: "Chicken Pakora (6pcs)", price: 150),
  MenuItem(name: "Chicken Popcorn", price: 190),
  MenuItem(name: "Chili Chicken (8pcs)", price: 220),
  MenuItem(name: "Honey Chicken (8pcs)", price: 199),
  MenuItem(name: "Chicken 65", price: 250),
  MenuItem(name: "Cheese Sandwich", price: 90),
  MenuItem(name: "Paneer Sandwiche", price: 100),
  MenuItem(name: "Cheese Corn Sandwich", price: 100),
  MenuItem(name: "GraviTea special Sandwich", price: 90),
  MenuItem(name: "Chicken Sandwich", price: 120),
  MenuItem(name: "Boiled Egg Sandwich", price: 90),
  MenuItem(name: "Double Egg Roll", price: 50),
  MenuItem(name: "Paneer Roll", price: 60),
  MenuItem(name: "Chicken Roll", price: 70),
  MenuItem(name: "Egg Chicken Roll", price: 80),
  MenuItem(name: "Friedrice and Chilli Chicken (4pcs)", price: 220),
  MenuItem(name: "Friedrice and Chilli Paneer (4pcs)", price: 200),
  MenuItem(name: "Noodles and Chilli Chicken (4pcs)", price: 180),
  MenuItem(name: "Noodles and Chilli Paneer (4pcs)", price: 170),
  MenuItem(name: "Masala Pasta", price: 70),
  MenuItem(name: "Masala Pasta added Cheese", price: 80),
  MenuItem(name: "White Sauce Pasta", price: 120),
  MenuItem(name: "Paneer Pasta", price: 100),
  MenuItem(name: "Paneer Pasta added Cheese", price: 110),
  MenuItem(name: "Egg Pasta", price: 80),
  MenuItem(name: "Egg Pasta added Cheese", price: 90),
  MenuItem(name: "Chicken Pasta", price: 120),
  MenuItem(name: "Chicken Pasta", price: 130),
  MenuItem(name: "Veg. Momo (Spics)", price: 40),
  MenuItem(name: "Chicken Momo (Spics)", price: 60),
  MenuItem(name: "Fried Momo (8pics) veg", price: 60),
  MenuItem(name: "Fried Momo (8pics) chicken", price: 80),
  MenuItem(name: "Pan Fried Momo veg", price: 80),
  MenuItem(name: "Pan Fried Momo veg", price: 100),
  MenuItem(name: "Pan Fried Momo veg", price: 80),
  MenuItem(name: "GraviTea Coffee", price: 30),
  MenuItem(name: "Cappuccino", price: 80),
  MenuItem(name: "Tandoori Coffee", price: 50),
  MenuItem(name: "Chocolate Coffee", price: 50),
  MenuItem(name: "Black Coffee", price: 20),
  MenuItem(name: "Black Coffee", price: 25),
  MenuItem(name: "Masala Maggi", price: 50),
  MenuItem(name: "Egg Maggi", price: 60),
  MenuItem(name: "Chicken Maggi", price: 80),
  MenuItem(name: "Egg Chicken Maggi", price: 100),
  MenuItem(name: "Friedrice", price: 100),
  MenuItem(name: "Chicken Friedrice", price: 150),
  MenuItem(name: "Egg Chicken friedrice", price: 170),
];


