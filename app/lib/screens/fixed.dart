import 'package:flutter/material.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';
import '../models/models.dart';
import '../data/sample.dart';

class FixedScreen extends StatelessWidget {
  final void Function(String)? onTab;
  final VoidCallback? onAdd;
  const FixedScreen({super.key, this.onTab, this.onAdd});

  @override
  Widget build(BuildContext context) {
    final t = AppTheme.of(context);
    const today = 4;

    int sortKey(FixedExpense f) => f.dayOfMonth >= today ? f.dayOfMonth : f.dayOfMonth + 31;
    final fixed = [...fixedRecurring]..sort((a, b) => sortKey(a).compareTo(sortKey(b)));
    final variable = [...fixedVariable]..sort((a, b) => sortKey(a).compareTo(sortKey(b)));

    final totalFixed = fixedRecurring.fold<int>(0, (s, r) => s + r.amount);
    final totalVariable = fixedVariable.fold<int>(0, (s, r) => s + r.amount);

    Widget tab(String label, int count, {bool active = false}) => Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: active ? t.primary : Colors.transparent, width: 2)),
        ),
        alignment: Alignment.center,
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(label, style: ts(14, w: FontWeight.w700, c: active ? t.primary : t.textSec)),
          const SizedBox(width: 4),
          Text('$count', style: ts(14, w: FontWeight.w600, c: (active ? t.primary : t.textSec).withOpacity(0.7))),
        ]),
      ),
    );

    Widget recurRow(FixedExpense r, {bool isVar = false}) {
      final c = catById[r.category]!;
      final m = memberById(r.paidBy);
      final daysLeft = r.dayOfMonth >= today ? r.dayOfMonth - today : (31 - today + r.dayOfMonth);
      final isToday = daysLeft == 0;
      final soon = daysLeft <= 3;

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: t.line, width: 0.5))),
        child: Row(children: [
          CatIcon(category: c, size: 42),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(r.name, style: ts(15, w: FontWeight.w700, c: t.text)),
              if (isVar) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: t.primarySoft, borderRadius: BorderRadius.circular(4)),
                  child: Text('변동', style: ts(9, w: FontWeight.w700, c: t.primary)),
                ),
              ],
            ]),
            const SizedBox(height: 3),
            Row(children: [
              Text('${m.emoji} ${m.nickname}', style: ts(11, c: t.textSec)),
              const SizedBox(width: 5),
              const Dot(),
              const SizedBox(width: 5),
              Text('매월 ${r.dayOfMonth}일', style: ts(11, c: t.textSec)),
            ]),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Row(children: [
              if (isVar) Text('평균 ', style: ts(9, w: FontWeight.w600, c: t.textSec)),
              Text(fmt(r.amount), style: ts(14, w: FontWeight.w800, c: t.text)),
            ]),
            const SizedBox(height: 3),
            Text(
              isToday ? '오늘 결제' : 'D-$daysLeft',
              style: ts(10, w: FontWeight.w700, c: isToday ? t.negative : (soon ? t.primary : t.textSec)),
            ),
          ]),
        ]),
      );
    }

    return Stack(children: [
      AppScreen(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('매달 빠져나가는', style: ts(13, w: FontWeight.w600, c: t.textSec)),
                  Text('고정 지출', style: ts(26, w: FontWeight.w800, c: t.text, letterSpacing: -0.5)),
                ])),
                GestureDetector(
                  onTap: onAdd,
                  child: Container(
                    width: 36, height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: t.primary, shape: BoxShape.circle),
                    child: const Icon(Icons.add, size: 20, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          // 합계 두 카드
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
            child: Row(children: [
              Expanded(child: AppCard(
                padding: const EdgeInsets.all(14),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('정액 (자동)', style: ts(11, w: FontWeight.w700, c: t.textSec)),
                  const SizedBox(height: 4),
                  Text(fmt(totalFixed), style: ts(18, w: FontWeight.w800, c: t.text)),
                ]),
              )),
              const SizedBox(width: 10),
              Expanded(child: AppCard(
                padding: const EdgeInsets.all(14),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('변동 (알림)', style: ts(11, w: FontWeight.w700, c: t.textSec)),
                  const SizedBox(height: 4),
                  Text('~${fmt(totalVariable)}', style: ts(18, w: FontWeight.w800, c: t.text)),
                ]),
              )),
            ]),
          ),

          // 탭
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: t.line))),
            child: Row(children: [
              tab('정액형', fixed.length, active: true),
              tab('변동형', variable.length),
            ]),
          ),

          // 리스트
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 100),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(children: fixed.map((r) => recurRow(r)).toList()),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(4, 20, 4, 10),
                child: Text('📌 변동형 미리보기'),
              ),
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(children: variable.take(2).map((r) => recurRow(r, isVar: true)).toList()),
              ),
            ]),
          ),
        ]),
      ),
      AppTabBar(active: 'fixed', onTap: onTab),
    ]);
  }
}
