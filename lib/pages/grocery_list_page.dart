import 'package:flutter/material.dart';
import 'package:lista_compras/entities/item.dart';
import 'package:lista_compras/widgets/grocery_item.dart';

class GroceryListPage extends StatefulWidget {
  const GroceryListPage({Key? key}) : super(key: key);

  @override
  State<GroceryListPage> createState() => _GroceryListPageState();
}

class _GroceryListPageState extends State<GroceryListPage> {
  List<Item> _groceryList = [];
  final TextEditingController _productNameController = TextEditingController();
  final FocusNode _productNameFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Lista de Compras"),
        ),
        body: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Adicione um produto',
                      ),
                      controller: _productNameController,
                      onSubmitted: (value) => _addItemToList(),
                      focusNode: _productNameFocusNode,
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  ElevatedButton(
                    onPressed: () => _addItemToList(),
                    child: const Icon(Icons.add),
                    style: ElevatedButton.styleFrom(fixedSize: Size(20, 50)),
                  )
                ],
              ),
              const SizedBox(height: 16),
              Flexible(
                fit: FlexFit.tight,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _groceryList.length,
                  itemBuilder: (context, index) => GroceryItem(item: _groceryList[index]),
                ),
              ),
              const Divider(),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Total: ',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'R\$ 720.00',
                      style: TextStyle(fontSize: 22, color: Colors.blue[700], fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _addItemToList() {
    final itemName = _productNameController.text;
    if (itemName.isNotEmpty) {
      setState(() {
        _groceryList
            .add(Item(name: itemName));
      });
    }
    _productNameController.clear();
    _productNameFocusNode.unfocus();
  }
}
