import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'rutas/rutas.dart';
import 'package:procafes/config/tema.dart';
import 'servicios/notificacion_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// Inicializar servicio de notificaciones
  await NotificationService.initGeneral();

  runApp(const ProcafeApp());
}

class ProcafeApp extends StatelessWidget {
  const ProcafeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Procafes',
      theme: temaEjecutivo,
      routerConfig: AppRutas.router,
    );
  }
}