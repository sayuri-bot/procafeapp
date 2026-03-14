class UsuarioModel {
  final int id;
  final String name;
  final String email;
  final String token;

  UsuarioModel({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      id: json['user']['id'],
      name: json['user']['name'],
      email: json['user']['email'],
      token: json['token'],
    );
  }
}