import 'package:flutter/material.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';
import '../data/sample.dart';

class GroupScreen extends StatelessWidget {
  final VoidCallback? onBack;
  const GroupScreen({super.key, this.onBack});

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
              Text('가족 그룹', style: ts(16, w: FontWeight.w700, c: t.text)),
              const SizedBox(width: 24),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            // 그룹 카드
            AppCard(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                  colors: [t.primary, t.primaryDark],
                ),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('우리 가족', style: ts(11, w: FontWeight.w700, c: Colors.white.withOpacity(0.9))),
                const SizedBox(height: 4),
                Text('김씨네 가족', style: ts(22, w: FontWeight.w800, c: Colors.white)),
                const SizedBox(height: 4),
                Text('2025년 12월부터 함께 · 152일째', style: ts(12, c: Colors.white.withOpacity(0.85))),
              ]),
            ),
            const SizedBox(height: 16),

            // 초대 코드
            AppCard(
              padding: const EdgeInsets.all(20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Text('초대 코드', style: ts(12, w: FontWeight.w700, c: t.textSec)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  decoration: BoxDecoration(
                    color: t.surfaceAlt,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: t.lineStrong, width: 2, style: BorderStyle.solid),
                  ),
                  child: Column(children: [
                    Text('K7M2P9', style: TextStyle(
                      fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: 8,
                      color: t.primary, fontFamily: 'monospace',
                    )),
                    const SizedBox(height: 6),
                    Text('가족에게 코드를 공유하세요', style: ts(11, c: t.textSec)),
                  ]),
                ),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: t.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: t.line),
                    ),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.check, size: 14, color: t.text),
                      const SizedBox(width: 6),
                      Text('복사', style: ts(13, w: FontWeight.w700, c: t.text)),
                    ]),
                  )),
                  const SizedBox(width: 10),
                  Expanded(child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: t.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Icon(Icons.share_outlined, size: 14, color: Colors.white),
                      const SizedBox(width: 6),
                      Text('카카오톡 공유', style: ts(13, w: FontWeight.w700, c: Colors.white)),
                    ]),
                  )),
                ]),
              ]),
            ),
            const SizedBox(height: 16),

            // 멤버 리스트
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 4, 10),
              child: Text('멤버 (${members.length}/6)', style: ts(12, w: FontWeight.w700, c: t.textSec)),
            ),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: List.generate(members.length, (i) {
                  final m = members[i];
                  final last = i == members.length - 1;
                  final amounts = [287000, 165700, 64000];
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      border: last ? null : Border(bottom: BorderSide(color: t.line, width: 0.5)),
                    ),
                    child: Row(children: [
                      Avatar(member: m, size: 42, ring: true),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          Text(m.nickname, style: ts(14, w: FontWeight.w700, c: t.text)),
                          if (i == 0) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: t.primarySoft, borderRadius: BorderRadius.circular(4)),
                              child: Text('나', style: ts(10, w: FontWeight.w700, c: t.primary)),
                            ),
                          ],
                        ]),
                        const SizedBox(height: 2),
                        Text(i == 0 ? '그룹 생성자' : '${i * 45}일째 함께', style: ts(11, c: t.textSec)),
                      ])),
                      Text('이달 ${fmt(amounts[i])}', style: ts(11, c: t.textSec)),
                    ]),
                  );
                }),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}
