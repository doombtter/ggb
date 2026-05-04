import 'package:flutter/material.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';

class OnboardingScreen extends StatelessWidget {
  final VoidCallback? onStart;
  const OnboardingScreen({super.key, this.onStart});

  @override
  Widget build(BuildContext context) {
    final t = AppTheme.of(context);
    return AppScreen(
      child: SizedBox(
        height: 844 - 47,
        child: Stack(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Align(
              alignment: Alignment.topRight,
              child: Text('건너뛰기', style: ts(14, w: FontWeight.w600, c: t.textSec)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 80, 24, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 240, height: 240,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    gradient: RadialGradient(
                      center: const Alignment(-0.4, -0.4),
                      colors: [t.primary, t.primaryDark],
                    ),
                  ),
                  child: Stack(children: [
                    const Positioned(top: 30, left: 40, child: Text('🌷', style: TextStyle(fontSize: 56))),
                    const Positioned(top: 60, right: 30, child: Text('🌲', style: TextStyle(fontSize: 56))),
                    const Positioned(bottom: 40, left: 0, right: 0, child: Center(child: Text('🐰', style: TextStyle(fontSize: 56)))),
                    Center(
                      child: Transform.rotate(
                        angle: -0.07,
                        child: Container(
                          width: 120, height: 80,
                          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 20, offset: const Offset(0, 4))],
                          ),
                          child: const DefaultTextStyle(
                            style: TextStyle(fontFamily: 'monospace', fontSize: 9, color: Color(0xFF7A6B58), height: 1.6),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text('이마트', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 10, color: Color(0xFF2A2118))),
                              Text('2026.05.04'),
                              Text('───────'),
                              Text('합계 47,200'),
                            ]),
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
                const SizedBox(height: 32),
                Text.rich(
                  TextSpan(text: '영수증 한 장으로\n', children: [TextSpan(text: '가족 가계부 끝')]),
                  textAlign: TextAlign.center,
                  style: ts(28, w: FontWeight.w800, c: t.text, height: 1.3, letterSpacing: -0.5),
                ),
                const SizedBox(height: 14),
                Text(
                  'OCR로 3초 만에 입력하고\n가족 모두에게 자동 공유돼요',
                  textAlign: TextAlign.center,
                  style: ts(15, w: FontWeight.w500, c: t.textSec, height: 1.6),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [0, 1, 2].map((i) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Container(
                      width: i == 0 ? 24 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: i == 0 ? t.primary : t.line,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  )).toList(),
                ),
              ],
            ),
          ),
          Positioned(
            left: 20, right: 20, bottom: 40,
            child: Column(children: [
              PrimaryBtn(text: '시작하기', onTap: onStart),
              const SizedBox(height: 14),
              Text.rich(
                TextSpan(
                  style: ts(13, c: t.textSec),
                  children: [
                    const TextSpan(text: '이미 가족 코드가 있나요? '),
                    TextSpan(text: '코드 입력', style: ts(13, w: FontWeight.w700, c: t.primary)),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}
