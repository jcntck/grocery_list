import 'package:lista_compras/entities/grocery_item.dart';

abstract class GroceryListRepository {
  Future<GroceryItem> getItem(GroceryItem item);
  Future<List<GroceryItem>> getItems();
  Future<void> save(List<GroceryItem> groceryItems);
}