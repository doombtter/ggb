import 'package:flutter/material.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';
import '../data/sample.dart';

class ManualScreen extends StatelessWidget {
  final VoidCallback? onBack;
  final VoidCallback? onSave;
  const ManualScreen({super.key, this.onBack, this.onSave});

  @override
  Widget build(BuildContext context) {
    final t = AppTheme.of(context);
    final cat = catById['food']!;

    Widget key_(String label, {bool big = false}) => Expanded(
      flex: big ? 2 : 1,
      child: Container(
        height: 56,
        margin: const EdgeInsets.all(4),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: t.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: t.line),
        ),
        child: Text(label, style: ts(24, w: FontWeight.w600, c: t.text)),
      ),
    );

    return AppScreen(
      scrollable: false,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(onTap: onBack, child: Icon(Icons.chevron_left, size: 28, color: t.text)),
              Text('수동 입력', style: ts(16, w: FontWeight.w700, c: t.text)),
              const SizedBox(width: 24),
            ],
          ),
        ),

        // 큰 금액
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(children: [
            Text('지출 금액', style: ts(13, w: FontWeight.w600, c: t.textSec)),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('₩28,000', style: ts(56, w: FontWeight.w800, c: t.text, letterSpacing: -2)),
                const SizedBox(width: 4),
                Container(width: 2, height: 48, color: t.primary),
              ],
            ),
          ]),
        ),

        // 칩들
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: t.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: t.line),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    CatIcon(category: cat, size: 32),
                    const SizedBox(width: 10),
                    Text(cat.name, style: ts(14, w: FontWeight.w700, c: t.text)),
                  ]),
                  Icon(Icons.chevron_right, size: 16, color: t.textTer),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: t.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: t.line),
                ),
                child: Row(children: [
                  Icon(Icons.calendar_today_outlined, size: 18, color: t.textSec),
                  const SizedBox(width: 8),
                  Text('오늘', style: ts(13, w: FontWeight.w600, c: t.text)),
                ]),
              )),
              const SizedBox(width: 8),
              Expanded(child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: t.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: t.line),
                ),
                child: Row(children: [
                  Avatar(member: members[0], size: 20),
                  const SizedBox(width: 8),
                  Text(members[0].nickname, style: ts(13, w: FontWeight.w600, c: t.text)),
                ]),
              )),
            ]),
          ]),
        ),
        const SizedBox(height: 12),

        // 키패드
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(children: [
            Row(children: [for (final k in ['1','2','3']) key_(k)]),
            Row(children: [for (final k in ['4','5','6']) key_(k)]),
            Row(children: [for (final k in ['7','8','9']) key_(k)]),
            Row(children: [key_('00'), key_('0'), key_('⌫')]),
          ]),
        ),
        const Spacer(),

        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
          child: PrimaryBtn(text: '저장', onTap: onSave),
        ),
      ]),
    );
  }
}
