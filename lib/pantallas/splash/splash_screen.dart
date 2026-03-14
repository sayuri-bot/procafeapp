import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  // dispara
  @override
  void initState() {
    super.initState();
    _cargarAplicacion();
  }

  // servicio o carga de datos
  Future<void> _cargarAplicacion() async {

    // Simula carga real
    await Future.delayed(const Duration(seconds: 2));

    // Navega a login usando GoRouter
    if (mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          // Fondo
          SizedBox.expand(
            child: Image.asset(
              'assets/images/fondo.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // Overlay
          Container(
            color: Colors.black.withAlpha(115),
          ),

          // Contenido
          SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.asset(
                      'assets/images/logo.jpg',
                      width: 120,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Elevando el arte de la gestión del café',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 24),

                  const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}