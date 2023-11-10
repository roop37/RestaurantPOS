// menu.model.dart

class MenuItem {
  String name;
  double price;

  MenuItem({required this.name, required this.price});

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      name: json['name'] ?? '', // Use an empty string if 'name' is null
      price: json['price'] ?? 0.0, // Use 0.0 if 'price' is null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
    };
  }
}
