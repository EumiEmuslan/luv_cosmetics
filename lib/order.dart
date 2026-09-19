import 'dart:async';
import 'productmodel.dart';
import 'history_manager.dart';

class Order {
  final Product product;
  String status = stages.first;
  double subProgress = 0.0;
  Timer? stageTimer;
  Timer? subTimer;

  static const stages = [
    "Pending",
    "Picked up by courier",
    "On the way",
    "Delivered",
  ];

  Order(this.product) {
    // Stage progression every 30s
    stageTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      advanceStage();
      subProgress = 0.0;
    });

    // Sub-progress fill every second
    subTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      subProgress += 1 / 30;
      if (subProgress > 1.0) subProgress = 1.0;
    });
  }

  Future<void> advanceStage() async {
    final currentIndex = stages.indexOf(status);

    if (currentIndex < stages.length - 1) {
      status = stages[currentIndex + 1];
    }

    if (status == "Delivered") {
      await _saveToHistory();
      dispose();
    }
  }

  Future<void> _saveToHistory() async {
    try {
      await HistoryManager.addToHistory({
        'product_name': product.title,
        'image_url': product.imageUrl,
        'description': product.description,
        'price': product.price,
        'old_price': product.oldPrice,
        'category': product.category,
        'quantity': 1,
        'payment_mode': product.paymentMode ?? "Unknown",
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      // Log or handle Supabase insert error
      print("Failed to save order history: $e");
    }
  }

  void dispose() {
    stageTimer?.cancel();
    subTimer?.cancel();
  }

  int get stageIndex => stages.indexOf(status);
  double get progress => (stageIndex + 1) / stages.length;
}
