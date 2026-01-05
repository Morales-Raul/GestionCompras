class Product {
  String id;
  String name;
  String imageUrl;
  String category;
  bool available;

  // Mapa de precios por supermercado
  Map<String, double> prices;

  // Cantidad en el carrito
  int quantity;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.category,
    required this.prices,
    this.available = true,
    this.quantity = 1, // Por defecto es 1
  });

  // Factory para crear instancia desde un mapa (Firebase)
  factory Product.fromMap(Map<String, dynamic> map, String documentId) {
    return Product(
      id: documentId,
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      category: map['category'] ?? '',
      available: map['available'] ?? true,
      prices: {
        'Walmart': _toDouble(map['walmartPrice']),
      },
      quantity: map['quantity'] ?? 1, // Solo si quieres guardarlo en Firebase
    );
  }

  // Convierte la instancia a un mapa para guardar en Firebase
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'category': category,
      'walmartPrice': prices['Walmart'] ?? 0.0,
      'available': available,
      'quantity': quantity, // Solo si decides guardarlo
    };
  }

  // Crea una copia del producto
  Product copy() => Product(
        id: id,
        name: name,
        imageUrl: imageUrl,
        category: category,
        prices: Map<String, double>.from(prices),
        available: available,
        quantity: quantity,
      );

  // Helper para convertir dinámicos a double
  static double _toDouble(dynamic value) {
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}
