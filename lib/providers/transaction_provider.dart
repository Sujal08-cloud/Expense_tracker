import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/transaction.dart';

class TransactionNotifier extends StateNotifier<List<Transaction>> {
  TransactionNotifier() : super([]) {
    _load();
  }

  static const _key = 'transactions';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw != null) {
      final list = jsonDecode(raw) as List;
      state = list.map((e) => Transaction.fromJson(e)).toList()
        ..sort((a, b) => b.date.compareTo(a.date));
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(state.map((e) => e.toJson()).toList());
    await prefs.setString(_key, raw);
  }

  void add({
    required String title,
    required double amount,
    required String category,
    required TxType type,
    required DateTime date,
  }) {
    final tx = Transaction(
      id: const Uuid().v4(),
      title: title,
      amount: amount,
      category: category,
      type: type,
      date: date,
    );
    state = [tx, ...state]..sort((a, b) => b.date.compareTo(a.date));
    _save();
  }

  void remove(String id) {
    state = state.where((t) => t.id != id).toList();
    _save();
  }
}

final transactionProvider =
    StateNotifierProvider<TransactionNotifier, List<Transaction>>(
        (ref) => TransactionNotifier());

final totalIncomeProvider = Provider<double>((ref) {
  final txs = ref.watch(transactionProvider);
  return txs.where((t) => t.type == TxType.income).fold(0.0, (s, t) => s + t.amount);
});

final totalExpenseProvider = Provider<double>((ref) {
  final txs = ref.watch(transactionProvider);
  return txs.where((t) => t.type == TxType.expense).fold(0.0, (s, t) => s + t.amount);
});

final balanceProvider = Provider<double>((ref) {
  return ref.watch(totalIncomeProvider) - ref.watch(totalExpenseProvider);
});

final selectedMonthProvider = StateProvider<DateTime>((ref) => DateTime.now());

final monthlyTransactionsProvider = Provider<List<Transaction>>((ref) {
  final txs = ref.watch(transactionProvider);
  final month = ref.watch(selectedMonthProvider);
  return txs
      .where((t) => t.date.year == month.year && t.date.month == month.month)
      .toList();
});

final monthlyIncomeProvider = Provider<double>((ref) {
  final txs = ref.watch(monthlyTransactionsProvider);
  return txs.where((t) => t.type == TxType.income).fold(0.0, (s, t) => s + t.amount);
});

final monthlyExpenseProvider = Provider<double>((ref) {
  final txs = ref.watch(monthlyTransactionsProvider);
  return txs.where((t) => t.type == TxType.expense).fold(0.0, (s, t) => s + t.amount);
});

final categoryBreakdownProvider = Provider<Map<String, double>>((ref) {
  final txs = ref.watch(monthlyTransactionsProvider);
  final map = <String, double>{};
  for (final t in txs.where((t) => t.type == TxType.expense)) {
    map[t.category] = (map[t.category] ?? 0) + t.amount;
  }
  return map;
});
