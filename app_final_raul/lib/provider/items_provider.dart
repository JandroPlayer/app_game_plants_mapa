import 'package:flutter/material.dart';
import 'package:flutter_loggin/serveis/items_service.dart';
import '../models/item.dart';

class ItemsProvider with ChangeNotifier {
  final ItemsService _itemsService = ItemsService();
  List<Item> _items = [];
  bool _isLoading = false;

  List<Item> get items => _items;
  bool get isLoading => _isLoading;

  // Cargar los ítems desde la API
  Future<void> fetchItems() async {
    _isLoading = true;
    notifyListeners();

    try {
      _items = await _itemsService.getItems();
    } catch (error) {
      print("Error al obtener los ítems: $error");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> comprarItem(int usuariId, int itemId, int quantitat) async {
    Item? item;
    for (Item i in _items) {
      if (i.id == itemId) {
        // Create the item with the given id
        item = i;
      }
    }
    try {
      await _itemsService.comprarItem(
          usuariId,
          [
            {
              "itemId": itemId,
              "quantitat": quantitat
            } // Convertimos los valores en una lista de mapas
          ],
          item!.preu *
              quantitat.toDouble() // Asegurar que totalCost sea un double
          );
      print(item!.preu * quantitat.toDouble());

      notifyListeners(); // Notificar cambios si es necesario
    } catch (error) {
      throw Exception("Error en la compra: $error");
    }
  }

  // Actualizar un ítem
  Future<void> updateItem(int id, Item updatedItem) async {
    try {
      await _itemsService.updateItem(id, updatedItem);
      int index = _items.indexWhere((item) => item.id == id);
      if (index != -1) {
        _items[index] = updatedItem;
        notifyListeners();
      }
    } catch (error) {
      print("Error al actualizar el ítem: $error");
    }
  }

  // Eliminar un ítem
  Future<void> removeItem(int id) async {
    try {
      await _itemsService.deleteItem(id);
      _items.removeWhere((item) => item.id == id);
      notifyListeners();
    } catch (error) {
      print("Error al eliminar el ítem: $error");
    }
  }
}
