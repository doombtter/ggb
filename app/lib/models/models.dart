import 'package:flutter/material.dart';

class CategoryDef {
  final String id;
  final String name;
  final String emoji;
  final Color color;
  const CategoryDef({required this.id, required this.name, required this.emoji, required this.color});
}

class Member {
  final String id;
  final String nickname;
  final String emoji;
  final Color color;
  const Member({required this.id, required this.nickname, required this.emoji, required this.color});
}

enum TxSource { receipt, manual, fixedRecurring }

class Transaction {
  final String id;
  final String date; // yyyy-MM-dd
  final String time; // HH:mm
  final int amount;
  final String category;
  final String merchant;
  final String paidBy;
  final TxSource source;
  final String? memo;
  const Transaction({
    required this.id,
    required this.date,
    required this.time,
    required this.amount,
    required this.category,
    required this.merchant,
    required this.paidBy,
    required this.source,
    this.memo,
  });
}

enum FixedType { fixed, variable }

class FixedExpense {
  final String id;
  final String name;
  final FixedType type;
  final int amount;
  final String category;
  final String paidBy;
  final int dayOfMonth;
  final bool autoRecord;
  const FixedExpense({
    required this.id,
    required this.name,
    required this.type,
    required this.amount,
    required this.category,
    required this.paidBy,
    required this.dayOfMonth,
    this.autoRecord = false,
  });
}
