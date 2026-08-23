import 'package:flutter/material.dart';
import 'navigation.dart';
import 'productmodel.dart';

class OrderManager {
  static List<Product> orders = [];

  static void addOrders(List<Product> newOrders) {
    orders.addAll(newOrders);
  }

  static void clear() {
    orders.clear();
  }

  /// Shared order placement flow
  static void proceedToOrders(
    BuildContext context,
    List<Product> selectedItems,
    String mode,
  ) {
    for (var item in selectedItems) {
      item.paymentMode = mode;
    }

    addOrders(selectedItems);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Order placed with $mode")));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainNavigation()),
    );
  }
}
