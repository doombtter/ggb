import 'package:flutter/material.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';
import '../models/models.dart';
import '../data/sample.dart';

class HomeScreen extends StatelessWidget {
  final void Function(String tabId)? onTab;
  final VoidCallback? onFab;
  const HomeScreen({super.key, this.onTab, this.onFab});

  @override
  Widget build(BuildContext context) {
    final t = AppTheme.of(context);

    final byCat = <String, int>{};
    for (final tx in transactions) {
      if (!tx.date.startsWith('2026-05')) continue;
      byCat[tx.category] = (byCat[tx.category] ?? 0) + tx.amount;
    }
    final catData = byCat.entries
        .map((e) => MapEntry(catById[e.key]!, e.value))
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final total = catData.fold<int>(0, (s, e) => s + e.value);

    final byMem = <String, int>{};
    for (final tx in transactions) {
      if (!tx.date.startsWith('2026-05')) continue;
      byMem[tx.paidBy] = (byMem[tx.paidBy] ?? 0) + tx.amount;
    }
    final memData = members.where((m) => byMem.containsKey(m.id)).map((m) =>
      HBarItem(
        label: m.nickname,
        value: byMem[m.id]!,
        color: m.color,
        icon: Avatar(member: m, size: 28),
      ),
    ).toList();

    final recent = transactions.take(5).toList();

    return AppScreen(
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Stack(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('김씨네 가족 · 5월', style: ts(13, w: FontWeight.w600, c: t.textSec)),
                      const SizedBox(height: 2),
                      Text('이번 달 가계부', style: ts(26, w: FontWeight.w800, c: t.text, letterSpacing: -0.5)),
                    ],
                  ),
                ),
                Container(
                  width: 40, height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: t.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: t.line),
                  ),
                  child: Icon(Icons.notifications_outlined, size: 20, color: t.text),
                ),
              ],
            ),
          ),
        ]),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 130),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            // 총액 카드 (그라디언트)
            AppCard(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [t.primary, t.primaryDark],
                ),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('이번 달 총 지출', style: ts(13, w: FontWeight.w600, c: Colors.white.withOpacity(0.9))),
                        const SizedBox(height: 4),
                        Text(fmt(total), style: ts(34, w: FontWeight.w800, c: Colors.white, letterSpacing: -1)),
                        const SizedBox(height: 6),
                        Row(mainAxisSize: MainAxisSize.min, children: [
                          const Icon(Icons.arrow_downward, size: 13, color: Colors.white),
                          const SizedBox(width: 4),
                          Text('전월 대비 12% 절약 중', style: ts(12, c: Colors.white.withOpacity(0.85))),
                        ]),
                      ]),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.22),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text('5월 4일', style: ts(11, w: FontWeight.w700, c: Colors.white)),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('예산 ₩1,200,000 중', style: ts(11, c: Colors.white.withOpacity(0.9))),
                    Text('${(total / 1200000 * 100).round()}%', style: ts(11, c: Colors.white.withOpacity(0.9))),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: Stack(children: [
                    Container(height: 6, color: Colors.white.withOpacity(0.25)),
                    FractionallySizedBox(
                      widthFactor: (total / 1200000).clamp(0.0, 1.0),
                      child: Container(height: 6, color: Colors.white),
                    ),
                  ]),
                ),
              ]),
            ),
            const SizedBox(height: 14),

            // 도넛 + 카테고리 5개
            AppCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('카테고리별', style: ts(15, w: FontWeight.w700, c: t.text)),
                    Row(children: [
                      Text('자세히', style: ts(12, c: t.textSec)),
                      Icon(Icons.chevron_right, size: 14, color: t.textSec),
                    ]),
                  ],
                ),
                const SizedBox(height: 12),
                Row(children: [
                  Donut(
                    data: catData.map((e) => DonutSegment(e.value.toDouble(), e.key.color)).toList(),
                    size: 140, thickness: 22,
                    centerLabel: '전체',
                    centerValue: fmtShort(total),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: catData.take(5).map((e) {
                        final c = e.key;
                        final pct = (e.value / total * 100).round();
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(children: [
                            Container(width: 8, height: 8, decoration: BoxDecoration(color: c.color, borderRadius: BorderRadius.circular(2))),
                            const SizedBox(width: 8),
                            Expanded(child: Text('${c.emoji} ${c.name}', style: ts(12, c: t.textSec))),
                            Text('$pct%', style: ts(12, w: FontWeight.w700, c: t.text)),
                          ]),
                        );
                      }).toList(),
                    ),
                  ),
                ]),
              ]),
            ),
            const SizedBox(height: 14),

            // 멤버별
            AppCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('가족별 지출', style: ts(15, w: FontWeight.w700, c: t.text)),
                    Text('3명', style: ts(12, c: t.textSec)),
                  ],
                ),
                const SizedBox(height: 14),
                HBars(data: memData),
              ]),
            ),
            const SizedBox(height: 14),

            // 최근 거래
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('최근 거래', style: ts(15, w: FontWeight.w700, c: t.text)),
                      Text('전체보기', style: ts(12, w: FontWeight.w600, c: t.primary)),
                    ],
                  ),
                ),
                ...recent.asMap().entries.map((entry) {
                  final i = entry.key;
                  final tx = entry.value;
                  final c = catById[tx.category]!;
                  final m = memberById(tx.paidBy);
                  return Container(
                    decoration: BoxDecoration(border: i == 0 ? null : Border(top: BorderSide(color: t.line, width: 0.5))),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    child: Row(children: [
                      CatIcon(category: c, size: 38),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(tx.merchant, style: ts(14, w: FontWeight.w600, c: t.text), overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 2),
                          Row(children: [
                            Text('${m.emoji} ${m.nickname}', style: ts(11, c: t.textSec)),
                            const SizedBox(width: 5),
                            const Dot(),
                            const SizedBox(width: 5),
                            Text(tx.date.substring(5).replaceAll('-', '.'), style: ts(11, c: t.textSec)),
                            if (tx.source == TxSource.fixedRecurring) ...[
                              const SizedBox(width: 5),
                              const Dot(),
                              const SizedBox(width: 5),
                              Text('고정', style: ts(11, w: FontWeight.w700, c: t.primary)),
                            ],
                          ]),
                        ]),
                      ),
                      Text('-${fmt(tx.amount)}', style: ts(15, w: FontWeight.w800, c: t.text)),
                    ]),
                  );
                }),
                const SizedBox(height: 10),
              ]),
            ),
            const SizedBox(height: 14),

            // AdMob placeholder
            Container(
              height: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: t.surfaceAlt,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: t.lineStrong, style: BorderStyle.solid),
              ),
              child: Text('AdMob 배너 320×50',
                style: TextStyle(color: t.textTer, fontSize: 12, fontFamily: 'monospace')),
            ),
          ]),
        ),
      ]),
    );
  }
}

class HomeScaffold extends StatelessWidget {
  final void Function(String tabId)? onTab;
  final VoidCallback? onFab;
  const HomeScaffold({super.key, this.onTab, this.onFab});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      HomeScreen(onTab: onTab, onFab: onFab),
      FabButton(onTap: onFab),
      AppTabBar(active: 'home', onTap: onTab),
    ]);
  }
}
