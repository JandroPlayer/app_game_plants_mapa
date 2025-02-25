import 'package:flutter/material.dart';
import 'package:flutter_loggin/models/usuari.dart';
import 'package:flutter_loggin/serveis/apiService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsuarisProvider extends ChangeNotifier {
  // Lista de usuarios
  List<Usuari> usuaris = [];
  final ApiService apiService = ApiService();

  // Getter para acceder a la lista de usuarios
  List<Usuari> get getUsuaris => usuaris;

  // Método para obtener el token almacenado
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('firebase_token'); // Recuperar el token guardado
  }

  // Cargar usuarios desde la API
  Future<void> fetchUsuaris() async {
    try {
      String? token = await _getToken();
      if (token == null) {
        throw Exception('No hay token disponible.');
      }

      final usuariosData = await apiService.fetchUsuarios(token);

      // Mapear los datos de la API al modelo Usuari
      usuaris =
          usuariosData.map((usuario) => Usuari.fromJson(usuario)).toList();
      notifyListeners();
    } catch (e) {
      throw Exception('Error al cargar usuarios: $e');
    }
  }

  Future<void> addUsuari(Usuari usuari) async {
    try {
      final nuevoUsuario = {
        'nom': usuari.nom,
        'correu': usuari.correu,
        'contrasenya': usuari.contrasenya,
        'edat': usuari.edat,
        'nacionalitat': usuari.nacionalitat,
        'codiPostal': usuari.codiPostal,
        'imatgePerfil': usuari.imatgePerfil,
      };

      await apiService.createUsuario(nuevoUsuario);
      await fetchUsuaris();
    } catch (e) {
      print('Error al añadir un usuario: $e');
      throw Exception('Error al añadir un usuario: $e');
    }
  }

  // Eliminar un usuario por ID utilizando la API
  Future<void> removeUsuari(int id) async {
    try {
      String? token = await _getToken();
      if (token == null) {
        throw Exception('No hay token disponible.');
      }

      await apiService.deleteUsuario(id, token);
      await fetchUsuaris();
    } catch (e) {
      throw Exception('Error al eliminar el usuario: $e');
    }
  }

  // Actualizar un usuario utilizando la API
  Future<void> updateUsuari(int id, Usuari usuariActualitzat) async {
    try {
      String? token = await _getToken();
      if (token == null) {
        throw Exception('No hay token disponible.');
      }

      final usuarioActualizado = {
        'nom': usuariActualitzat.nom,
        'correu': usuariActualitzat.correu,
        'contrasenya': usuariActualitzat.contrasenya,
        'edat': usuariActualitzat.edat,
        'nacionalitat': usuariActualitzat.nacionalitat,
        'codiPostal': usuariActualitzat.codiPostal,
        'imatgePerfil': usuariActualitzat.imatgePerfil,
      };

      await apiService.updateUsuario(id, usuarioActualizado, token);
      await fetchUsuaris();
    } catch (e) {
      throw Exception('Error al actualizar usuario: $e');
    }
  }

  Usuari? _usuariActual;

  Usuari? get usuariActual => _usuariActual;

  Future<Usuari?> buscarUsuari(String correu, String contrasenya) async {
    try {
      // Este es el lugar donde buscas al usuario, como lo tenías antes.
      await fetchUsuaris();

      final usuarioEncontrado = usuaris.firstWhere(
        (u) => u.correu == correu && u.contrasenya == contrasenya,
        orElse: () => null as Usuari,
      );

      return usuarioEncontrado;
    } catch (e) {
      print('No se encontró ningún usuario con el correo $correu.');
      return null;
    }
  }

  // Buscar usuario por correo
  Future<Usuari?> buscarUsuariPerCorreu(String correu) async {
    try {
      await fetchUsuaris();

      final usuarioEncontrado = usuaris.firstWhere(
        (u) => u.correu == correu,
        orElse: () => null as Usuari,
      );

      return usuarioEncontrado;
    } catch (e) {
      print('Error al buscar usuario por correo: $e');
      return null;
    }
  }

  // Actualizar saldo BTC del usuario
  Future<void> actualizarBtc(int userId, double amount) async {
    try {
      String? token = await _getToken();
      if (token == null) {
        throw Exception('No hay token disponible.');
      }

      await apiService.updateBtc(userId, amount, token);
      notifyListeners();
      await fetchUsuaris();
    } catch (e) {
      print("Error en actualizarBtc: $e");
      throw Exception('Error al actualizar BTC: $e');
    }
  }

  // Guardar el token en SharedPreferences
  Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('firebase_token', token);
    print('Token guardado: $token');
  }

  // Obtener el token desde SharedPreferences
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('firebase_token');
  }

// Login: autenticar usuario y obtener token
  Future<String?> login(String correu, String contrasenya) async {
    // Validación básica de los parámetros
    if (correu.isEmpty || contrasenya.isEmpty) {
      print('Correo o contraseña no pueden estar vacíos');
      return null;
    }

    try {
      // Hacer la llamada al servicio para obtener la respuesta
      final response = await apiService.login(correu, contrasenya);

      // Verificar si la respuesta fue exitosa
      if (response['success'] == true) {
        String token =
            response['token'] ?? ''; // Asegúrate de que exista el campo 'token'

        if (token.isNotEmpty) {
          await saveToken(token); // Guardamos el token en SharedPreferences
          return token; // Retornamos el token al llamante
        } else {
          print('No se recibió un token en la respuesta.');
          return null;
        }
      } else {
        // Si la respuesta no fue exitosa, mostramos el mensaje de error
        print('Error en el login: ${response['message']}');
        return null; // Si el login falla, retornamos null
      }
    } catch (e) {
      // Capturar cualquier error de conexión o de la petición
      print('Error en la conexión o en el servidor: $e');
      return null; // En caso de error, retornamos null
    }
  }
}
