import 'package:lista_compras/drivers/json_driver.dart';
import 'package:lista_compras/entities/grocery_item.dart';
import 'package:lista_compras/repositories/grocery_list_repository.dart';

class GroceryListJsonRepository implements GroceryListRepository {
  final String collectionName = 'grocery_list';

  @override
  Future<List<GroceryItem>> getItems() async {
    List<dynamic>? results =
        await JsonDriver.readData(collectionName);
    if (results == null) return [];
    return results
        .map((result) => GroceryItem.fromJson(result))
        .toList();
  }

  @override
  Future<void> save(List<GroceryItem> groceryItems) async {
    final data = groceryItems.map((item) => item.toMap()).toList();
    final result = await JsonDriver.saveData(collectionName, data);
    print(result);

  }

  @override
  Future<GroceryItem> getItem(GroceryItem item) {
    // TODO: implement getItem
    throw UnimplementedError();
  }
}
