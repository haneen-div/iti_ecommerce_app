
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/product_model.dart';
import '../../models/cart_item_model.dart';
import '../../models/wishlist_item_model.dart';
import '../../providers/cart_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../providers/auth_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/app_snackbar.dart';
import '../cart/cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String? _selectedSize;

  bool _validateSize() {
    if (widget.product.sizes.isNotEmpty && _selectedSize == null) {
      AppSnackbar.show(context, 'choose the size', isError: true);
      return false;
    }
    return true;
  }

  void _addToCart() {
    if (!_validateSize()) return;
    final uid = context.read<AuthProvider>().user?.uid;
    if (uid == null) {
      AppSnackbar.show(context, 'you need to log in', isError: true);
      return;
    }
    context.read<CartProvider>().addToCart(
      CartItemModel(
        productId: widget.product.id,
        name: widget.product.name,
        price: widget.product.price,
        imageUrl: widget.product.imageUrl,
        size: _selectedSize ?? '-',
      ),
      uid,
    );
    AppSnackbar.show(context, 'Added to Cart successfully');
  }

  void _buyNow() {
    if (!_validateSize()) return;
    final uid = context.read<AuthProvider>().user?.uid;
    if (uid == null) {
      AppSnackbar.show(context, 'you need to log in', isError: true);
      return;
    }
    context.read<CartProvider>().addToCart(
      CartItemModel(
        productId: widget.product.id,
        name: widget.product.name,
        price: widget.product.price,
        imageUrl: widget.product.imageUrl,
        size: _selectedSize ?? '-',
      ),
      uid,
    );
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CartScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final wishlist = context.watch<WishlistProvider>();
    final isFav = wishlist.isFavorite(product.id);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: product.imageUrl,
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.black),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: IconButton(
                              icon: Icon(isFav ? Icons.favorite : Icons.favorite_border,
                                  color: isFav ? AppColors.favoriteRed : Colors.black),
                              onPressed: () => wishlist.toggleFavorite(WishlistItemModel(
                                productId: product.id,
                                name: product.name,
                                price: product.price,
                                imageUrl: product.imageUrl,
                              )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text('\$${product.price.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 18, color: AppColors.primary, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    const Text('Size', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      children: product.sizes.map((size) {
                        final selected = _selectedSize == size;
                        return ChoiceChip(
                          label: Text(size),
                          selected: selected,
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(color: selected ? Colors.white : Colors.black),
                          onSelected: (_) => setState(() => _selectedSize = size),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    const Text('Description', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(product.description, style: TextStyle(color: Colors.grey.shade700, height: 1.5)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_bag_outlined, size: 28),
              onPressed: _addToCart,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: _buyNow,
                child: const Text('Buy Now', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}