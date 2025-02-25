import 'dart:convert';
import 'package:flutter_loggin/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = 'http://10.0.2.2:3000';

  //////////////////////////////////
  // Métodos para gestionar usuarios

  Future<List<dynamic>> fetchUsuarios(String token) async {
    final resposta = await http.get(Uri.parse('$baseUrl/usuaris'));
    if (resposta.statusCode == 200) {
      return jsonDecode(resposta.body);
    } else {
      throw Exception('Error al obtener usuarios');
    }
  }

  Future<void> createUsuario(Map<dynamic, dynamic> usuari) async {
    final resposta = await http.post(
      Uri.parse('$baseUrl/usuaris'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(usuari),
    );

    if (resposta.statusCode == 201) {
      final data = jsonDecode(resposta.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          'firebase_token', data['token']); // ✅ Guardar el token devuelto
      print('✅ Token guardado: ${data['token']}');
    } else {
      print('❌ Error al crear usuario: ${resposta.body}');
      throw Exception('Error al crear el usuario');
    }
  }

  Future<void> deleteUsuario(int id, String token) async {
    final resposta = await http.delete(Uri.parse('$baseUrl/usuaris/$id'));
    if (resposta.statusCode != 200) {
      throw Exception('Error al eliminar el usuario');
    }
  }

  Future<void> updateUsuario(
      int id, Map<String, dynamic> usuari, String token) async {
    final resposta = await http.put(
      Uri.parse('$baseUrl/usuaris/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(usuari),
    );

    if (resposta.statusCode != 200) {
      print('Error al actualizar usuario: ${resposta.statusCode}');
      print('Respuesta del servidor: ${resposta.body}');
      throw Exception('Error al actualizar el usuario');
    }
  }

  // Métodos para gestionar plantas

  // Obtener todas las plantas
  Future<List<dynamic>> fetchPlantas() async {
    final resposta = await http.get(Uri.parse('$baseUrl/plantas'));
    if (resposta.statusCode == 200) {
      return jsonDecode(resposta.body);
    } else {
      throw Exception('Error al obtener plantas');
    }
  }

  // Obtener plantas de un usuario específico
  Future<List<dynamic>> fetchPlantasByUsuario(int usuarioId) async {
    final resposta =
        await http.get(Uri.parse('$baseUrl/usuaris/$usuarioId/plantas'));
    if (resposta.statusCode == 200) {
      return jsonDecode(resposta.body);
    } else {
      throw Exception('Error al obtener plantas del usuario');
    }
  }

  // Crear una nueva planta
  Future<void> createPlanta(Map<String, dynamic> planta) async {
    final resposta = await http.post(
      Uri.parse('$baseUrl/plantas'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(planta),
    );
    if (resposta.statusCode != 201) {
      throw Exception('Error al crear la planta');
    }
  }

  // Eliminar una planta
  Future<void> deletePlanta(int id) async {
    final resposta = await http.delete(Uri.parse('$baseUrl/plantas/$id'));
    if (resposta.statusCode != 200) {
      throw Exception('Error al eliminar la planta');
    }
  }

  // Actualizar una planta
  Future<void> updatePlanta(int id, Map<String, dynamic> planta) async {
    final resposta = await http.put(
      Uri.parse('$baseUrl/plantas/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(planta),
    );
    if (resposta.statusCode != 200) {
      throw Exception('Error al actualizar la planta');
    }
  }

  // Actualizar el saldo de BTC para un usuario
  Future<void> updateBtc(int userId, double amount, String token) async {
    try {
      final response = await http.put(
        Uri.parse(
            '$baseUrl/usuaris/btc/$userId'), // URL con el userId en la ruta
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "amount": amount, // Solo enviamos el amount en el cuerpo
        }),
      );

      if (response.statusCode == 200) {
        print('Saldo de BTC actualizado correctamente.');
      } else {
        print('Error al actualizar el saldo de BTC: ${response.body}');
      }
    } catch (e) {
      print('Error en la solicitud HTTP: $e');
    }
  }

  Future<String?> getToken(String correu, String contrasenya) async {
    final url = Uri.parse(
        '$baseUrl/api/login'); // Asegúrate de usar la URL correcta de tu backend.

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': correu,
          'password': contrasenya,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Suponemos que el token está en 'data['token']'
        return data['token']; // Retorna el token obtenido.
      } else {
        print('Error al obtener el token: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error al conectar con el servidor: $e');
      return null;
    }
  }

  // Método para hacer login y obtener el token
  Future<Map<String, dynamic>> login(String correu, String contrasenya) async {
    // Validación de los parámetros antes de hacer la solicitud
    if (correu.isEmpty || contrasenya.isEmpty) {
      return {
        'success': false,
        'message': 'El correo y la contraseña son requeridos.',
      };
    }

    final url = Uri.parse(
        '$baseUrl/api/login'); // URL de la ruta de login en el backend
    try {
      // Realizamos la petición POST al backend
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': correu, 'password': contrasenya}),
      );

      // Verificamos el código de respuesta
      if (response.statusCode == 200) {
        // Si la respuesta es exitosa, procesamos el JSON
        final data = jsonDecode(response.body);
        print('Login exitoso: ${data['message']}');
        return {
          'success': true,
          'token': data['token'], // Asumimos que la respuesta incluye el token
        };
      } else {
        // Si la respuesta no es exitosa, manejamos el error
        final data = jsonDecode(response.body);
        print('Error en el login: ${data['error']}');
        return {
          'success': false,
          'message': data['error'] ?? 'Error desconocido en el servidor',
        };
      }
    } catch (e) {
      // Manejo de errores de conexión o de la petición HTTP
      print('Error en la conexión: $e');
      return {
        'success': false,
        'message': 'Error de conexión. Por favor, intente más tarde.',
      };
    }
  }
}
