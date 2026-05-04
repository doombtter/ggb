import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';
import '../data/sample.dart';

class VariableDialogScreen extends StatelessWidget {
  final VoidCallback? onClose;
  final VoidCallback? onSave;
  final VoidCallback? onSkip;
  const VariableDialogScreen({super.key, this.onClose, this.onSave, this.onSkip});

  @override
  Widget build(BuildContext context) {
    final t = AppTheme.of(context);
    final cat = catById['utility']!;

    return AppScreen(
      scrollable: false,
      child: Stack(children: [
        // 백드롭
        Positioned.fill(child: Container(color: t.dark ? const Color(0xFF0A0805) : const Color(0xFFFFFAF2))),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(color: Colors.black.withOpacity(0.45)),
          ),
        ),

        // 다이얼로그 (바닥 시트)
        Positioned(
          left: 16, right: 16, bottom: 30,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: t.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 60, offset: const Offset(0, 20))],
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
              // 핸들
              Center(child: Container(
                width: 36, height: 4,
                decoration: BoxDecoration(color: t.line, borderRadius: BorderRadius.circular(2)),
              )),
              const SizedBox(height: 16),

              Row(children: [
                CatIcon(category: cat, size: 48),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('📬 변동 지출 알림', style: ts(11, w: FontWeight.w700, c: t.primary)),
                  const SizedBox(height: 2),
                  Text('전기세 입력', style: ts(18, w: FontWeight.w800, c: t.text)),
                  const SizedBox(height: 2),
                  Text('예상일: 5월 18일 · 평균 ₩48,000', style: ts(11, c: t.textSec)),
                ])),
              ]),
              const SizedBox(height: 18),

              // 큰 입력
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                decoration: BoxDecoration(
                  color: t.surfaceAlt,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(children: [
                  Text('이번 달 금액', style: ts(11, w: FontWeight.w700, c: t.textSec)),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('₩52,400', style: ts(40, w: FontWeight.w800, c: t.text, letterSpacing: -1.5)),
                      const SizedBox(width: 4),
                      Container(width: 2, height: 36, color: t.primary),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('평균보다 ₩4,400 많음', style: ts(11, w: FontWeight.w700, c: t.positive)),
                ]),
              ),
              const SizedBox(height: 14),

              // 빠른 금액
              Row(children: ['40,000', '45,000', '48,000', '52,000'].map((v) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: t.surfaceAlt,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: t.line),
                    ),
                    child: Text(v, style: ts(12, w: FontWeight.w700, c: t.text)),
                  ),
                ),
              )).toList()),
              const SizedBox(height: 16),

              Row(children: [
                Expanded(
                  child: GestureDetector(
                    onTap: onSkip,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: t.surfaceAlt,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: t.line),
                      ),
                      child: Text('이번 달 스킵', style: ts(14, w: FontWeight.w700, c: t.textSec)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: onSave,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: t.primary, borderRadius: BorderRadius.circular(14)),
                      child: Text('저장', style: ts(15, w: FontWeight.w700, c: Colors.white)),
                    ),
                  ),
                ),
              ]),
            ]),
          ),
        ),
      ]),
    );
  }
}
