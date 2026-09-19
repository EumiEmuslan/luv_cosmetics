import 'package:flutter/material.dart';
import 'productmodel.dart';
import 'order.dart';
import 'orders_page.dart'; // <-- import your OrdersPage

class OrderManager {
  static final List<Order> orders = [];

  /// Add new products to the FRONT of the list
  static void addOrders(List<Product> newProducts, String mode) {
    for (var product in newProducts) {
      product.paymentMode = mode;
      orders.insert(0, Order(product)); // timers start here
    }
  }

  static void clear() {
    for (var order in orders) {
      order.dispose(); // cancel timers
    }
    orders.clear();
  }

  /// Shared order placement flow
  static void proceedToOrders(
    BuildContext context,
    List<Product> selectedItems,
    String mode,
  ) {
    addOrders(selectedItems, mode);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Order placed with $mode")));

    // Navigate to OrdersPage instead of MainNavigation
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const OrdersPage()),
    );
  }
}
