import 'package:flutter/material.dart';
import 'package:luv_cosmetics/navigation.dart';
import 'productmodel.dart';
import 'cart_manager.dart';
import 'order_manager.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

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
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // ✅ Buy Now button using OrderManager helper
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        String? chosenMode;

                        return AlertDialog(
                          title: const Text("Select Payment Mode"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CheckboxListTile(
                                title: const Text("Online Payment"),
                                value: chosenMode == "Online",
                                onChanged: (val) {
                                  chosenMode = "Online";
                                  Navigator.pop(context);
                                  OrderManager.proceedToOrders(context, [
                                    product,
                                  ], chosenMode!);
                                },
                              ),
                              CheckboxListTile(
                                title: const Text("Cash on Delivery (COD)"),
                                value: chosenMode == "COD",
                                onChanged: (val) {
                                  chosenMode = "COD";
                                  Navigator.pop(context);
                                  OrderManager.proceedToOrders(context, [
                                    product,
                                  ], chosenMode!);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: const Text("Buy Now"),
                ),

                // ✅ Add to Cart button
                OutlinedButton(
                  onPressed: () {
                    CartManager.add(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Added to cart")),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainNavigation(),
                      ),
                    );
                  },
                  child: const Text("Add to Cart"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
