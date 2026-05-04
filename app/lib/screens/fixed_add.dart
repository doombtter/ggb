import 'package:flutter/material.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';
import '../data/sample.dart';

class FixedAddScreen extends StatelessWidget {
  final VoidCallback? onBack;
  final VoidCallback? onDone;
  const FixedAddScreen({super.key, this.onBack, this.onDone});

  @override
  Widget build(BuildContext context) {
    final t = AppTheme.of(context);
    return AppScreen(
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(onTap: onBack, child: Icon(Icons.chevron_left, size: 28, color: t.text)),
              Text('고정 지출 등록', style: ts(16, w: FontWeight.w700, c: t.text)),
              GestureDetector(onTap: onDone, child: Text('완료', style: ts(14, w: FontWeight.w700, c: t.primary))),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            // 토글
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: t.surfaceAlt,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(children: [
                Expanded(child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: t.surface,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 3, offset: const Offset(0, 1))],
                  ),
                  child: Column(children: [
                    Text('정액형', style: ts(14, w: FontWeight.w700, c: t.text)),
                    const SizedBox(height: 2),
                    Text('매달 같은 금액', style: ts(10, w: FontWeight.w500, c: t.textSec)),
                  ]),
                )),
                Expanded(child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  alignment: Alignment.center,
                  child: Column(children: [
                    Text('변동형', style: ts(14, w: FontWeight.w600, c: t.textSec)),
                    const SizedBox(height: 2),
                    Text('금액이 달라요', style: ts(10, w: FontWeight.w500, c: t.textSec)),
                  ]),
                )),
              ]),
            ),
            const SizedBox(height: 20),

            // 필드들
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: t.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: t.line),
              ),
              child: Column(children: [
                FieldRow(label: '항목명', value: Text('넷플릭스', style: ts(15, w: FontWeight.w600, c: t.text))),
                FieldRow(label: '금액', value: Text('₩17,000', style: ts(18, w: FontWeight.w800, c: t.primary))),
                FieldRow(label: '결제일', value: const Text('매월 1일')),
                FieldRow(label: '카테고리', value: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Text('🎬', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  Text('문화/여가', style: ts(15, w: FontWeight.w700, c: t.text)),
                ])),
                FieldRow(label: '결제자', value: Row(mainAxisSize: MainAxisSize.min, children: [
                  Avatar(member: members[1], size: 22),
                  const SizedBox(width: 6),
                  Text(members[1].nickname, style: ts(15, w: FontWeight.w700, c: t.text)),
                ]), last: true),
              ]),
            ),
            const SizedBox(height: 14),

            // 자동 기록 토글
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('자동 기록', style: ts(14, w: FontWeight.w700, c: t.text)),
                    const SizedBox(height: 4),
                    Text('결제일에 자동으로 지출 내역에 추가됩니다',
                      style: ts(11, c: t.textSec, height: 1.4)),
                  ])),
                  Container(
                    width: 50, height: 30,
                    decoration: BoxDecoration(color: t.primary, borderRadius: BorderRadius.circular(15)),
                    child: Stack(children: [
                      Positioned(
                        right: 2, top: 2,
                        child: Container(
                          width: 26, height: 26,
                          decoration: BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4, offset: const Offset(0, 2))],
                          ),
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // 미리보기
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: t.primarySoft,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: t.primary, style: BorderStyle.solid),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('📅 미리보기', style: ts(11, w: FontWeight.w700, c: t.primary)),
                const SizedBox(height: 6),
                RichText(
                  text: TextSpan(
                    style: ts(13, c: t.text, height: 1.5),
                    children: [
                      const TextSpan(text: '매월 1일 0시', style: TextStyle(fontWeight: FontWeight.w800)),
                      const TextSpan(text: '에 박준호 님 명의로 ₩17,000이 자동 기록됩니다.\n다음 자동 기록: '),
                      const TextSpan(text: '2026년 6월 1일', style: TextStyle(fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
              ]),
            ),
          ]),
        ),
      ]),
    );
  }
}
