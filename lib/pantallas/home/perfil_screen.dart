import 'package:flutter/material.dart';
import 'package:procafes/servicios/perfil_service.dart';
import 'package:procafes/modelos/perfil_model.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {

  final PerfilService _perfilService = PerfilService();

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarPerfil();
  }

  Future<void> cargarPerfil() async {

    PerfilModel perfil = await _perfilService.getPerfil();

    nombreController.text = perfil.nombre;
    emailController.text = perfil.email;

    setState(() {
      cargando = false;
    });
  }

  Future<void> guardarPerfil() async {

    bool actualizado = await _perfilService.actualizarPerfil(
      nombreController.text,
      emailController.text,
    );

    if (actualizado) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Perfil actualizado")),
      );

      Navigator.pop(context);

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al actualizar")),
      );

    }
  }

  @override
  Widget build(BuildContext context) {

    if (cargando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(

      appBar: AppBar(
        title: const Text("Perfil"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            const CircleAvatar(
              radius: 40,
              child: Icon(Icons.person, size: 40),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: nombreController,
              decoration: const InputDecoration(
                labelText: "Nombre",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: guardarPerfil,
                child: const Text("Guardar cambios"),
              ),
            )

          ],
        ),
      ),
    );
  }
}