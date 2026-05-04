import 'package:flutter/material.dart';
import '../models/models.dart';

const categories = <CategoryDef>[
  CategoryDef(id: 'food',    name: '식비',         emoji: '🍚', color: Color(0xFFF4A574)),
  CategoryDef(id: 'cafe',    name: '카페/간식',    emoji: '☕', color: Color(0xFFC9B58A)),
  CategoryDef(id: 'goods',   name: '생필품',       emoji: '🛒', color: Color(0xFF7BB48E)),
  CategoryDef(id: 'transit', name: '교통',         emoji: '🚗', color: Color(0xFF7CB7C7)),
  CategoryDef(id: 'home',    name: '주거/관리비',  emoji: '🏠', color: Color(0xFFA99CD9)),
  CategoryDef(id: 'utility', name: '공과금',       emoji: '💡', color: Color(0xFFE8C376)),
  CategoryDef(id: 'telecom', name: '통신',         emoji: '📱', color: Color(0xFF8AA0C9)),
  CategoryDef(id: 'beauty',  name: '의류/미용',    emoji: '👕', color: Color(0xFFD4A5C9)),
  CategoryDef(id: 'health',  name: '의료/건강',    emoji: '🏥', color: Color(0xFFE89A9A)),
  CategoryDef(id: 'leisure', name: '문화/여가',    emoji: '🎬', color: Color(0xFF9CC5A1)),
  CategoryDef(id: 'edu',     name: '교육',         emoji: '🎓', color: Color(0xFFE8B86E)),
  CategoryDef(id: 'etc',     name: '기타',         emoji: '📦', color: Color(0xFFB5A099)),
];

final catById = {for (final c in categories) c.id: c};

const members = <Member>[
  Member(id: 'm1', nickname: '김미정', emoji: '🌷', color: Color(0xFFE87A3E)),
  Member(id: 'm2', nickname: '박준호', emoji: '🌲', color: Color(0xFF7BB48E)),
  Member(id: 'm3', nickname: '딸 서연', emoji: '🐰', color: Color(0xFFA99CD9)),
];

Member memberById(String id) => members.firstWhere((m) => m.id == id);

const transactions = <Transaction>[
  Transaction(id: 't1', date: '2026-05-04', time: '18:42', amount: 47200,  category: 'food',    merchant: '이마트 양재점',   paidBy: 'm1', source: TxSource.receipt, memo: '주말 장보기'),
  Transaction(id: 't2', date: '2026-05-04', time: '12:30', amount: 6500,   category: 'cafe',    merchant: '스타벅스 본사점', paidBy: 'm2', source: TxSource.receipt),
  Transaction(id: 't3', date: '2026-05-03', time: '20:15', amount: 28000,  category: 'food',    merchant: '교촌치킨',        paidBy: 'm1', source: TxSource.manual,  memo: '치맥'),
  Transaction(id: 't4', date: '2026-05-03', time: '14:00', amount: 12300,  category: 'transit', merchant: '카카오T',         paidBy: 'm2', source: TxSource.manual),
  Transaction(id: 't5', date: '2026-05-02', time: '09:00', amount: 17500,  category: 'goods',   merchant: '쿠팡',            paidBy: 'm1', source: TxSource.manual,  memo: '세제, 휴지'),
  Transaction(id: 't6', date: '2026-05-01', time: '00:05', amount: 17000,  category: 'leisure', merchant: '넷플릭스',        paidBy: 'm2', source: TxSource.fixedRecurring),
  Transaction(id: 't7', date: '2026-05-01', time: '00:05', amount: 380000, category: 'home',    merchant: '월세',            paidBy: 'm1', source: TxSource.fixedRecurring),
  Transaction(id: 't8', date: '2026-04-30', time: '21:30', amount: 8200,   category: 'cafe',    merchant: '투썸플레이스',     paidBy: 'm1', source: TxSource.receipt),
];

const fixedRecurring = <FixedExpense>[
  FixedExpense(id: 'r1', name: '월세',           type: FixedType.fixed, amount: 380000, category: 'home',    paidBy: 'm1', dayOfMonth: 1,  autoRecord: true),
  FixedExpense(id: 'r2', name: '넷플릭스',        type: FixedType.fixed, amount: 17000,  category: 'leisure', paidBy: 'm2', dayOfMonth: 1,  autoRecord: true),
  FixedExpense(id: 'r3', name: '실비보험',        type: FixedType.fixed, amount: 78000,  category: 'health',  paidBy: 'm1', dayOfMonth: 5,  autoRecord: true),
  FixedExpense(id: 'r4', name: '유튜브 프리미엄', type: FixedType.fixed, amount: 14900,  category: 'leisure', paidBy: 'm2', dayOfMonth: 8,  autoRecord: true),
];

const fixedVariable = <FixedExpense>[
  FixedExpense(id: 'v1', name: '관리비', type: FixedType.variable, amount: 220000, category: 'home',    paidBy: 'm1', dayOfMonth: 25),
  FixedExpense(id: 'v2', name: '전기세', type: FixedType.variable, amount: 48000,  category: 'utility', paidBy: 'm1', dayOfMonth: 18),
  FixedExpense(id: 'v3', name: '가스비', type: FixedType.variable, amount: 32000,  category: 'utility', paidBy: 'm2', dayOfMonth: 20),
  FixedExpense(id: 'v4', name: '통신비', type: FixedType.variable, amount: 95000,  category: 'telecom', paidBy: 'm2', dayOfMonth: 15),
];

String fmt(int n) {
  final s = n.toString();
  final buf = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
    buf.write(s[i]);
  }
  return '₩$buf';
}

String fmtShort(int n) {
  if (n >= 10000) {
    final v = (n / 1000).round() / 10;
    final s = v == v.toInt() ? v.toInt().toString() : v.toString();
    return '$s만';
  }
  return fmt(n).substring(1);
}
