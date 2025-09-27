class ProductItemModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final double discountPrice;
  final String imageUrl;
  final String category;
  final int quantity;
  final double subtotal;

  ProductItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.discountPrice,
    required this.imageUrl,
    required this.category,
    required this.quantity,
    required this.subtotal,
  });

  factory ProductItemModel.fromMap(Map<String, dynamic> map) {
    return ProductItemModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] is num) ? (map['price'] as num).toDouble() : 0.0,
      discountPrice:
          (map['discount_price'] is num)
              ? (map['discount_price'] as num).toDouble()
              : 0.0,
      imageUrl: map['image_url'] ?? '',
      category: map['category'] ?? '',
      quantity: map['quantity'] is int ? map['quantity'] : 0,
      subtotal:
          (map['subtotal'] is num) ? (map['subtotal'] as num).toDouble() : 0.0,
    );
  }
}
