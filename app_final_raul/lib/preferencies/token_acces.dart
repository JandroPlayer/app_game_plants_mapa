import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  // Guardar el Token
  static Future<void> saveToken(String? token) async {
    if (token == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('firebase_token', token);
  }

  // Obtener el Token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    // imprimir el token
    print(prefs.getString('firebase_token'));
    return prefs.getString('firebase_token');
  }

  // Eliminar el Token (para cerrar sesión)
  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('firebase_token');
  }
}
