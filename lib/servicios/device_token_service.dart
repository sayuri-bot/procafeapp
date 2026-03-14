// device_token_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> registerDeviceToken(String userId, String deviceToken) async {
  final url = Uri.parse('https://pro-cafes.com/api/device/register');

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'user_id': userId,
      'device_token': deviceToken,
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data['success']) {
      print('Token registrado correctamente: ${data['data']}');
    } else {
      print('Error al registrar token: ${data['message']}');
    }
  } else {
    print('Error de conexión: ${response.statusCode}');
  }
}