import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';
import '../services/firestore_service.dart';

class CartProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final List<CartItemModel> _items = [];
  List<CartItemModel> get items => _items;

  double get totalPrice => _items.fold(0, (sum, item) => sum + item.total);
  int get itemCount => _items.length;

  void addToCart(CartItemModel newItem, String uid) {
    final index = _items.indexWhere(
          (i) => i.productId == newItem.productId && i.size == newItem.size,
    );
    if (index >= 0) {
      _items[index].quantity += newItem.quantity;
    } else {
      _items.add(newItem);
    }
    notifyListeners();

    final saved = _items.firstWhere(
          (i) => i.productId == newItem.productId && i.size == newItem.size,
    );
    _firestoreService.saveCartItem(uid, saved);
  }

  void increaseQuantity(int index, String uid) {
    _items[index].quantity++;
    notifyListeners();
    _firestoreService.saveCartItem(uid, _items[index]);
  }

  void decreaseQuantity(int index, String uid) {
    if (_items[index].quantity > 1) {
      _items[index].quantity--;
      notifyListeners();
      _firestoreService.saveCartItem(uid, _items[index]);
    } else {
      final removed = _items[index];
      _items.removeAt(index);
      notifyListeners();
      _firestoreService.deleteCartItem(uid, removed);
    }
  }

  void removeItem(int index, String uid) {
    final removed = _items[index];
    _items.removeAt(index);
    notifyListeners();
    _firestoreService.deleteCartItem(uid, removed);
  }

  void clearCart(String uid) {
    _items.clear();
    notifyListeners();
    _firestoreService.clearCartInFirestore(uid);
  }
}