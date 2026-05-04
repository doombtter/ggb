import 'package:flutter/material.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';
import '../data/sample.dart';

class OCRScreen extends StatelessWidget {
  final VoidCallback? onBack;
  final VoidCallback? onSave;
  const OCRScreen({super.key, this.onBack, this.onSave});

  @override
  Widget build(BuildContext context) {
    final t = AppTheme.of(context);
    final cat = catById['food']!;
    return AppScreen(
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(onTap: onBack, child: Icon(Icons.chevron_left, size: 28, color: t.text)),
              Text('영수증 확인', style: ts(16, w: FontWeight.w700, c: t.text)),
              GestureDetector(onTap: onSave, child: Text('저장', style: ts(14, w: FontWeight.w700, c: t.primary))),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            // 미리보기 + 인식 안내
            Container(
              height: 160,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: t.surfaceAlt,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: t.line),
              ),
              child: Row(children: [
                Container(
                  width: 100, height: 130,
                  padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: t.lineStrong),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2))],
                  ),
                  child: DefaultTextStyle(
                    style: TextStyle(fontSize: 7, fontFamily: 'monospace', color: t.textSec, height: 1.6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('이마트 양재점', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 8, color: t.textSec)),
                        const Text('2026.05.04'),
                        const Text('───────'),
                        const Text('우유 4,500'),
                        const Text('계란 6,800'),
                        const Text('샐러드 8,900'),
                        const Text('...'),
                        const Text('───────'),
                        Text('합계 47,200', style: TextStyle(fontWeight: FontWeight.w700, color: t.textSec)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: t.positiveSoft, borderRadius: BorderRadius.circular(999)),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.check, size: 12, color: t.positive),
                      const SizedBox(width: 4),
                      Text('인식 완료', style: ts(11, w: FontWeight.w700, c: t.positive)),
                    ]),
                  ),
                  const SizedBox(height: 8),
                  Text('결제 정보를 자동으로 채웠어요. 잘못된 부분은 수정해주세요.',
                    style: ts(13, c: t.textSec, height: 1.5)),
                ])),
              ]),
            ),
            const SizedBox(height: 14),

            // 입력 필드
            Container(
              decoration: BoxDecoration(
                color: t.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: t.line),
              ),
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(children: [
                FieldRow(label: '금액', value: Text('₩47,200', style: ts(28, w: FontWeight.w800, c: t.primary))),
                FieldRow(label: '가맹점', value: const Text('이마트 양재점')),
                FieldRow(label: '결제일시', value: const Text('2026.05.04 (토) 18:42')),
                FieldRow(label: '카테고리', value: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(cat.emoji, style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text(cat.name, style: ts(15, w: FontWeight.w700, c: t.text)),
                ])),
                FieldRow(label: '결제자', value: Row(mainAxisSize: MainAxisSize.min, children: [
                  Avatar(member: members[0], size: 26),
                  const SizedBox(width: 8),
                  Text(members[0].nickname, style: ts(15, w: FontWeight.w700, c: t.text)),
                ]), last: true),
              ]),
            ),
            const SizedBox(height: 14),

            // 메모
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: t.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: t.line),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('메모 (선택)', style: ts(12, w: FontWeight.w600, c: t.textSec)),
                const SizedBox(height: 6),
                Text('주말 장보기', style: ts(14, c: t.text)),
              ]),
            ),
            const SizedBox(height: 18),

            // 카테고리 빠른 선택
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text('다른 카테고리로 변경', style: ts(12, w: FontWeight.w600, c: t.textSec)),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: categories.take(8).map((c) {
                final on = c.id == 'food';
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: on ? t.primary : t.surface,
                    borderRadius: BorderRadius.circular(999),
                    border: on ? null : Border.all(color: t.line),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text(c.emoji, style: const TextStyle(fontSize: 12)),
                    const SizedBox(width: 4),
                    Text(c.name, style: ts(12, w: FontWeight.w600, c: on ? Colors.white : t.text)),
                  ]),
                );
              }).toList(),
            ),
          ]),
        ),
      ]),
    );
  }
}
