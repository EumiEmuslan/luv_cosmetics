import 'package:flutter/material.dart';
import 'package:luv_cosmetics/productdetailview.dart';
import 'order_manager.dart';
import 'history_manager.dart';
import 'history_page.dart';
import 'productmodel.dart';
import 'dart:async';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late List<Map<String, dynamic>> orders;
  Timer? _simulationTimer;
  Timer? _subTimer;
  double _subProgress = 0.0;

  final List<String> stages = [
    "Pending",
    "Picked up by courier",
    "On the way",
    "Delivered",
  ];

  @override
  void initState() {
    super.initState();

    // Build orders list from OrderManager
    orders = OrderManager.orders
        .map(
          (item) => {
            'image_url': item.imageUrl,
            'product_name': item.title,
            'description': item.description,
            'price': item.price,
            'old_price': item.oldPrice,
            'category': item.category,
            'quantity': 1,
            'status': 'Pending',
            'created_at': DateTime.now().toIso8601String(),
            'payment_mode': item.paymentMode ?? "Unknown",
          },
        )
        .toList();

    // Stage simulation every 30s
    _simulationTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      simulateOrderProgress();
      _subProgress = 0.0;
    });

    // Sub-progress fills gradually
    _subTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _subProgress += 1 / 30;
        if (_subProgress > 1.0) _subProgress = 1.0;
      });
    });
  }

  @override
  void dispose() {
    _simulationTimer?.cancel();
    _subTimer?.cancel();
    super.dispose();
  }

  void simulateOrderProgress() {
    setState(() {
      for (var order in List<Map<String, dynamic>>.from(orders)) {
        final currentIndex = stages.indexOf(order['status']);
        if (currentIndex < stages.length - 1) {
          order['status'] = stages[currentIndex + 1];
        } else if (order['status'] == "Delivered") {
          // Save to history
          HistoryManager.addToHistory(order);
          // Remove from active orders
          orders.remove(order);
        }
      }
    });
  }

  int _getStageIndex(String status) => stages.indexOf(status);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Text("My Orders"),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: "View History",
            onPressed: () async {
              // Navigate to HistoryPage and reload when returning
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HistoryPage()),
              );
              setState(() {}); // refresh OrdersPage after returning
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
                final stageIndex = _getStageIndex(order['status']);
                final progress = (stageIndex + 1) / stages.length;

                // Convert order map back into Product for detail page
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
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: const Icon(
                              Icons.shopping_bag,
                              color: Colors.deepOrange,
                            ),
                            title: Text(order['product_name']),
                            subtitle: Text(
                              "Qty: ${order['quantity']} • Status: ${order['status']}\nPayment: ${order['payment_mode']}",
                            ),
                            trailing: Text(
                              order['created_at'].toString().substring(0, 10),
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Top progress bar
                          LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.grey[300],
                            color: Colors.deepOrange,
                            minHeight: 8,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: stages.map((s) {
                              final idx = stages.indexOf(s);
                              return Text(
                                s,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: idx == stageIndex
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: idx <= stageIndex
                                      ? Colors.deepOrange
                                      : Colors.grey,
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 12),

                          // Bottom timed bar with icon
                          Row(
                            children: [
                              Icon(
                                stageIndex == 0
                                    ? Icons.inventory
                                    : stageIndex == 1
                                    ? Icons.local_shipping
                                    : stageIndex == 2
                                    ? Icons.directions_car
                                    : Icons.check_circle,
                                color: stageIndex == stages.length - 1
                                    ? Colors.green
                                    : Colors.deepOrange,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: LinearProgressIndicator(
                                  value: _subProgress,
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
                  ),
                );
              },
            ),
    );
  }
}
