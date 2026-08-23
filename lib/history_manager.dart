import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HistoryManager {
  static const String _historyKey = "order_history";

  static Future<void> addToHistory(Map<String, dynamic> order) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_historyKey) ?? [];
    history.add(jsonEncode(order));
    await prefs.setStringList(_historyKey, history);
  }

  static Future<List<Map<String, dynamic>>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_historyKey) ?? [];
    return history.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
  }

  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }
}
