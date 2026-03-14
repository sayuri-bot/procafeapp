import 'package:procafes/servicios/perfil_service.dart';

class CambiarClaveService {

  Future<bool> cambiarClave(String actual, String nueva) async {
    // Llamar al servicio de perfil para cambiar la contraseña
    final perfilService = PerfilService();
    return await perfilService.cambiarContrasena(actual, nueva);
  }

}