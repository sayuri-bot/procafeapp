class CambiarClaveModel {
  final String claveActual;
  final String claveNueva;

  CambiarClaveModel({
    required this.claveActual,
    required this.claveNueva,
  });

  Map<String, dynamic> toJson() {
    return {
      "clave_actual": claveActual,
      "clave_nueva": claveNueva,
    };
  }
}