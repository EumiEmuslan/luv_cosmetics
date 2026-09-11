import 'package:flutter/material.dart';
import 'history_manager.dart';
import 'productmodel.dart';
import 'productdetailview.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> history = [];

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    final data = await HistoryManager.loadHistory();
    setState(() {
      history = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Text("Order History"),
      ),
      body: history.isEmpty
          ? const Center(child: Text("No delivered orders yet"))
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final order = history[index];

                // Convert history map back into Product object
                final product = Product(
                  imageUrl: order['image_url'] ?? '',
                  title: order['product_name'],
                  description: order['description'] ?? '',
                  price: (order['price'] as num?)?.toDouble() ?? 0.0,
                  oldPrice: (order['old_price'] as num?)?.toDouble(),
                  category: order['category'] ?? '',
                  createdAt: DateTime.tryParse(order['created_at']),
                  paymentMode: order['payment_mode'],
                );

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailView(product: product),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.all(12),
                    child: ListTile(
                      leading: const Icon(
                        Icons.history,
                        color: Colors.deepOrange,
                      ),
                      title: Text(order['product_name']),
                      subtitle: Text(
                        "Qty: ${order['quantity']} • Payment: ${order['payment_mode']}",
                      ),
                      trailing: Text(
                        order['created_at'].toString().substring(0, 10),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
