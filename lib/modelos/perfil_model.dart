class PerfilModel {
  final int id;
  final String nombre;
  final String email;

  PerfilModel({
    required this.id,
    required this.nombre,
    required this.email,
  });

  factory PerfilModel.fromJson(Map<String, dynamic> json) {
    return PerfilModel(
      id: json['id'] ?? 0,
      nombre: json['nombre'] ?? '',
      email: json['email'] ?? '',
    );
  }

  // Método copyWith para crear una copia con cambios
  PerfilModel copyWith({
    int? id,
    String? nombre,
    String? email,
  }) {
    return PerfilModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'email': email,
    };
  }
}