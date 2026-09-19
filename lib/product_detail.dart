import 'package:flutter/material.dart';
import 'package:luv_cosmetics/navigation.dart';
import 'productmodel.dart';
import 'cart_manager.dart';
import 'confirm_page.dart'; // <-- import your confirm page

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(product.title),
        backgroundColor: Colors.deepOrange,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(),
            const SizedBox(height: 20),
            _buildTitle(),
            const SizedBox(height: 8),
            _buildDescription(),
            const SizedBox(height: 20),
            _buildPrice(),
            const SizedBox(height: 30),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(product.imageUrl, height: 250, fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      product.title,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildDescription() {
    return Text(
      product.description,
      style: const TextStyle(fontSize: 16, color: Colors.black54, height: 1.4),
    );
  }

  Widget _buildPrice() {
    return Row(
      children: [
        Text(
          "₱${product.price.toStringAsFixed(2)}",
          style: const TextStyle(
            fontSize: 22,
            color: Colors.deepOrange,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 12),
        if (product.oldPrice != null)
          Text(
            "₱${product.oldPrice!.toStringAsFixed(2)}",
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              decoration: TextDecoration.lineThrough,
            ),
          ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: const Icon(Icons.shopping_bag),
            label: const Text("Buy Now", style: TextStyle(fontSize: 16)),
            onPressed: () => _showPaymentDialog(context),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: Colors.deepOrange),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: const Icon(Icons.add_shopping_cart, color: Colors.deepOrange),
            label: const Text(
              "Add to Cart",
              style: TextStyle(fontSize: 16, color: Colors.deepOrange),
            ),
            onPressed: () {
              CartManager.add(product);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Added to cart")));
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MainNavigation()),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showPaymentDialog(BuildContext context) {
    String? chosenMode;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select Payment Mode"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text("Online Payment"),
                value: "Online",
                groupValue: chosenMode,
                onChanged: (val) {
                  chosenMode = val;
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ConfirmPage(
                        product: product,
                        paymentMode: chosenMode!,
                      ),
                    ),
                  );
                },
              ),
              RadioListTile<String>(
                title: const Text("Cash on Delivery (COD)"),
                value: "COD",
                groupValue: chosenMode,
                onChanged: (val) {
                  chosenMode = val;
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ConfirmPage(
                        product: product,
                        paymentMode: chosenMode!,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
