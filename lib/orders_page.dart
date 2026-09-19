import 'dart:async';
import 'package:flutter/material.dart';
import 'order.dart';
import 'order_manager.dart';
import 'history_page.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  Timer? uiTimer;

  @override
  void initState() {
    super.initState();
    // Refresh UI every second so progress bars update
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
    final orders = OrderManager.orders;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Text("My Orders"),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: "View History",
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HistoryPage()),
              );
              setState(() {}); // refresh after returning
            },
          ),
        ],
      ),
      body: orders.isEmpty
          ? const Center(child: Text("No active orders"))
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                final product = order.product;

                return Card(
                  margin: const EdgeInsets.all(12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
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
                            product.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            "Status: ${order.status}",
                            style: const TextStyle(color: Colors.black54),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Main stage progress bar
                        LinearProgressIndicator(
                          value: order.progress,
                          backgroundColor: Colors.grey[300],
                          color: Colors.deepOrange,
                          minHeight: 8,
                        ),
                        const SizedBox(height: 6),

                        // Stage labels
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: Order.stages.map((s) {
                            final idx = Order.stages.indexOf(s);
                            return Text(
                              s,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: idx == order.stageIndex
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: idx <= order.stageIndex
                                    ? Colors.deepOrange
                                    : Colors.grey,
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 12),

                        // Sub-progress bar with icon
                        Row(
                          children: [
                            Icon(
                              order.stageIndex == 0
                                  ? Icons.inventory
                                  : order.stageIndex == 1
                                  ? Icons.local_shipping
                                  : order.stageIndex == 2
                                  ? Icons.directions_car
                                  : Icons.check_circle,
                              color: order.stageIndex == Order.stages.length - 1
                                  ? Colors.green
                                  : Colors.deepOrange,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: LinearProgressIndicator(
                                value: order.subProgress,
                                backgroundColor: Colors.grey[200],
                                color: Colors.deepOrange,
                                minHeight: 6,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
