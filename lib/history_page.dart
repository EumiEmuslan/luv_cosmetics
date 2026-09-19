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
  late final Stream<List<Map<String, dynamic>>> historyStream;

  @override
  void initState() {
    super.initState();
    historyStream = HistoryManager.historyStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Text("Order History"),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: "Clear History",
            onPressed: () async {
              await HistoryManager.clearHistory();
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: historyStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final history = snapshot.data!;
          if (history.isEmpty) {
            return const Center(
              child: Text(
                "No delivered orders yet",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            );
          }

          return ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              final order = history[index];
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

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      product.imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    order['product_name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    "Qty: ${order['quantity']} • ${order['payment_mode']} • Delivered",
                    style: const TextStyle(color: Colors.black54),
                  ),
                  trailing: Text(
                    order['created_at'].toString().substring(0, 10),
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailView(product: product),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
