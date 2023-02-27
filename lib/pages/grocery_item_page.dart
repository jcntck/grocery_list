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
  final FocusNode _quantityFocusNode = FocusNode();
  final FocusNode _priceFocusNode = FocusNode();


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
        iconTheme: IconThemeData(
          color: Colors.black
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _quantitySetValue(_quantityController.text);
          _priceSetValue(_priceController.text);
          Navigator.pop(context, _groceryItem);
        },
        child: Icon(Icons.save),
        backgroundColor: Colors.green,
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
                  labelStyle: TextStyle(fontSize: 18, color: Colors.green),
                  contentPadding: EdgeInsets.all(18),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.green
                    ),
                  ),
                  suffixText: 'un / g'),
              style: TextStyle(fontSize: 20, color: Colors.grey[700]),
              cursorColor: Colors.green,
              controller: _quantityController,
              onTap: () {
                _quantityController.text = '';
              },
              onChanged: _quantitySetValue,
              onFieldSubmitted: _quantitySetValue,
              focusNode: _quantityFocusNode,
            ),
            SizedBox(height: 32),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: 'Valor Unitário',
                  labelStyle: TextStyle(fontSize: 18, color: Colors.green),
                  contentPadding: EdgeInsets.all(18),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.green
                    ),
                  ),
                  prefixText: 'R\$ '),
              style: TextStyle(fontSize: 20, color: Colors.grey[700]),
              cursorColor: Colors.green,
              controller: _priceController,
              onTap: () {
                _priceController.text = '';
              },
              onChanged: _priceSetValue,
              onFieldSubmitted: _priceSetValue,
              focusNode: _priceFocusNode,
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
                    style: TextStyle(fontSize: 18, color: Colors.green[700], fontWeight: FontWeight.w600),
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
      _quantityController.text =  !_quantityFocusNode.hasFocus ? _groceryItem.price.toString() : '';
    } else {
      _quantityController.text = value;
    }
    _calculateSubtotal();
  }

  _priceSetValue(value) {
    if (value.isEmpty) {
      _priceController.text = !_priceFocusNode.hasFocus ? _groceryItem.price.toString() : '';
    } else {
      _priceController.text =  value;
    }
    _calculateSubtotal();
  }

  _calculateSubtotal() {
    final double quantity = double.tryParse(_quantityController.text) ?? 0;
    final double price = double.tryParse(_priceController.text) ?? 0;

    setState(() {
      _groceryItem.calculateSubtotal(quantity, price);
      _quantityController.selection = TextSelection.collapsed(offset: _quantityController.text.length);
      _priceController.selection = TextSelection.collapsed(offset: _priceController.text.length);
    });
  }
}
