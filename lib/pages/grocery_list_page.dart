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
  List<GroceryItem> _filteredGroceryList = [];
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
          title: const Text(
            "Lista de Compras",
          ),
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(
                      'Limpar lista?',
                      style: TextStyle(color: Colors.red),
                    ),
                    content: Text(
                        'Esta ação irá limpar a lista, removendo todos os itens cadastrados, tem certeza que deseja fazer isso?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Cancelar',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          _groceryList = [];
                          await _saveGroceryList();
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Sim',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
              icon: Icon(
                Icons.refresh,
                color: Colors.green,
              ),
            )
          ],
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
                      decoration: InputDecoration(
                        labelText: 'Adicione um produto',
                        labelStyle: TextStyle(
                          color: Colors.grey[700],
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                      ),
                      cursorColor: Colors.green,
                      textCapitalization: TextCapitalization.sentences,
                      controller: _productNameController,
                      onChanged: _filterGroceryItems,
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
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(20, 50), backgroundColor: Colors.green),
                  )
                ],
              ),
              const SizedBox(height: 16),
              Flexible(
                fit: FlexFit.tight,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _filteredGroceryList.length,
                  itemBuilder: (context, index) => GroceryItemWidget(
                      groceryItem: _filteredGroceryList[index],
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
                          color: Colors.green[700],
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

  void _filterGroceryItems(String value) {
    setState(() {
      _filteredGroceryList = _groceryList.where((GroceryItem item) {
        String search = value.toLowerCase();
        RegExpMatch? match = RegExp('$search', caseSensitive: false)
            .firstMatch(item.name.toLowerCase());
        return match != null;
      }).toList();
    });
  }

  void _addGroceryItem() async {
    final groceryItemName = _productNameController.text;

    if (groceryItemName.isNotEmpty) {
      if (!_groceryItemAlreadyExists()) {
        _groceryList.add(GroceryItem(name: groceryItemName));
        await _saveGroceryList();
        _productNameController.clear();
      }
      FocusScope.of(context).requestFocus(_productNameFocusNode);
    } else {
      _productNameFocusNode.unfocus();
    }
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
        _filteredGroceryList = _groceryList;
        _filteredGroceryList.sort(
          (GroceryItem a, GroceryItem b) =>
              a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
        _total = _calculateTotal();
      });
    });
  }

  bool _groceryItemAlreadyExists() {
    if (_filteredGroceryList.length > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Este produto já consta na lista.'),
          duration: const Duration(seconds: 2),
        ),
      );
      return true;
    }
    return false;
  }

  double _calculateTotal() {
    if (_groceryList.isEmpty) return 0;

    return _groceryList
        .map((groceryItem) => groceryItem.subtotal)
        .reduce((total, subtotal) => total + subtotal);
  }
}
