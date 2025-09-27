import 'package:shared_preferences/shared_preferences.dart';

class TokenServices {
  static const String _key = '123456789';

  /// Guarda el token en el almacenamiento local
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, token);
  }

  /// Obtiene el token almacenado (retorna `null` si no existe)
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }

  /// (Opcional) Elimina el token
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
