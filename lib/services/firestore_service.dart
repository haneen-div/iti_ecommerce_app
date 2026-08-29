import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';
import '../models/cart_item_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<ProductModel>> getFeaturedProducts() {
    return _db
        .collection('products')
        .where('isFeatured', isEqualTo: true)
        .limit(14)
        .snapshots()
        .map((s) => s.docs.map((d) => ProductModel.fromMap(d.id, d.data())).toList());
  }

  Stream<List<ProductModel>> getPopularProducts() {
    return _db
        .collection('products')
        .where('isPopular', isEqualTo: true)
        .limit(7)
        .snapshots()
        .map((s) => s.docs.map((d) => ProductModel.fromMap(d.id, d.data())).toList());
  }

  Stream<List<ProductModel>> getAllProducts() {
    return _db
        .collection('products')
        .snapshots()
        .map((s) => s.docs.map((d) => ProductModel.fromMap(d.id, d.data())).toList());
  }

  Future<void> addOrder(String uid, Map<String, dynamic> orderData) async {
    await _db.collection('users').doc(uid).collection('orders').add(orderData);
  }

  Stream<List<Map<String, dynamic>>> getOrders(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('orders')
        .orderBy('date', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => {'id': d.id, ...d.data()}).toList());
  }


  Future<void> saveCartItem(String uid, CartItemModel item) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('cart')
        .doc(item.docId)
        .set(item.toMap());
  }

  Future<void> deleteCartItem(String uid, CartItemModel item) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('cart')
        .doc(item.docId)
        .delete();
  }

  Future<void> clearCartInFirestore(String uid) async {
    final snapshot = await _db.collection('users').doc(uid).collection('cart').get();
    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}