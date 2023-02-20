import 'package:flutter/material.dart';
import 'package:lista_compras/entities/item.dart';
import 'package:lista_compras/pages/grocery_item_page.dart';

class GroceryItem extends StatelessWidget {
  final Item item;

  GroceryItem({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.name,
                      style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                    ),
                  ),
                  Text(
                    '${item.quantity}x',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'R\$ ${item.price}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[800],
                    ),
                  )
                ],
              ),
              const Divider(),
              Row(children: [
                Expanded(
                  child: Text(
                    'Subtotal',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.blue[700],
                    ),
                  ),
                ),
                Text(
                  'R\$ 60.90',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.blue[700],
                  ),
                )
              ])
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GroceryItemPage(item: item)),
        );
      },
    );
  }
}
