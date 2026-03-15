import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:procafes/config/tema.dart';

class ConfiguracionScreen extends StatefulWidget {
  const ConfiguracionScreen({super.key});

  @override
  State<ConfiguracionScreen> createState() => _ConfiguracionScreenState();
}

class _ConfiguracionScreenState extends State<ConfiguracionScreen> {

  bool notificacionesApp = false;
  bool sonidoAlerta = false;
  bool vibracion = false;
  bool emailDiario = false;

  String tiempoSesion = "30 minutos de inactividad";

  void _cerrarSesion() {
    context.go('/login');
  }

  void _navegar(String ruta) {
    context.push(ruta);
  }

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return SafeArea(
      child: Container(
        color: theme.scaffoldBackgroundColor,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [

            /// TITULO
            const Center(
              child: Text(
                "CONFIGURACIÓN",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// PERFIL CARD
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  )
                ],
              ),
              child: Row(
                children: const [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.black,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Administrador",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                      SizedBox(height: 4),
                      Text("admin@procafes.pe"),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// BOTONES
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _botonCapsula(
                    Icons.edit,
                    "Perfil",
                        () => _navegar('/perfil')),
                _botonCapsula(
                    Icons.lock,
                    "Clave",
                        () => _navegar('/cambiar_clave')),
              ],
            ),

            const SizedBox(height: 35),

            /// NOTIFICACIONES
            const Text(
                "NOTIFICACIONES",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey)),

            const SizedBox(height: 15),
            //borrar switch innecesario
            _cardSeccion(
              Column(
                children: [
                  _switchItem(Icons.notifications,
                      "Notificaciones App", notificacionesApp,
                          (val) {
                        setState(() => notificacionesApp = val);
                      }),
                  _switchItem(Icons.volume_up,
                      "Sonido de alerta", sonidoAlerta,
                          (val) {
                        setState(() => sonidoAlerta = val);
                      }),
                  _switchItem(Icons.vibration,
                      "Vibración", vibracion,
                          (val) {
                        setState(() => vibracion = val);
                      }),
                ],
              ),
            ),

            const SizedBox(height: 35),

            /// APARIENCIA
            const Text(
                "APARIENCIA",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey)),

            const SizedBox(height: 15),

            _cardSeccion(_switchItem(
              Icons.dark_mode, "Modo oscuro",
              Theme.of(context).brightness == Brightness.dark, (val) {
                try {
                  // Replace this with your actual theme change logic, e.g. using Provider:
                  // context.read<TuTemaProvider>().cambiarTema(val);
                  // Or if using a ValueNotifier or similar:
                  // tuTemaNotifier.value = val;
                  // For demonstration, we'll just print:
                  print('Cambiar tema a modo oscuro: $val');
                } catch (e) {
                  print('Error al cambiar tema: $e');
                }
              })),

            const SizedBox(height: 35),

            /// SEGURIDAD
            const Text(
                "SEGURIDAD",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey)),

            const SizedBox(height: 15),

            _cardSeccion(
              Column(
                children: [

                  DropdownButton<String>(
                    value: tiempoSesion,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(
                        value: "15 minutos de inactividad",
                        child: Text("15 minutos de inactividad"),
                      ),
                      DropdownMenuItem(
                        value: "30 minutos de inactividad",
                        child: Text("30 minutos de inactividad"),
                      ),
                      DropdownMenuItem(
                        value: "1 hora de inactividad",
                        child: Text("1 hora de inactividad"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        tiempoSesion = value!;
                      });
                    },
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _cerrarSesion,
                      icon: const Icon(Icons.logout),
                      label: const Text("CERRAR SESIÓN"),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: theme.cardColor,
                        foregroundColor: theme.textTheme.bodyMedium!.color,
                        padding: const EdgeInsets.symmetric(
                            vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(40),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardSeccion(Widget child) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 15,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: child,
    );
  }

  Widget _botonCapsula(
      IconData icono,
      String texto,
      VoidCallback onPressed) {

    final theme = Theme.of(context);

    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icono, size: 18),
      label: Text(texto),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: theme.cardColor,
        foregroundColor: theme.textTheme.bodyMedium!.color,
        padding: const EdgeInsets.symmetric(
            horizontal: 30, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
      ),
    );
  }

  Widget _switchItem(
      IconData icono,
      String texto,
      bool valor,
      Function(bool) onChanged) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icono, color: Colors.grey[700]),
              const SizedBox(width: 12),
              Text(texto),
            ],
          ),
          Switch(
            value: valor,
            activeThumbColor: ColoresApp.boton,
            activeTrackColor:
            ColoresApp.boton.withValues(alpha: 0.4),
            onChanged: onChanged,
          )
        ],
      ),
    );
  }
}