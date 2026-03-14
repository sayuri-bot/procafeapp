class ProductoModel {
  final int id;
  final String name;
  final int stock;
  final int stockMinimo;
  final double? price;
  final String? imageUrl;

  ProductoModel({
    required this.id,
    required this.name,
    required this.stock,
    required this.stockMinimo,
    this.price,
    this.imageUrl,
  });

  factory ProductoModel.fromJson(Map<String, dynamic> json) {
    return ProductoModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      stock: json['stock'] ?? 0,
      stockMinimo: json['stock_minimo'] ?? 0,
      price: json['price'] != null ? double.tryParse(json['price'].toString()) : null,  
      imageUrl: json['image_url']?? json['image'],
    );
  }

  // estados
  bool get isAgotado => stock <= 0;
  bool get isStockBajo => stock > 0 && stock <= stockMinimo;
  bool get isNormal => stock > stockMinimo;

//alertas 

  String get tipo {
    if (isAgotado) return "agotado";
    if (isStockBajo) return "bajo";
    return "normal";
  }

  String get mensajeAlerta {
    if (isAgotado) return "Producto agotado. Reposición urgente.";
    if (isStockBajo) return "Nivel de stock crítico. Reposición necesaria.";
    return "Stock disponible.";
  }
}