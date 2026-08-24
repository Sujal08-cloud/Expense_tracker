import 'package:intl/intl.dart';

String formatCurrency(double value) {
  final f = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
  return f.format(value);
}

String formatDate(DateTime date) {
  return DateFormat('MMM d, yyyy').format(date);
}

String formatMonth(DateTime date) {
  return DateFormat('MMMM yyyy').format(date);
}
