import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/planta.dart';

class PlantaService {
  final String _baseUrl = 'http://10.0.2.2:3000';

  // Obtener todas las plantas
  Future<List<Planta>> fetchPlantas() async {
    try {
      // Asegúrate de que la URL apunte a /plantas
      final response = await http.get(Uri.parse('$_baseUrl/plantas'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((planta) => Planta.fromJson(planta)).toList();
      } else {
        throw Exception('Error al cargar las plantas');
      }
    } catch (error) {
      print('Error: $error');
      rethrow;
    }
  }

  // Añadir una nueva planta
  Future<Planta> addPlanta(Planta planta) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/plantas'),
        body: json.encode(planta.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 201) {
        return Planta.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al añadir la planta');
      }
    } catch (error) {
      print('Error: $error');
      rethrow;
    }
  }

  // Actualizar una planta existente
  Future<void> updatePlanta(Planta planta) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/plantas/${planta.id}'),
        body: json.encode(planta.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode != 200) {
        throw Exception('Error al actualizar la planta');
      }
    } catch (error) {
      print('Error: $error');
      rethrow;
    }
  }

  // Eliminar una planta
  Future<void> deletePlanta(int id) async {
    try {
      final response = await http.delete(Uri.parse('$_baseUrl/plantas/$id'));
      if (response.statusCode != 200) {
        throw Exception('Error al eliminar la planta');
      }
    } catch (error) {
      print('Error: $error');
      rethrow;
    }
  }
}
