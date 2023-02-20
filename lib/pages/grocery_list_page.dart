import 'package:flutter/material.dart';
import 'package:lista_compras/entities/grocery_item.dart';
import 'package:lista_compras/repositories/grocery_list_json_repository.dart';
import 'package:lista_compras/repositories/grocery_list_repository.dart';
import 'package:lista_compras/widgets/grocery_item.dart';

class GroceryListPage extends StatefulWidget {
  const GroceryListPage({Key? key}) : super(key: key);

  @override
  State<GroceryListPage> createState() => _GroceryListPageState();
}

class _GroceryListPageState extends State<GroceryListPage> {
  List<GroceryItem> _groceryList = [];
  double _total = 0;
  late final GroceryListRepository _groceryListRepository;
  final TextEditingController _productNameController = TextEditingController();
  final FocusNode _productNameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _groceryListRepository = GroceryListJsonRepository();
    _loadGroceryList();
  }

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
                      onSubmitted: (value) => _addGroceryItem(),
                      focusNode: _productNameFocusNode,
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  ElevatedButton(
                    onPressed: () => _addGroceryItem(),
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
                  itemBuilder: (context, index) => GroceryItemWidget(
                      groceryItem: _groceryList[index],
                      indexItem: index,
                      updateItem: _updateGroceryItem,
                      removeItem: _removeGroceryItem),
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
                      'R\$ ${_total.toStringAsFixed(2)}',
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w600),
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

  void _addGroceryItem() async {
    final groceryItemName = _productNameController.text;
    if (groceryItemName.isNotEmpty) {
      _groceryList.add(GroceryItem(name: groceryItemName));
      await _saveGroceryList();
    }
    _productNameController.clear();
    _productNameFocusNode.unfocus();
  }

  void _updateGroceryItem(int index, GroceryItem groceryItem) async {
    _groceryList.removeAt(index);
    _groceryList.insert(index, groceryItem);
    await _saveGroceryList();
  }

  void _removeGroceryItem(GroceryItem groceryItem) async {
    _groceryList.remove(groceryItem);
    await _saveGroceryList();
  }

  _saveGroceryList() async {
    await _groceryListRepository.save(_groceryList);
    setState(() {
      _loadGroceryList();
    });
  }

  void _loadGroceryList() {
    _groceryListRepository.getItems().then((groceryItems) {
      setState(() {
        _groceryList = groceryItems;
        _total = _calculateTotal();
      });
    });
  }

  double _calculateTotal() {
    return _groceryList
        .map((groceryItem) => groceryItem.subtotal)
        .reduce((total, subtotal) => total + subtotal);
  }
}
