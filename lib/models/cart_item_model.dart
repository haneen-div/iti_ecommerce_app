class CartItemModel {
  final String productId;
  final String name;
  final double price;
  final String imageUrl;
  final String size;
  int quantity;

  CartItemModel({
    required this.productId,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.size,
    this.quantity = 1,
  });

  double get total => price * quantity;

  String get docId => '${productId}_$size';

  Map<String, dynamic> toMap() => {
    'productId': productId,
    'name': name,
    'price': price,
    'imageUrl': imageUrl,
    'size': size,
    'quantity': quantity,
  };
}