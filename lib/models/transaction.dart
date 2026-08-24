import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum TxType { income, expense }

class Category {
  final String name;
  final IconData icon;
  final Color color;
  const Category(this.name, this.icon, this.color);
}

const expenseCategories = [
  Category('Food', Icons.restaurant, AppColors.brown),
  Category('Transport', Icons.directions_car, AppColors.blue),
  Category('Shopping', Icons.shopping_bag, AppColors.pink),
  Category('Bills', Icons.receipt_long, AppColors.lightBrown),
  Category('Health', Icons.favorite, AppColors.red),
  Category('Entertainment', Icons.movie, AppColors.grey),
  Category('Other', Icons.category, AppColors.dark),
];

const incomeCategories = [
  Category('Salary', Icons.work, AppColors.green),
  Category('Business', Icons.storefront, AppColors.blue),
  Category('Gift', Icons.card_giftcard, AppColors.pink),
  Category('Investment', Icons.trending_up, AppColors.brown),
  Category('Other', Icons.category, AppColors.dark),
];

Category categoryFor(String name, TxType type) {
  final list = type == TxType.income ? incomeCategories : expenseCategories;
  return list.firstWhere((c) => c.name == name, orElse: () => list.last);
}

class Transaction {
  final String id;
  final String title;
  final double amount;
  final String category;
  final TxType type;
  final DateTime date;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.type,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'amount': amount,
        'category': category,
        'type': type.name,
        'date': date.toIso8601String(),
      };

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json['id'],
        title: json['title'],
        amount: (json['amount'] as num).toDouble(),
        category: json['category'],
        type: json['type'] == 'income' ? TxType.income : TxType.expense,
        date: DateTime.parse(json['date']),
      );
}
