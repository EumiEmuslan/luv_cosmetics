import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'productmodel.dart';

class CartManager {
  static final List<Product> _cartItems = [];

  static List<Product> get items => _cartItems;

  static Future<void> add(Product product) async {
    _cartItems.add(product);
    await _saveCart();
  }

  static Future<void> remove(Product product) async {
    _cartItems.remove(product);
    await _saveCart();
  }

  static Future<void> clear() async {
    _cartItems.clear();
    await _saveCart();
  }

  static double get selectedTotalPrice {
    return _cartItems
        .where((item) => item.isSelected)
        .fold(0.0, (sum, item) => sum + item.price);
  }

  // 🔹 Save cart to SharedPreferences
  static Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = _cartItems
        .map((item) => jsonEncode(item.toJson()))
        .toList();
    await prefs.setStringList('cartItems', cartJson);
  }

  // 🔹 Load cart from SharedPreferences
  static Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = prefs.getStringList('cartItems') ?? [];
    _cartItems.clear();
    _cartItems.addAll(
      cartJson.map((item) => Product.fromJson(jsonDecode(item))),
    );
  }
}
