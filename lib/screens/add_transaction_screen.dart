import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../models/transaction.dart';
import '../providers/transaction_provider.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  ConsumerState<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  TxType _type = TxType.expense;
  String _category = expenseCategories.first.name;
  DateTime _date = DateTime.now();

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  List<Category> get _categories =>
      _type == TxType.income ? incomeCategories : expenseCategories;

  void _submit() {
    final title = _titleController.text.trim();
    final amount = double.tryParse(_amountController.text.trim());
    if (title.isEmpty || amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid title and amount')),
      );
      return;
    }
    ref.read(transactionProvider.notifier).add(
          title: title,
          amount: amount,
          category: _category,
          type: _type,
          date: _date,
        );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Transaction')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Expanded(child: _TypeButton(
                    label: 'Expense',
                    selected: _type == TxType.expense,
                    color: AppColors.red,
                    onTap: () => setState(() {
                      _type = TxType.expense;
                      _category = expenseCategories.first.name;
                    }),
                  )),
                  Expanded(child: _TypeButton(
                    label: 'Income',
                    selected: _type == TxType.income,
                    color: AppColors.green,
                    onTap: () => setState(() {
                      _type = TxType.income;
                      _category = incomeCategories.first.name;
                    }),
                  )),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('Title', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.dark)),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(hintText: 'e.g. Groceries'),
            ),
            const SizedBox(height: 16),
            const Text('Amount', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.dark)),
            const SizedBox(height: 8),
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(hintText: '0.00', prefixText: '\$ '),
            ),
            const SizedBox(height: 16),
            const Text('Category', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.dark)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _categories.map((c) {
                final selected = c.name == _category;
                return GestureDetector(
                  onTap: () => setState(() => _category = c.name),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: selected ? c.color : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(c.icon, size: 16, color: selected ? Colors.white : c.color),
                        const SizedBox(width: 6),
                        Text(c.name,
                            style: TextStyle(
                                color: selected ? Colors.white : AppColors.dark,
                                fontSize: 13,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text('Date', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.dark)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (picked != null) setState(() => _date = picked);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16, color: AppColors.grey),
                    const SizedBox(width: 10),
                    Text('${_date.day}/${_date.month}/${_date.year}',
                        style: const TextStyle(color: AppColors.dark)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                child: const Text('Save Transaction'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeButton extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _TypeButton({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
