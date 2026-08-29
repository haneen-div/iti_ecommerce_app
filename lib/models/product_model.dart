class ProductModel {
  final String id;
  final String name;
  final double price;
  final String description;
  final String imageUrl;
  final String category;
  final List<String> sizes;
  final double rating;
  final bool isFeatured;
  final bool isPopular;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.sizes,
    required this.rating,
    required this.isFeatured,
    required this.isPopular,
  });

  factory ProductModel.fromMap(String id, Map<String, dynamic> map) {
    return ProductModel(
      id: id,
      name: map['name'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      category: map['category'] ?? '',
      sizes: List<String>.from(map['sizes'] ?? []),
      rating: (map['rating'] ?? 0).toDouble(),
      isFeatured: map['isFeatured'] ?? false,
      isPopular: map['isPopular'] ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'price': price,
    'description': description,
    'imageUrl': imageUrl,
    'category': category,
    'sizes': sizes,
    'rating': rating,
    'isFeatured': isFeatured,
    'isPopular': isPopular,
  };
}