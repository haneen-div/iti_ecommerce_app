
import 'package:flutter/material.dart';
import '../models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  bool isLoading = false;

  // بيانات ثابتة (Static) — نفس أسماء وأسعار الديزاين بالظبط، وصورها ثابتة من النت
  final List<ProductModel> all = [
    ProductModel(
      id: 'p1',
      name: 'Watch',
      price: 40,
      description: 'Elegant stainless steel watch, water resistant and comfortable for daily wear.',
      imageUrl: 'https://loremflickr.com/400/400/watch?lock=1',
      category: 'watch',
      sizes: ['S', 'M', 'L'],
      rating: 4.5,
      isFeatured: true,
      isPopular: false,
    ),
    ProductModel(
      id: 'p2',
      name: 'Nike Shoes',
      price: 430,
      description: 'Premium sports shoes with breathable mesh and strong grip sole.',
      imageUrl: 'https://loremflickr.com/400/400/sneakers?lock=2',
      category: 'shoes',
      sizes: ['38', '39', '40', '41', '42'],
      rating: 4.7,
      isFeatured: true,
      isPopular: false,
    ),
    ProductModel(
      id: 'p3',
      name: 'Airpods',
      price: 333,
      description: 'True wireless earbuds with noise cancellation and long battery life.',
      imageUrl: 'https://loremflickr.com/400/400/earbuds?lock=3',
      category: 'headphones',
      sizes: ['One Size'],
      rating: 4.6,
      isFeatured: true,
      isPopular: false,
    ),
    ProductModel(
      id: 'p4',
      name: 'LG TV',
      price: 330,
      description: '4K Smart television with vibrant display and built-in streaming apps.',
      imageUrl: 'https://loremflickr.com/400/400/television?lock=4',
      category: 'tv',
      sizes: ['43 inch', '55 inch', '65 inch'],
      rating: 4.4,
      isFeatured: true,
      isPopular: true,
    ),
    ProductModel(
      id: 'p5',
      name: 'Hoodie',
      price: 50,
      description: 'Soft cotton hoodie, warm and perfect for casual everyday wear.',
      imageUrl: 'https://loremflickr.com/400/400/hoodie?lock=5',
      category: 'clothing',
      sizes: ['S', 'M', 'L', 'XL'],
      rating: 4.3,
      isFeatured: true,
      isPopular: true,
    ),
    ProductModel(
      id: 'p6',
      name: 'Jacket',
      price: 400,
      description: 'Heavy-duty winter jacket, waterproof and insulated for cold weather.',
      imageUrl: 'https://loremflickr.com/400/400/jacket?lock=6',
      category: 'jacket',
      sizes: ['S', 'M', 'L', 'XL'],
      rating: 4.8,
      isFeatured: true,
      isPopular: true,
    ),
    ProductModel(
      id: 'p7',
      name: 'Leather Bag',
      price: 150,
      description: 'Genuine leather handbag with spacious compartments and elegant finish.',
      imageUrl: 'https://loremflickr.com/400/400/handbag?lock=7',
      category: 'bag',
      sizes: ['One Size'],
      rating: 4.5,
      isFeatured: true,
      isPopular: true,
    ),
    ProductModel(
      id: 'p8',
      name: 'Sunglasses',
      price: 60,
      description: 'UV-protection sunglasses with polarized lenses and lightweight frame.',
      imageUrl: 'https://loremflickr.com/400/400/sunglasses?lock=8',
      category: 'sunglasses',
      sizes: ['One Size'],
      rating: 4.2,
      isFeatured: true,
      isPopular: true,
    ),
    ProductModel(
      id: 'p9',
      name: 'Running Shoes',
      price: 220,
      description: 'Lightweight running shoes designed for comfort on long distances.',
      imageUrl: 'https://loremflickr.com/400/400/running,shoes?lock=9',
      category: 'shoes',
      sizes: ['38', '39', '40', '41', '42'],
      rating: 4.6,
      isFeatured: true,
      isPopular: true,
    ),
    ProductModel(
      id: 'p10',
      name: 'Gold Bracelet',
      price: 95,
      description: 'Elegant gold-plated bracelet, perfect accessory for any outfit.',
      imageUrl: 'https://loremflickr.com/400/400/bracelet?lock=10',
      category: 'accessory',
      sizes: ['One Size'],
      rating: 4.1,
      isFeatured: true,
      isPopular: false,
    ),
    ProductModel(
      id: 'p11',
      name: 'Denim Jacket',
      price: 180,
      description: 'Classic denim jacket with a modern fit, versatile for all seasons.',
      imageUrl: 'https://loremflickr.com/400/400/denim,jacket?lock=11',
      category: 'jacket',
      sizes: ['S', 'M', 'L', 'XL'],
      rating: 4.4,
      isFeatured: true,
      isPopular: false,
    ),
    ProductModel(
      id: 'p12',
      name: 'Backpack',
      price: 75,
      description: 'Durable backpack with laptop compartment, ideal for daily commute.',
      imageUrl: 'https://loremflickr.com/400/400/backpack?lock=12',
      category: 'bag',
      sizes: ['One Size'],
      rating: 4.3,
      isFeatured: true,
      isPopular: false,
    ),
    ProductModel(
      id: 'p13',
      name: 'Smart Watch',
      price: 260,
      description: 'Fitness smartwatch with heart rate monitor and notification sync.',
      imageUrl: 'https://loremflickr.com/400/400/smartwatch?lock=13',
      category: 'watch',
      sizes: ['One Size'],
      rating: 4.7,
      isFeatured: true,
      isPopular: false,
    ),
    ProductModel(
      id: 'p14',
      name: 'Perfume',
      price: 110,
      description: 'Long-lasting fragrance with a fresh and elegant scent.',
      imageUrl: 'https://loremflickr.com/400/400/perfume?lock=14',
      category: 'perfume',
      sizes: ['50ml', '100ml'],
      rating: 4.5,
      isFeatured: true,
      isPopular: false,
    ),
  ];

  List<ProductModel> get featured => all.where((p) => p.isFeatured).toList(); // 14 صورة
  List<ProductModel> get popular => all.where((p) => p.isPopular).toList(); // 7 صور

  Future<void> refresh() async {
    await Future.delayed(const Duration(milliseconds: 800));
    notifyListeners();
  }

  List<ProductModel> search(String query) {
    if (query.isEmpty) return [];
    return all.where((p) => p.name.toLowerCase().contains(query.toLowerCase())).toList();
  }
}