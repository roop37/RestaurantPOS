class OrderItem {
  final String menuItem;
  final int quantity;

  OrderItem({required this.menuItem, required this.quantity});

  Map<String, dynamic> toJson() {
    return {
      'menuItem': menuItem,
      'quantity': quantity,
    };
  }

  static OrderItem fromJson(Map<String, dynamic> json) {
    return OrderItem(
      menuItem: json['menuItem'],
      quantity: json['quantity'],
    );
  }
}
