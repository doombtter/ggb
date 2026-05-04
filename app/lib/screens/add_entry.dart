import 'package:flutter/material.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';

class AddEntryScreen extends StatelessWidget {
  final VoidCallback? onClose;
  final VoidCallback? onReceipt;
  final VoidCallback? onManual;
  const AddEntryScreen({super.key, this.onClose, this.onReceipt, this.onManual});

  @override
  Widget build(BuildContext context) {
    final t = AppTheme.of(context);
    return AppScreen(
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onClose,
                child: Container(
                  width: 36, height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: t.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: t.line),
                  ),
                  child: Icon(Icons.close, size: 18, color: t.text),
                ),
              ),
              Text('지출 기록', style: ts(16, w: FontWeight.w700, c: t.text)),
              const SizedBox(width: 36),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text('어떻게 기록할까요?', style: ts(22, w: FontWeight.w800, c: t.text, height: 1.3, letterSpacing: -0.5)),
            const SizedBox(height: 14),
            Text('영수증을 찍으면 가장 빠르게 기록할 수 있어요', style: ts(13, c: t.textSec)),
            const SizedBox(height: 14),

            // 영수증 촬영 (큰 카드)
            GestureDetector(
              onTap: onReceipt,
              child: Container(
                constraints: const BoxConstraints(minHeight: 200),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: t.primary,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24 - 24),
                  child: Stack(children: [
                    Positioned(
                      top: -20, right: -20,
                      child: Container(
                        width: 160, height: 160,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -40, right: 30,
                      child: Container(
                        width: 100, height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 56, height: 56,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.camera_alt_outlined, size: 28, color: Colors.white),
                        ),
                        const SizedBox(height: 16),
                        Text('영수증 촬영', style: ts(20, w: FontWeight.w800, c: Colors.white)),
                        const SizedBox(height: 4),
                        Text('사진 한 장이면 끝\n금액·가맹점·시간 자동 인식',
                          style: ts(13, c: Colors.white.withOpacity(0.9), height: 1.5)),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.22),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            const Icon(Icons.auto_awesome, size: 12, color: Colors.white),
                            const SizedBox(width: 4),
                            Text('추천', style: ts(11, w: FontWeight.w700, c: Colors.white)),
                          ]),
                        ),
                      ],
                    ),
                  ]),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // 수동 입력
            GestureDetector(
              onTap: onManual,
              child: Container(
                padding: const EdgeInsets.all(24),
                constraints: const BoxConstraints(minHeight: 140),
                decoration: BoxDecoration(
                  color: t.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: t.line),
                ),
                child: Row(children: [
                  Container(
                    width: 56, height: 56,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: t.primarySoft,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(Icons.dialpad, size: 28, color: t.primary),
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('수동 입력', style: ts(18, w: FontWeight.w800, c: t.text)),
                    const SizedBox(height: 4),
                    Text('영수증 없이 직접 입력', style: ts(13, c: t.textSec, height: 1.5)),
                  ])),
                  Icon(Icons.chevron_right, size: 20, color: t.textTer),
                ]),
              ),
            ),
            const SizedBox(height: 22),

            // 최근 사용
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text('최근 사용', style: ts(13, w: FontWeight.w700, c: t.textSec)),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: ['이마트', '스타벅스', '교촌치킨', '카카오T', '쿠팡'].map((n) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: t.surface,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: t.line),
                ),
                child: Text(n, style: ts(13, w: FontWeight.w600, c: t.text)),
              )).toList(),
            ),
          ]),
        ),
      ]),
    );
  }
}
