import 'package:flutter/material.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';
import '../models/models.dart';
import '../data/sample.dart';

class TxDetailScreen extends StatelessWidget {
  final Transaction tx;
  final VoidCallback? onBack;
  const TxDetailScreen({super.key, required this.tx, this.onBack});

  @override
  Widget build(BuildContext context) {
    final t = AppTheme.of(context);
    final c = catById[tx.category]!;
    final m = memberById(tx.paidBy);

    return AppScreen(
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onBack,
                child: SizedBox(width: 24, child: Icon(Icons.chevron_left, size: 28, color: t.text)),
              ),
              Text('거래 상세', style: ts(16, w: FontWeight.w700, c: t.text)),
              SizedBox(width: 24, child: Icon(Icons.edit_outlined, size: 20, color: t.text)),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            // 영수증 미리보기
            Container(
              height: 200,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: t.lineStrong),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [Color(0xFFFFFFFF), Color(0xFFF5EFE3)],
                  stops: [0.97, 1.0],
                  tileMode: TileMode.repeated,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('이마트 양재점', style: TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w700, fontSize: 13, color: t.textSec, height: 1.8)),
                  Text('2026.05.04 18:42', style: TextStyle(fontFamily: 'monospace', fontSize: 11, color: t.textSec, height: 1.8)),
                  Text('───────────', style: TextStyle(fontFamily: 'monospace', fontSize: 11, color: t.textSec, height: 1.8)),
                  Text('합계  47,200원', style: TextStyle(fontFamily: 'monospace', fontSize: 11, color: t.textSec, height: 1.8)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 큰 금액
            Center(child: Column(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: c.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(c.emoji, style: const TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  Text(c.name, style: ts(12, w: FontWeight.w700, c: t.text)),
                ]),
              ),
              const SizedBox(height: 10),
              Text('-${fmt(tx.amount)}', style: ts(40, w: FontWeight.w800, c: t.text, letterSpacing: -1)),
              const SizedBox(height: 4),
              Text(tx.merchant, style: ts(14, w: FontWeight.w600, c: t.textSec)),
            ])),
            const SizedBox(height: 24),

            AppCard(
              padding: EdgeInsets.zero,
              child: Column(children: [
                FieldRow(label: '결제일시', value: const Text('2026.05.04 (토) 18:42')),
                FieldRow(label: '결제자', value: Row(mainAxisSize: MainAxisSize.min, children: [
                  Avatar(member: m, size: 24),
                  const SizedBox(width: 8),
                  Text(m.nickname),
                ])),
                FieldRow(label: '입력방식', value: const Text('영수증 OCR')),
                FieldRow(label: '메모', value: Text(tx.memo ?? '-'), last: true),
              ]),
            ),
            const SizedBox(height: 14),

            Row(children: [
              Expanded(child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: t.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: t.line),
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.edit_outlined, size: 16, color: t.text),
                  const SizedBox(width: 6),
                  Text('수정', style: ts(14, w: FontWeight.w700, c: t.text)),
                ]),
              )),
              const SizedBox(width: 10),
              Expanded(child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: t.negativeSoft,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.delete_outline, size: 16, color: t.negative),
                  const SizedBox(width: 6),
                  Text('삭제', style: ts(14, w: FontWeight.w700, c: t.negative)),
                ]),
              )),
            ]),
          ]),
        ),
      ]),
    );
  }
}
