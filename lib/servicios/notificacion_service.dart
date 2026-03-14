import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

/// Handler de notificaciones en segundo plano
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Notificación en segundo plano: ${message.messageId}");
}

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// Inicialización general (sin usuario)
  static Future<void> initGeneral() async {
    // Pedir permisos
    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    // Handler background
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Configuración Android
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    await _localNotifications.initialize(initSettings);

    // Listeners foreground y cuando el usuario toca la notificación
    FirebaseMessaging.onMessage.listen(_handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("Notificación tocada: ${message.messageId}");
    });
  }

  /// Inicialización completa para un usuario (registra token en API)
  static Future<void> initForUser(String userId) async {
    await initGeneral(); // inicialización general

    String? token = await _messaging.getToken();
    if (token != null) {
      await _registerTokenToApi(userId, token);
    }
  }

  /// Manejo de notificación entrante
  static void _handleMessage(RemoteMessage message) {
    if (message.notification != null) {
      showNotification(
        title: message.notification!.title ?? "Alerta",
        body: message.notification!.body ?? "",
      );
    }
  }

  /// Mostrar notificación local
  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'alertas_stock',
      'Alertas Inventario',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );
    const details = NotificationDetails(android: androidDetails);
    int notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await _localNotifications.show(notificationId, title, body, details);
  }

  /// Registrar token FCM en tu API Laravel
  static Future<void> _registerTokenToApi(String userId, String token) async {
    if (token.isEmpty) {
      return;
    }
    final url = Uri.parse('https://pro-cafes.com/api/device/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId, 
        'device_token': token
        }),
    );

    if (response.statusCode == 200) {
      print('Token registrado en API correctamente');
    } else {
      print('Error al registrar token: ${response.body}');
    }
  }

  /// Notificación de prueba
  static Future<void> testNotification() async {
    await showNotification(
      title: "⚠️ Alerta de Stock",
      body: "Producto con stock bajo detectado",
    );
  }
}