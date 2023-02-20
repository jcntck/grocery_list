class Item {
  late final String name;
  late final double quantity;
  late final double price;

  Item({required this.name})
      : quantity = 0,
        price = 0;

  Item.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        quantity = json['quantity'],
        price = json['price'];

  Map<String, dynamic> toMap() {
    return {'name': name, 'quantity': quantity, 'price': price};
  }
}
