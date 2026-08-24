import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';

class TransactionTile extends StatelessWidget {
  final Transaction tx;
  final VoidCallback onDismiss;

  const TransactionTile({super.key, required this.tx, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    final cat = categoryFor(tx.category, tx.type);
    final isIncome = tx.type == TxType.income;

    return Dismissible(
      key: Key(tx.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.red,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: cat.color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(cat.icon, color: cat.color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tx.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, color: AppColors.dark)),
                  const SizedBox(height: 2),
                  Text('${tx.category} · ${formatDate(tx.date)}',
                      style: const TextStyle(color: AppColors.grey, fontSize: 12)),
                ],
              ),
            ),
            Text(
              '${isIncome ? '+' : '-'}${formatCurrency(tx.amount)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isIncome ? AppColors.green : AppColors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
