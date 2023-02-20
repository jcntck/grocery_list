import 'package:flutter/material.dart';
import 'package:lista_compras/entities/grocery_item.dart';

class GroceryItemPage extends StatefulWidget {
  final GroceryItem groceryItem;
  const GroceryItemPage({Key? key, required this.groceryItem }) : super(key: key);

  @override
  State<GroceryItemPage> createState() => _GroceryItemPageState();
}

class _GroceryItemPageState extends State<GroceryItemPage> {
  late GroceryItem _groceryItem;
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _groceryItem = GroceryItem.fromJson(widget.groceryItem.toMap());
    _quantityController.text = _groceryItem.quantity.toString();
    _priceController.text = _groceryItem.price.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_groceryItem.name),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _quantitySetValue(_quantityController.text);
          _priceSetValue(_priceController.text);
          Navigator.pop(context, _groceryItem);
        },
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
              onTap: () {
                _quantityController.text = '';
              },
              onFieldSubmitted: _quantitySetValue,
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
              onTap: () {
                _priceController.text = '';
              },
              onFieldSubmitted: _priceSetValue,
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 16),
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Subtotal: ',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  SizedBox(width: 4),
                  Text(
                    'R\$ ${_groceryItem.subtotal.toStringAsFixed(2)}',
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

  _quantitySetValue(value) {
    if (value.isEmpty) {
      _quantityController.text = _groceryItem.quantity.toString();
    } else {
      _quantityController.text = value;
    }
    _calculateSubtotal();
  }

  _priceSetValue(value) {
    if (value.isEmpty) {
      _priceController.text = _groceryItem.price.toString();
    } else {
      _priceController.text = value;
    }
    _calculateSubtotal();
  }

  _calculateSubtotal() {
    final double quantity = double.parse(_quantityController.text);
    final double price = double.parse(_priceController.text);

    setState(() {
      _groceryItem.calculateSubtotal(quantity, price);
    });
  }
}
