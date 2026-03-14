import 'dart:convert';
import 'package:http/http.dart' as http;
import '../modelos/producto_model.dart';

class ProductService {

  static const String baseUrl = "https://pro-cafes.com/api";

  final String token;

  ProductService({required this.token});

  Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };

  /// ALERTAS (agotados o stock bajo)
  Future<List<ProductoModel>> getAlertasActuales() async {
    try {

      final url = Uri.parse("$baseUrl/products/alertas");

      final response = await http.get(url, headers: headers);

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      if (response.statusCode == 200) {

        final decoded = jsonDecode(response.body);

        if (decoded is List) {
          return decoded
              .map((e) => ProductoModel.fromJson(e))
              .toList();
        } else {
          throw Exception("La respuesta no es una lista válida");
        }

      } else if (response.statusCode == 401) {

        throw Exception("Token inválido o sesión expirada");

      } else {

        throw Exception(
            "Error API ${response.statusCode}: ${response.body}");

      }

    } catch (e) {

      throw Exception("Error cargando productos: $e");

    }
  }

  /// TODOS LOS PRODUCTOS (para dashboard)
  Future<List<ProductoModel>> getProductos() async {
    try {

      final url = Uri.parse("$baseUrl/products");

      final response = await http.get(url, headers: headers);

      print("STATUS PRODUCTS: ${response.statusCode}");
      print("BODY PRODUCTS: ${response.body}");

      if (response.statusCode == 200) {

        final decoded = jsonDecode(response.body);

        if (decoded is List) {
          return decoded
              .map((e) => ProductoModel.fromJson(e))
              .toList();
        } else {
          throw Exception("La respuesta no es una lista válida");
        }

      } else {

        throw Exception(
            "Error API ${response.statusCode}: ${response.body}");

      }

    } catch (e) {

      throw Exception("Error cargando productos: $e");

    }
  }

  /// Actualizar stock
  Future<void> actualizarStock(
      int id,
      int stock,
      {int stockMinimo = 0}) async {

    try {

      final url = Uri.parse("$baseUrl/products/update-stock");

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode({
          'id': id,
          'stock': stock,
          'stock_minimo': stockMinimo,
        }),
      );

      print("STATUS UPDATE: ${response.statusCode}");
      print("BODY UPDATE: ${response.body}");

      if (response.statusCode != 200) {
        throw Exception(
            "Error al actualizar stock: ${response.body}");
      }

    } catch (e) {

      throw Exception("Error conexión API: $e");

    }
  }
}