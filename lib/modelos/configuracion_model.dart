//modificar el modelo de configuracion para agregar mas opciones
class ConfiguracionModel {
  bool notificacionesApp;
  bool sonidoAlerta;
  bool modoOscuro;
  bool vibracion;
  String tiempoSesion;

  ConfiguracionModel({
    required this.notificacionesApp,
    required this.sonidoAlerta,
    required this.vibracion,
    required this.modoOscuro,
    required this.tiempoSesion,
  });
  
  factory ConfiguracionModel.defaultConfig(){
    return ConfiguracionModel(
      notificacionesApp: true,
      sonidoAlerta: true,
      vibracion: true,
      modoOscuro: false,
      tiempoSesion: "30 minutos de inactividad",
    );
  }

  Map<String, dynamic> topMap() {
    return {
      'notificacionesApp': notificacionesApp,
      'sonidoAlerta': sonidoAlerta,
      'vibracion': vibracion,
      'modoOscuro': modoOscuro,
      'tiempoSesion': tiempoSesion,
    };
  }

  factory ConfiguracionModel.fromMap(Map<String, dynamic> map) {
    return ConfiguracionModel(
      notificacionesApp: map['notificacionesApp'] ?? true,
      sonidoAlerta: map['sonidoAlerta'] ?? true,
      vibracion: map['vibracion'] ?? true,
      modoOscuro: map['modoOscuro'] ?? false,
      tiempoSesion: map['tiempoSesion'] ?? "30 minutos de inactividad",
    );
  }
}
