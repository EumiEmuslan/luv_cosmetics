import 'package:flutter/material.dart';
import 'productmodel.dart';
import 'order_manager.dart';
import 'order.dart'; // import your Order class
import 'order_confirmation_page.dart';

class ConfirmPage extends StatelessWidget {
  final Product product;
  final String paymentMode;

  const ConfirmPage({
    super.key,
    required this.product,
    required this.paymentMode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Text("Confirm Your Order"),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Please review your order before placing:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    product.imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(product.title),
                subtitle: Text("Payment: $paymentMode"),
                trailing: Text(
                  "₱${product.price.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Place Order",
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  // Proceed with order placement
                  OrderManager.proceedToOrders(context, [product], paymentMode);

                  // Create an Order object with timers
                  final order = Order(product);

                  // Navigate to confirmation page with live progress
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OrderConfirmationPage(order: order),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
