import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:procafes/modelos/producto_model.dart';
import '../pantallas/splash/splash_screen.dart';
import '../pantallas/auth/login_screen.dart';
import '../pantallas/home/principal_screen.dart';
import '../pantallas/home/panel_screen.dart';
import '../pantallas/home/alerts_screen.dart';
import '../pantallas/home/history_screen.dart';
import '../pantallas/home/settings_screen.dart';
import '../pantallas/shared/detalle_producto.dart';
import '../pantallas/auth/cambiar_clave_screen.dart';
import '../pantallas/home/perfil_screen.dart';

class AppRutas {
  /// Token que se pasa a las pantallas que lo requieren
  static String? token;

  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [

      /// Splash
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),

      /// Login
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),

      /// Layout principal con navegación
      ShellRoute(
        builder: (context, state, child) {
          return PrincipalScreen(child: child);
        },
        routes: [

          /// Panel
          GoRoute(
            path: '/panel',
            builder: (context, state) {
              return PanelScreen(token: AppRutas.token??'');
            },
          ),

          /// Alertas
          GoRoute(
            path: '/alertas',
            builder: (context, state) {
              return AlertasScreen(token: AppRutas.token ?? '');
            },
          ),

          /// Historial
          GoRoute(
            path: '/historial',
            builder: (context, state) {
              return  HistorialAlertasScreen(token: AppRutas.token ?? '');
            }
          ),

          /// Configuración
          GoRoute(
            path: '/configuracion',
            builder: (context, state) => const ConfiguracionScreen(),
          ),

          /// Detalle de producto
          GoRoute(
            path: '/detalleproducto/:id',
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>?;
              if (extra == null) {
                return const Scaffold(
                  body: Center(child: Text("No se pudo cargar el producto")),
                );
              }
              final producto = extra['producto'] as ProductoModel;
              return DetalleProductoScreen(
                producto: producto,
                token: AppRutas.token ?? '',
              );
            },
          ),

          /// Perfil
          GoRoute(
            path: '/perfil',
            builder: (context, state) => const PerfilScreen(),
          ),

          /// Cambiar clave
          GoRoute(
            path: '/cambiar_clave',
            builder: (context, state) => const CambiarClaveScreen(),
          ),
        ],
      ),
    ],

    /// Manejo de error de rutas
    errorBuilder: (context, state) {
      return Scaffold(
        body: Center(
          child: Text('Ruta no encontrada: ${state.uri}'),
        ),
      );
    },
  );
}