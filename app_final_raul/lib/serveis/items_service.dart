import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/item.dart';

class ItemsService {
  final String baseUrl = 'http://10.0.2.2:3000'; // Cambia esto según tu API

  // Obtener todos los ítems
  Future<List<Item>> getItems() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/items'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => Item.fromMap(item)).toList();
      } else {
        print('Error: Codi de resposta ${response.statusCode}');
        throw Exception('Error al carregar els ítems: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al obtenir els ítems: $e');
      throw Exception('Error al obtenir els ítems: $e');
    }
  }

  // Obtener un ítem por ID
  Future<Item> getItemById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/items/$id'));

    if (response.statusCode == 200) {
      return Item.fromJson(response.body);
    } else {
      throw Exception('Error al cargar el ítem');
    }
  }

  // Crear un nuevo ítem
  Future<Item> createItem(Item item) async {
    final response = await http.post(
      Uri.parse('$baseUrl/items'),
      headers: {"Content-Type": "application/json"},
      body: item.toJson(),
    );

    if (response.statusCode == 201) {
      return Item.fromJson(response.body);
    } else {
      throw Exception('Error al crear el ítem');
    }
  }

  // Actualizar un ítem
  Future<void> updateItem(int id, Item item) async {
    final response = await http.put(
      Uri.parse('$baseUrl/items/$id'),
      headers: {"Content-Type": "application/json"},
      body: item.toJson(),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar el ítem');
    }
  }

  // Eliminar un ítem
  Future<void> deleteItem(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/items/$id'));

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar el ítem');
    }
  }

  Future<void> comprarItem(
      int usuariId, List<Map<String, dynamic>> items, double totalCost) async {
    final url = Uri.parse(
        '$baseUrl/items_usuaris'); // Asegúrate de que este endpoint sea correcto

    print(totalCost); // Use the variable 'b'

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
          {"userId": usuariId, "items": items, "totalCost": totalCost}),
    );

    if (response.statusCode != 200) {
      throw Exception("Error en la compra: ${response.body}");
    }
  }
}
