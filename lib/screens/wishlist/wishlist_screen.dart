
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../providers/wishlist_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/empty_state.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlist = context.watch<WishlistProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist')),
      body: wishlist.items.isEmpty
          ? const EmptyState(
        icon: Icons.favorite_border,
        title: 'There is nothing in my favorites',
        subtitle: 'Click on the heart on any product to add it here',
      )
          : GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        itemCount: wishlist.items.length,
        itemBuilder: (context, i) {
          final item = wishlist.items[i];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: CachedNetworkImage(
                  imageUrl: item.imageUrl,
                  height: 130,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 6),
              Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text('\$${item.price.toStringAsFixed(0)}', style: const TextStyle(color: AppColors.primary)),
            ],
          );
        },
      ),
    );
  }
}