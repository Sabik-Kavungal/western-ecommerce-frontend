class Product {
  final String id;
  final String name;
  final String description;
  final List<String> images;
  final double price; // Online price (₹400)
  final String color; // Color variant
  final int quantity; // Quantity available (1 per color)
  final List<String> availableSizes;
  final bool isFeatured;
  final bool isAvailable;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
    required this.price,
    required this.color,
    this.quantity = 1,
    required this.availableSizes,
    this.isFeatured = false,
    this.isAvailable = true,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      images: List<String>.from(json['images'] as List),
      price: (json['price'] as num).toDouble(),
      color: json['color'] as String? ?? 'Default',
      quantity: json['quantity'] as int? ?? 1,
      availableSizes: List<String>.from(json['availableSizes'] as List),
      isFeatured: json['isFeatured'] as bool? ?? false,
      isAvailable: json['isAvailable'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'images': images,
      'price': price,
      'color': color,
      'quantity': quantity,
      'availableSizes': availableSizes,
      'isFeatured': isFeatured,
      'isAvailable': isAvailable,
    };
  }

  Product copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? images,
    double? price,
    String? color,
    int? quantity,
    List<String>? availableSizes,
    bool? isFeatured,
    bool? isAvailable,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      images: images ?? this.images,
      price: price ?? this.price,
      color: color ?? this.color,
      quantity: quantity ?? this.quantity,
      availableSizes: availableSizes ?? this.availableSizes,
      isFeatured: isFeatured ?? this.isFeatured,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}
