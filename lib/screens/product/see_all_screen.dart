
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../widgets/product_card.dart';
import 'product_detail_screen.dart';

class SeeAllScreen extends StatelessWidget {
  final String type; // 'featured' or 'popular'
  const SeeAllScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();
    final list = type == 'featured' ? provider.featured : provider.popular;

    return Scaffold(
      appBar: AppBar(title: Text(type == 'featured' ? 'Featured' : 'Most Popular')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.72,
        ),
        itemCount: list.length,
        itemBuilder: (context, i) {
          final p = list[i];
          return ProductCard(
            product: p,
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => ProductDetailScreen(product: p))),
          );
        },
      ),
    );
  }
}