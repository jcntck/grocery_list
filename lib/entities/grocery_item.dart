class GroceryItem {
  late final String name;
  late double quantity;
  late double price;
  late double subtotal;

  GroceryItem({required this.name})
      : quantity = 0,
        price = 0,
        subtotal = 0;

  GroceryItem.fromJson(dynamic json)
      : name = json['name'],
        quantity = json['quantity'],
        price = json['price'],
        subtotal = json['subtotal'];

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'price': price,
      'subtotal': subtotal
    };
  }

  void calculateSubtotal(double quantity, double price) {
    this.quantity = quantity;
    this.price = price;
    subtotal = quantity * price;
  }

  @override
  String toString() {
    return 'GroceryItem { name: $name, quantity: $quantity, price: $price, subtotal: $subtotal }';
  }
}
