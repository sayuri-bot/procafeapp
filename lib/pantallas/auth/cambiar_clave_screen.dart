import 'package:flutter/material.dart';
import '../../servicios/cambiar_clave_service.dart';

class CambiarClaveScreen extends StatefulWidget {
  const CambiarClaveScreen({super.key});

  @override
  State<CambiarClaveScreen> createState() => _CambiarClaveScreenState();
}

class _CambiarClaveScreenState extends State<CambiarClaveScreen> {

  final CambiarClaveService _service = CambiarClaveService();

  final TextEditingController actualController = TextEditingController();
  final TextEditingController nuevaController = TextEditingController();
  final TextEditingController confirmarController = TextEditingController();

  bool cargando = false;

  Future<void> cambiarClave() async {

    if (nuevaController.text != confirmarController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Las contraseñas no coinciden")),
      );
      return;
    }

    setState(() {
      cargando = true;
    });

    bool resultado = await _service.cambiarClave(
      actualController.text,
      nuevaController.text,
    );

    setState(() {
      cargando = false;
    });

    if (resultado) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Contraseña actualizada")),
      );

      Navigator.pop(context);

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Contraseña actual incorrecta")),
      );

    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cambiar contraseña"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            TextField(
              controller: actualController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Contraseña actual",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: nuevaController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Nueva contraseña",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: confirmarController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Confirmar contraseña",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: cargando ? null : cambiarClave,
                child: cargando
                    ? const CircularProgressIndicator()
                    : const Text("Cambiar contraseña"),
              ),
            )

          ],
        ),
      ),
    );
  }
}