import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:procafes/rutas/rutas.dart';
import 'package:procafes/servicios/auth_service.dart';
import 'package:procafes/modelos/usuario_model.dart';
import 'package:procafes/servicios/notificacion_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usuarioController = TextEditingController();
  final _contrasenaController = TextEditingController();
  bool _ocultarContrasena = true;

  @override
  void dispose() {
    _usuarioController.dispose();
    _contrasenaController.dispose();
    super.dispose();
  }

  Future<void> _iniciarSesion() async {
    if (!_formKey.currentState!.validate()) return;

    mostrarCargando();

    try {
      final UsuarioModel? admin = await AuthService.login(
        _usuarioController.text.trim(),
        _contrasenaController.text.trim(),
      );

      if (!mounted) return;

      ocultarCargando();

      if (admin != null) {
          AppRutas.token = admin.token; 
          print("Token LOGIN: ${AppRutas.token}"); // 🔹 Para depuración
          context.go('/panel', extra: admin);
          await NotificationService.initForUser(admin.id.toString());
          await NotificationService.testNotification();

      } else {
        _mostrarError("Credenciales incorrectas");
      }

    } catch (e) {
      if (!mounted) return;
      ocultarCargando();
      print("Error login: $e"); // 🔹 Para depuración
      _mostrarError("Error al iniciar sesión");
    }
  }

  void mostrarCargando() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text("Cargando..."),
          ],
        ),
      ),
    );
  }

  void ocultarCargando() {
    context.pop();
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Bienvenido a Procafes',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _usuarioController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Ingresa tu email';
                    if (!value.contains('@')) return 'Email inválido';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _contrasenaController,
                  obscureText: _ocultarContrasena,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _ocultarContrasena ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () => setState(() => _ocultarContrasena = !_ocultarContrasena),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Ingresa tu contraseña';
                    if (value.length < 6) return 'Mínimo 6 caracteres';
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _iniciarSesion,
                    child: const Text('Iniciar Sesión'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}