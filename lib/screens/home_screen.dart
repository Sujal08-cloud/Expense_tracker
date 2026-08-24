import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../providers/transaction_provider.dart';
import '../widgets/balance_card.dart';
import '../widgets/transaction_tile.dart';
import '../widgets/monthly_summary.dart';
import 'add_transaction_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(transactionProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Expense Tracker')),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const BalanceCard(),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Expanded(child: _TabButton(
                    label: 'Transactions',
                    selected: _tab == 0,
                    onTap: () => setState(() => _tab = 0),
                  )),
                  Expanded(child: _TabButton(
                    label: 'Summary',
                    selected: _tab == 1,
                    onTap: () => setState(() => _tab = 1),
                  )),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (_tab == 0)
              if (transactions.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 60),
                  child: Center(
                    child: Text('No transactions yet',
                        style: TextStyle(color: AppColors.grey)),
                  ),
                )
              else
                ...transactions.map((tx) => TransactionTile(
                      tx: tx,
                      onDismiss: () =>
                          ref.read(transactionProvider.notifier).remove(tx.id),
                    ))
            else
              const MonthlySummary(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabButton({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.brown : Colors.transparent,
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
