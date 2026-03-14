import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../modelos/usuario_model.dart';

class PrincipalScreen extends StatelessWidget {

  final UsuarioModel? admin;
  final Widget child;

  const PrincipalScreen({
    super.key,
    this.admin,
    required this.child,
  });

  /// Rutas del BottomNavigation
  static const List<String> rutas = [
    '/panel',
    '/alertas',
    '/historial',
    '/configuracion',
  ];

  String _tituloAppBar() {
    if (admin != null) {
      return "Bienvenido, ${admin!.name}";
    }
    return "Panel Administrativo";
  }

  int _calcularIndice(BuildContext context) {

    final location = GoRouterState.of(context).uri.toString();

    final index = rutas.indexWhere(
      (ruta) => location.startsWith(ruta),
    );

    return index == -1 ? 0 : index;
  }

  void _onItemTapped(BuildContext context, int index) {
    context.go(rutas[index]);
  }

  @override
  Widget build(BuildContext context) {

    final index = _calcularIndice(context);

    return Scaffold(

      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(_tituloAppBar()),
      ),

      body: child,

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (value) => _onItemTapped(context, value),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.brown,
        unselectedItemColor: Colors.grey,
        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Panel',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.warning_amber_outlined),
            label: 'Alertas',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Historial',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Config.',
          ),
        ],
      ),
    );
  }
}