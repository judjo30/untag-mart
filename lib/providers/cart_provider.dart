import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items => _items;

  int get totalItem => _items.length;

  double get subtotal {
    return _items.fold(
      0,
      (total, item) => total + (item['price'] as double),
    );
  }

  double get totalDiscount {
    return _items.fold(
      0,
      (total, item) => total + (item['discountAmount'] as double),
    );
  }

  double get totalHarga {
    return _items.fold(
      0,
      (total, item) => total + (item['finalPrice'] as double),
    );
  }

  void addToCart(Map<String, dynamic> product) {
    _items.add(product);
    notifyListeners();
  }

  void removeFromCart(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}