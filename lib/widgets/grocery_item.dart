import 'package:flutter/material.dart';
import 'package:lista_compras/entities/grocery_item.dart';
import 'package:lista_compras/pages/grocery_item_page.dart';

class GroceryItemWidget extends StatelessWidget {
  final GroceryItem groceryItem;
  final int indexItem;
  final Function(int index, GroceryItem groceryItem) updateItem;
  final Function(GroceryItem groceryItem) removeItem;

  GroceryItemWidget({Key? key, required this.groceryItem, required this.indexItem, required this.updateItem, required this.removeItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Dismissible(
        key: Key(DateTime.now().microsecondsSinceEpoch.toString()),
        background: Card(
          color: Colors.red,
          child: Align(
            alignment: Alignment(-0.9, 0),
            child: Icon(Icons.delete, color: Colors.white),
          ),
        ),
        direction: DismissDirection.startToEnd,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        groceryItem.name,
                        style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                      ),
                    ),
                    Text(
                      '${groceryItem.quantity}x',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'R\$ ${groceryItem.price}',
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
                    'R\$ ${groceryItem.subtotal.toStringAsFixed(2)}',
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
        onDismissed: (direction) {
            removeItem(groceryItem);
        },
      ),
      onTap: () async {
        final GroceryItem updatedItem = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GroceryItemPage(groceryItem: groceryItem)),
        );
        updateItem(indexItem, updatedItem);
      },
    );
  }
}
