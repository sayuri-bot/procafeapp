import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:procafes/modelos/usuario_model.dart';


class AuthService {

  static const String baseUrl = "https://pro-cafes.com/api";

  // LOGIN
  static Future<UsuarioModel?> login(String email, String password) async {

    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);

      final admin = UsuarioModel.fromJson(data);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", admin.token);
      await prefs.setString("admin_name", admin.name);
      await prefs.setString("admin_email", admin.email);

      return admin;
    }

    return null;
  }

  // LOGOUT
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // OBTENER TOKEN
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  // OBTENER ADMIN GUARDADO
  static Future<UsuarioModel?> getStoredAdmin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final name = prefs.getString("admin_name");
    final email = prefs.getString("admin_email");

    if (token != null && name != null && email != null) {
      return UsuarioModel(
        id: 0, // opcional si no guardas ID
        name: name,
        email: email,
        token: token,
      );
    }

    return null;
  }
}