import 'package:flutter/material.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';
import '../models/models.dart';
import '../data/sample.dart';

class _CatStat {
  final CategoryDef c;
  final int cur, prev;
  _CatStat(this.c, this.cur, this.prev);
}

class ReportScreen extends StatelessWidget {
  final VoidCallback? onBack;
  const ReportScreen({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    final t = AppTheme.of(context);
    final stats = <_CatStat>[
      _CatStat(catById['food']!,    187200, 215000),
      _CatStat(catById['home']!,    380000, 380000),
      _CatStat(catById['cafe']!,    14700,  38200),
      _CatStat(catById['transit']!, 12300,  8500),
      _CatStat(catById['leisure']!, 17000,  32000),
      _CatStat(catById['goods']!,   17500,  11000),
    ];
    final total = stats.fold<int>(0, (s, c) => s + c.cur);
    final prevTotal = stats.fold<int>(0, (s, c) => s + c.prev);
    final diff = total - prevTotal;

    return AppScreen(
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(onTap: onBack, child: Icon(Icons.chevron_left, size: 28, color: t.text)),
              Text('4월 리포트', style: ts(16, w: FontWeight.w700, c: t.text)),
              Icon(Icons.share_outlined, size: 20, color: t.text),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            // 히어로
            AppCard(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [Color(0xFFFFF1E0), Color(0xFFFFE0CA)],
                ),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('🎉', style: TextStyle(fontSize: 40)),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    style: ts(22, w: FontWeight.w800, c: const Color(0xFF2A2118), height: 1.3, letterSpacing: -0.5),
                    children: const [
                      TextSpan(text: '지난달보다\n'),
                      TextSpan(text: '₩47,800 절약', style: TextStyle(color: Color(0xFF6FA876))),
                      TextSpan(text: '했어요'),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text('카페·여가에서 가장 많이 줄였습니다',
                  style: ts(13, w: FontWeight.w600, c: const Color(0xFF7A6B58))),
              ]),
            ),
            const SizedBox(height: 16),

            // 총액 비교
            AppCard(
              padding: const EdgeInsets.all(20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Text('총 지출 비교', style: ts(12, w: FontWeight.w700, c: t.textSec)),
                const SizedBox(height: 14),
                Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Expanded(child: Column(children: [
                    Text('3월', style: ts(11, w: FontWeight.w600, c: t.textSec)),
                    const SizedBox(height: 6),
                    Container(height: 60, decoration: BoxDecoration(color: t.lineStrong, borderRadius: BorderRadius.circular(8))),
                    const SizedBox(height: 6),
                    Text(fmt(prevTotal), style: ts(14, w: FontWeight.w800, c: t.text)),
                  ])),
                  const SizedBox(width: 14),
                  Expanded(child: Column(children: [
                    Text('4월', style: ts(11, w: FontWeight.w700, c: t.primary)),
                    const SizedBox(height: 6),
                    Container(
                      height: 60,
                      decoration: BoxDecoration(color: t.surfaceAlt, borderRadius: BorderRadius.circular(8)),
                      alignment: Alignment.bottomCenter,
                      child: FractionallySizedBox(
                        heightFactor: total / prevTotal,
                        widthFactor: 1,
                        child: Container(decoration: BoxDecoration(color: t.primary, borderRadius: BorderRadius.circular(8))),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(fmt(total), style: ts(14, w: FontWeight.w800, c: t.text)),
                  ])),
                  const SizedBox(width: 14),
                  Expanded(
                    flex: 0,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 70),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: t.positiveSoft, borderRadius: BorderRadius.circular(12)),
                        child: Column(mainAxisSize: MainAxisSize.min, children: [
                          Icon(Icons.arrow_downward, size: 18, color: t.positive),
                          const SizedBox(height: 4),
                          Text('${(diff.abs() / prevTotal * 100).round()}%',
                            style: ts(16, w: FontWeight.w800, c: t.positive)),
                          const SizedBox(height: 2),
                          Text('절약', style: ts(10, w: FontWeight.w700, c: t.positive)),
                        ]),
                      ),
                    ),
                  ),
                ]),
              ]),
            ),
            const SizedBox(height: 14),

            // 카테고리별 증감
            AppCard(
              padding: const EdgeInsets.all(20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Text('카테고리별 증감', style: ts(14, w: FontWeight.w700, c: t.text)),
                const SizedBox(height: 14),
                ...stats.map((s) {
                  final d = s.cur - s.prev;
                  final pct = s.prev > 0 ? (d / s.prev * 100).round() : 0;
                  final up = d > 0;
                  final eq = d == 0;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Row(children: [
                      CatIcon(category: s.c, size: 32),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(s.c.name, style: ts(13, w: FontWeight.w700, c: t.text)),
                        Text(fmt(s.cur), style: ts(11, c: t.textSec)),
                      ])),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: eq ? t.surfaceAlt : (up ? t.negativeSoft : t.positiveSoft),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          if (!eq) Icon(up ? Icons.arrow_upward : Icons.arrow_downward, size: 12,
                            color: up ? t.negative : t.positive),
                          if (!eq) const SizedBox(width: 2),
                          Text(eq ? '동일' : '${pct.abs()}%',
                            style: ts(12, w: FontWeight.w800, c: eq ? t.textSec : (up ? t.negative : t.positive))),
                        ]),
                      ),
                    ]),
                  );
                }),
              ]),
            ),
            const SizedBox(height: 14),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: t.surfaceAlt,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: t.lineStrong, style: BorderStyle.solid),
              ),
              child: Text('AdMob 전면 광고 (월 1회 진입 시)',
                style: TextStyle(color: t.textTer, fontSize: 12, fontFamily: 'monospace')),
            ),
          ]),
        ),
      ]),
    );
  }
}
