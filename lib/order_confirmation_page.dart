import 'dart:async';
import 'package:flutter/material.dart';
import 'order.dart'; // your Order class
import 'navigation.dart'; // your MainNavigation class

class OrderConfirmationPage extends StatefulWidget {
  final Order order;

  const OrderConfirmationPage({super.key, required this.order});

  @override
  State<OrderConfirmationPage> createState() => _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends State<OrderConfirmationPage> {
  late final Order order;
  Timer? uiTimer;

  @override
  void initState() {
    super.initState();
    order = widget.order;

    // Refresh UI every second so progress bar updates
    uiTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    uiTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Text("Order Confirmed"),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 16),
            Text(
              "Your order for ${order.product.title} has been placed!",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),

            // Progress bar
            LinearProgressIndicator(
              value: order.progress, // comes from Order class
              backgroundColor: Colors.grey[300],
              color: Colors.deepOrange,
              minHeight: 8,
            ),
            const SizedBox(height: 12),
            Text(
              order.status,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),

            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // solid black background
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Back to Home",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white, // white text for contrast
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const MainNavigation()),
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
