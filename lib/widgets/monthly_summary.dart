import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../models/transaction.dart';
import '../providers/transaction_provider.dart';
import '../utils/formatters.dart';

class MonthlySummary extends ConsumerWidget {
  const MonthlySummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final month = ref.watch(selectedMonthProvider);
    final income = ref.watch(monthlyIncomeProvider);
    final expense = ref.watch(monthlyExpenseProvider);
    final breakdown = ref.watch(categoryBreakdownProvider);
    final maxVal = breakdown.values.isEmpty
        ? 1.0
        : breakdown.values.reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: AppColors.dark),
                onPressed: () {
                  ref.read(selectedMonthProvider.notifier).state =
                      DateTime(month.year, month.month - 1);
                },
              ),
              Text(formatMonth(month),
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.dark)),
              IconButton(
                icon: const Icon(Icons.chevron_right, color: AppColors.dark),
                onPressed: () {
                  ref.read(selectedMonthProvider.notifier).state =
                      DateTime(month.year, month.month + 1);
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _MiniStat(
                    label: 'Income', value: income, color: AppColors.green),
              ),
              Expanded(
                child: _MiniStat(
                    label: 'Expense', value: expense, color: AppColors.red),
              ),
              Expanded(
                child: _MiniStat(
                    label: 'Saved', value: income - expense, color: AppColors.blue),
              ),
            ],
          ),
          if (breakdown.isNotEmpty) ...[
            const SizedBox(height: 20),
            const Text('By Category',
                style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.dark)),
            const SizedBox(height: 12),
            ...breakdown.entries.map((e) {
              final cat = categoryFor(e.key, TxType.expense);
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Icon(cat.icon, size: 16, color: cat.color),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 80,
                      child: Text(e.key,
                          style: const TextStyle(fontSize: 12, color: AppColors.grey)),
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: e.value / maxVal,
                          backgroundColor: AppColors.cream,
                          color: cat.color,
                          minHeight: 8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(formatCurrency(e.value),
                        style: const TextStyle(fontSize: 12, color: AppColors.dark)),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const _MiniStat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.grey)),
        const SizedBox(height: 4),
        Text(
          formatCurrency(value),
          style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 14),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
