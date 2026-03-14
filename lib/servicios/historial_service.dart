import 'dart:convert';
import 'package:http/http.dart' as http;
import '../modelos/historial_model.dart';

class HistorialService {
  static const String baseUrl = "https://pro-cafes.com/api";
  final String token;
  
  HistorialService({required this.token});
  Map<String, String> get headers => {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };
  
  /// Obtiene el historial de alertas
  Future<List<HistorialModel>> getHistorial() async {
    final url = Uri.parse("$baseUrl/alertas/historial");
    final response = await http.get(url, headers: headers);

    print("STATUS HISTORIAL: ${response.statusCode}");
    print("BODY HISTORIAL: ${response.body}");

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => HistorialModel.fromJson(e)).toList();
    } else if (response.statusCode == 401) {
      throw Exception("Sesion expirada. Por favor, inicia sesión nuevamente.");
    } else {
      throw Exception(
        "Error al cargar historial: ${response.statusCode}");
    }
  }
 
}