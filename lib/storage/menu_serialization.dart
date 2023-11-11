
import 'dart:convert';
import 'package:gravitea_pos/models/menu.model.dart'; // Make sure to import your MenuItem class


extension MenuListSerialization on List<MenuItem> {
  String toJson() {
    return json.encode(this.map((item) => item.toJson()).toList());
  }
}


extension MenuItemDeserialization on MenuItem {
  static MenuItem fromJson(String jsonString) {
    final Map<String, dynamic> data = json.decode(jsonString);
    return MenuItem(
      name: data['name'],
      price: data['price'],
    );
  }
}
