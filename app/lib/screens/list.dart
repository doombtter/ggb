import 'package:flutter/material.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';
import '../models/models.dart';
import '../data/sample.dart';

class TxListScreen extends StatelessWidget {
  final void Function(String)? onTab;
  final void Function(Transaction)? onTap;
  final VoidCallback? onFab;
  const TxListScreen({super.key, this.onTab, this.onTap, this.onFab});

  String _dayLabel(String d) {
    final dt = DateTime.parse(d);
    const days = ['월','화','수','목','금','토','일'];
    return '${dt.month}월 ${dt.day}일 (${days[dt.weekday - 1]})';
  }

  @override
  Widget build(BuildContext context) {
    final t = AppTheme.of(context);

    final grouped = <String, List<Transaction>>{};
    for (final tx in transactions) {
      grouped.putIfAbsent(tx.date, () => []).add(tx);
    }
    final dates = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return Stack(children: [
      AppScreen(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          // 헤더
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('거래 내역', style: ts(26, w: FontWeight.w800, c: t.text, letterSpacing: -0.5)),
                Row(children: [
                  _CircleBtn(icon: Icons.calendar_today_outlined),
                  const SizedBox(width: 8),
                  _CircleBtn(icon: Icons.tune),
                ]),
              ],
            ),
          ),

          // 월 + 요약
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
            child: AppCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    Icon(Icons.chevron_left, color: t.textSec, size: 18),
                    const SizedBox(width: 8),
                    Text('2026년 5월', style: ts(17, w: FontWeight.w800, c: t.text)),
                    const SizedBox(width: 8),
                    Icon(Icons.chevron_right, color: t.textSec, size: 18),
                  ]),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('총 8건', style: ts(11, w: FontWeight.w600, c: t.textSec)),
                      Text(fmt(516700), style: ts(17, w: FontWeight.w800, c: t.text)),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 필터 칩
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                AppChip(active: true, child: const Text('전체')),
                const SizedBox(width: 8),
                AppChip(child: const Text('영수증')),
                const SizedBox(width: 8),
                AppChip(child: const Text('수동')),
                const SizedBox(width: 8),
                AppChip(child: const Text('고정')),
                const SizedBox(width: 8),
                AppChip(child: const Text('식비')),
                const SizedBox(width: 8),
                AppChip(child: const Text('카페')),
              ],
            ),
          ),
          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: dates.map((d) {
                final dayTotal = grouped[d]!.fold<int>(0, (s, tx) => s + tx.amount);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_dayLabel(d), style: ts(12, w: FontWeight.w700, c: t.textSec)),
                          Text(fmt(dayTotal), style: ts(12, w: FontWeight.w700, c: t.textSec)),
                        ],
                      ),
                    ),
                    AppCard(
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: grouped[d]!.asMap().entries.map((entry) {
                          final i = entry.key;
                          final tx = entry.value;
                          final c = catById[tx.category]!;
                          final m = memberById(tx.paidBy);
                          return GestureDetector(
                            onTap: () => onTap?.call(tx),
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              decoration: BoxDecoration(border: i == 0 ? null : Border(top: BorderSide(color: t.line, width: 0.5))),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Row(children: [
                                CatIcon(category: c, size: 36),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Text(tx.merchant, style: ts(14, w: FontWeight.w700, c: t.text)),
                                    const SizedBox(height: 2),
                                    Row(children: [
                                      Text('${m.emoji} ${m.nickname}', style: ts(11, c: t.textSec)),
                                      const SizedBox(width: 5),
                                      const Dot(),
                                      const SizedBox(width: 5),
                                      Text(tx.time, style: ts(11, c: t.textSec)),
                                      if (tx.source == TxSource.fixedRecurring) ...[
                                        const SizedBox(width: 5),
                                        const Dot(),
                                        const SizedBox(width: 5),
                                        Text('고정', style: ts(11, w: FontWeight.w700, c: t.primary)),
                                      ],
                                      if (tx.source == TxSource.receipt) ...[
                                        const SizedBox(width: 5),
                                        const Dot(),
                                        const SizedBox(width: 5),
                                        Icon(Icons.receipt_long_outlined, size: 11, color: t.textSec),
                                      ],
                                    ]),
                                  ]),
                                ),
                                Text('-${fmt(tx.amount)}', style: ts(14, w: FontWeight.w800, c: t.text)),
                              ]),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ]),
                );
              }).toList(),
            ),
          ),
        ]),
      ),
      FabButton(onTap: onFab),
      AppTabBar(active: 'list', onTap: onTab),
    ]);
  }
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  const _CircleBtn({required this.icon});
  @override
  Widget build(BuildContext context) {
    final t = AppTheme.of(context);
    return Container(
      width: 36, height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: t.surface,
        shape: BoxShape.circle,
        border: Border.all(color: t.line),
      ),
      child: Icon(icon, size: 18, color: t.text),
    );
  }
}
