import 'package:procafes/modelos/perfil_model.dart';

class PerfilService {
  // Almacenamiento estático de datos
  static PerfilModel? _perfilActual;
  static String? _contrasenaActual = '123456'; // Contraseña inicial por defecto

  Future<PerfilModel> getPerfil() async {
    // Obtener perfil del almacenamiento o usar datos por defecto
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (_perfilActual != null) {
      return _perfilActual!;
    }
    
    // Datos iniciales
    _perfilActual = PerfilModel(
      id: 1,
      nombre: 'Administrador',
      email: 'administrador@procafes.pe',
    );
    
    return _perfilActual!;
  }

  Future<bool> actualizarPerfil(String nombre, String email) async {
    // Guardar datos actualizados
    await Future.delayed(const Duration(milliseconds: 800));
    
    try {
      _perfilActual = PerfilModel(
        id: _perfilActual?.id ?? 1,
        nombre: nombre,
        email: email,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> cambiarContrasena(String contrasenaActual, String nuevaContrasena) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    try {
      // Verificar que la contraseña actual sea correcta
      if (_contrasenaActual == null || _contrasenaActual != contrasenaActual) {
        return false;
      }
      
      // Guardar la nueva contraseña
      _contrasenaActual = nuevaContrasena;
      return true;
    } catch (e) {
      return false;
    }
  }

  // Obtener contraseña actual (solo para validación)
  String? getContrasenaActual() {
    return _contrasenaActual;
  }
}