import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/app_snackbar.dart';
import '../orders/order_history_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _firestoreService = FirestoreService();
  bool _isPlacingOrder = false;

  Future<void> _placeOrder(CartProvider cart, String uid) async {
    if (cart.items.isEmpty) return;
    setState(() => _isPlacingOrder = true);

    final orderItems = cart.items
        .map((item) => {
      'productId': item.productId,
      'name': item.name,
      'price': item.price,
      'size': item.size,
      'quantity': item.quantity,
    })
        .toList();

    try {
      await _firestoreService.addOrder(uid, {
        'items': orderItems,
        'total': cart.totalPrice,
        'date': DateTime.now(),
        'status': 'Confirmed',
      });

      cart.clearCart(uid);

      if (!mounted) return;
      AppSnackbar.show(context, 'The order has been successfully confirmed');
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const OrderHistoryScreen()));
    } catch (e) {
      if (!mounted) return;
      AppSnackbar.show(context, 'An error occurred during order confirmation,please try again', isError: true);
    } finally {
      if (mounted) setState(() => _isPlacingOrder = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final uid = context.watch<AuthProvider>().user?.uid;

    return Scaffold(
      appBar: AppBar(title: const Text('My Cart')),
      body: cart.items.isEmpty
          ? const EmptyState(
        icon: Icons.shopping_bag_outlined,
        title: 'The card is empty',
        subtitle: 'Add products so they appear here',
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cart.items.length,
              itemBuilder: (context, i) {
                final item = cart.items[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: item.imageUrl,
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text('Size: ${item.size}', style: TextStyle(color: Colors.grey.shade600)),
                              Text('\$${item.price.toStringAsFixed(0)}',
                                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: uid == null ? null : () => cart.decreaseQuantity(i, uid),
                            ),
                            Text('${item.quantity}'),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: uid == null ? null : () => cart.increaseQuantity(i, uid),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('\$${cart.totalPrice.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 18, color: AppColors.primary, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: (_isPlacingOrder || uid == null) ? null : () => _placeOrder(cart, uid),
                    child: _isPlacingOrder
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Checkout', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}