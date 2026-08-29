
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/product_model.dart';
import '../models/wishlist_item_model.dart';
import '../providers/wishlist_provider.dart';
import '../core/constants/app_colors.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;

  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final wishlist = context.watch<WishlistProvider>();
    final isFav = wishlist.isFavorite(product.id);

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: CachedNetworkImage(
                    imageUrl: product.imageUrl,
                    height: 120,
                    width: 150,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      height: 120,
                      width: 150,
                      color: Colors.grey.shade200,
                    ),
                  ),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: GestureDetector(
                    onTap: () => wishlist.toggleFavorite(WishlistItemModel(
                      productId: product.id,
                      name: product.name,
                      price: product.price,
                      imageUrl: product.imageUrl,
                    )),
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.white,
                      child: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? AppColors.favoriteRed : Colors.grey,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(product.name, style: const TextStyle(fontWeight: FontWeight.w600)),
            Text('\$${product.price.toStringAsFixed(0)}',
                style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}