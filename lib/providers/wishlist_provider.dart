
import 'package:flutter/material.dart';
import '../models/wishlist_item_model.dart';

class WishlistProvider extends ChangeNotifier {
  final List<WishlistItemModel> _items = [];
  List<WishlistItemModel> get items => _items;

  bool isFavorite(String productId) => _items.any((i) => i.productId == productId);

  void toggleFavorite(WishlistItemModel item) {
    if (isFavorite(item.productId)) {
      _items.removeWhere((i) => i.productId == item.productId);
    } else {
      _items.add(item);
    }
    notifyListeners();
  }
}