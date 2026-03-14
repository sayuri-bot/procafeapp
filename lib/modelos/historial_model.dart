class HistorialModel {

  final int id;
  final int productId;
  final String name;
  final int stockDetectado;
  final String fecha;
  final String mensaje;
  final String? imageUrl;

  HistorialModel({
    required this.id,
    required this.productId,
    required this.name,
    required this.stockDetectado,
    required this.fecha,
    required this.mensaje,
    this.imageUrl,
  });

  /// Determinar tipo de alerta
  bool get isAgotado => stockDetectado <= 0;

  bool get isStockBajo => stockDetectado > 0;

  factory HistorialModel.fromJson(Map<String, dynamic> json) {
    return HistorialModel(
      id: json['id'] ?? 0,
      productId: json['product_id'] ?? 0,
      name: json['name'] ?? '',
      stockDetectado: _parseInt(json['stock_detectado']),
      fecha: json['fecha'] ?? '',
      mensaje: json['mensaje'] ?? '',
      imageUrl: json['image_url'],
    );
  }

  /// Manejo seguro si el backend envía string o int
  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }
}