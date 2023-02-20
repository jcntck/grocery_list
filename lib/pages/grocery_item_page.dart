import 'package:flutter/material.dart';
import 'package:lista_compras/entities/item.dart';

class GroceryItemPage extends StatefulWidget {
  final Item item;
  const GroceryItemPage({Key? key, required this.item }) : super(key: key);

  @override
  State<GroceryItemPage> createState() => _GroceryItemPageState();
}

class _GroceryItemPageState extends State<GroceryItemPage> {
  late Item _item;
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _item = Item.fromJson(widget.item.toMap());
    _quantityController.text = _item.quantity.toString();
    _priceController.text = _item.price.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_item.name),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.save),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: 'Quantidade',
                  labelStyle: TextStyle(fontSize: 18),
                  contentPadding: EdgeInsets.all(18),
                  border: OutlineInputBorder(),
                  suffixText: 'un / g'),
              style: TextStyle(fontSize: 20, color: Colors.blue[700]),
              controller: _quantityController,
            ),
            SizedBox(height: 32),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: 'Valor Unitário',
                  labelStyle: TextStyle(fontSize: 18),
                  contentPadding: EdgeInsets.all(18),
                  border: OutlineInputBorder(),
                  prefixText: 'R\$ '),
              style: TextStyle(fontSize: 20, color: Colors.blue[700]),
              controller: _priceController,
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 16),
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: ',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  SizedBox(width: 4),
                  Text(
                    'R\$ 720.00',
                    style: TextStyle(fontSize: 18, color: Colors.blue[700], fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
