import 'package:supabase_flutter/supabase_flutter.dart';

class HistoryManager {
  static final supabase = Supabase.instance.client;

  static Future<void> addToHistory(Map<String, dynamic> order) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    await supabase.from('order_history').insert({'user_id': userId, ...order});
  }

  static Future<List<Map<String, dynamic>>> loadHistory() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await supabase
        .from('order_history')
        .select(
          'id, product_name, image_url, description, price, old_price, category, quantity, payment_mode, created_at',
        )
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  static Future<void> clearHistory() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    await supabase.from('order_history').delete().eq('user_id', userId);
  }

  /// Real-time stream of history changes
  static Stream<List<Map<String, dynamic>>> historyStream() {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return const Stream.empty();

    return supabase
        .from('order_history')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at')
        .map((rows) => List<Map<String, dynamic>>.from(rows));
  }
}
