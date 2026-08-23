import 'package:flutter/material.dart';
import 'productmodel.dart';

class ProductDetailView extends StatelessWidget {
  final Product product;
  final String? status; // 👈 optional for Orders
  final String? paymentMode; // 👈 optional for Orders/History

  const ProductDetailView({
    super.key,
    required this.product,
    this.status,
    this.paymentMode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                product.imageUrl,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              product.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(product.description),
            const SizedBox(height: 20),
            Text(
              "₱${product.price.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 20,
                color: Colors.deepOrange,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (product.oldPrice != null)
              Text(
                "₱${product.oldPrice!.toStringAsFixed(2)}",
                style: const TextStyle(
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            const SizedBox(height: 20),
            if (status != null)
              Text(
                "Status: $status",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            if (paymentMode != null)
              Text(
                "Payment: $paymentMode",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}
