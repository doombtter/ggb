import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';

enum LoginProvider { kakao, apple, google }

class LoginScreen extends StatefulWidget {
  final VoidCallback? onSuccess;
  const LoginScreen({super.key, this.onSuccess});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginProvider? _busy;

  Future<void> _signIn(LoginProvider p) async {
    if (_busy != null) return;
    setState(() => _busy = p);
    try {
      switch (p) {
        case LoginProvider.kakao:  await AuthService.signInWithKakao(); break;
        case LoginProvider.apple:  await AuthService.signInWithApple(); break;
        case LoginProvider.google: await AuthService.signInWithGoogle(); break;
      }
      if (mounted) widget.onSuccess?.call();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('로그인 실패: $e'), behavior: SnackBarBehavior.floating),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppTheme.of(context);

    return AppScreen(
      child: SizedBox(
        height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              // 로고/일러스트
              Center(
                child: Container(
                  width: 96, height: 96,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft, end: Alignment.bottomRight,
                      colors: [t.primary, t.primaryDark],
                    ),
                    boxShadow: [BoxShadow(color: t.primary.withOpacity(0.30), blurRadius: 30, offset: const Offset(0, 10))],
                  ),
                  alignment: Alignment.center,
                  child: const Text('💰', style: TextStyle(fontSize: 48)),
                ),
              ),
              const SizedBox(height: 28),
              Center(child: Text('티끌가계부',
                style: ts(28, w: FontWeight.w800, c: t.text, letterSpacing: -0.5))),
              const SizedBox(height: 8),
              Center(child: Text('티끌 모아 가족 가계부',
                style: ts(14, w: FontWeight.w500, c: t.textSec))),
              const Spacer(),

              _LoginButton(
                provider: LoginProvider.kakao,
                busy: _busy == LoginProvider.kakao,
                disabled: _busy != null && _busy != LoginProvider.kakao,
                onTap: () => _signIn(LoginProvider.kakao),
              ),
              const SizedBox(height: 10),
              _LoginButton(
                provider: LoginProvider.apple,
                busy: _busy == LoginProvider.apple,
                disabled: _busy != null && _busy != LoginProvider.apple,
                onTap: () => _signIn(LoginProvider.apple),
              ),
              const SizedBox(height: 10),
              _LoginButton(
                provider: LoginProvider.google,
                busy: _busy == LoginProvider.google,
                disabled: _busy != null && _busy != LoginProvider.google,
                onTap: () => _signIn(LoginProvider.google),
              ),
              const SizedBox(height: 24),

              Text.rich(
                TextSpan(
                  style: ts(11, c: t.textTer, height: 1.6),
                  children: [
                    const TextSpan(text: '로그인 시 '),
                    TextSpan(text: '이용약관', style: TextStyle(color: t.textSec, decoration: TextDecoration.underline)),
                    const TextSpan(text: ' 및 '),
                    TextSpan(text: '개인정보처리방침', style: TextStyle(color: t.textSec, decoration: TextDecoration.underline)),
                    const TextSpan(text: '에\n동의한 것으로 간주됩니다.'),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  final LoginProvider provider;
  final VoidCallback? onTap;
  final bool busy;
  final bool disabled;
  const _LoginButton({required this.provider, this.onTap, this.busy = false, this.disabled = false});

  @override
  Widget build(BuildContext context) {
    final t = AppTheme.of(context);
    final spec = switch (provider) {
      LoginProvider.kakao => _Spec(
        bg: const Color(0xFFFEE500),
        fg: const Color(0xFF181600),
        label: '카카오로 시작하기',
        icon: _KakaoMark(color: Color(0xFF181600)),
      ),
      LoginProvider.apple => _Spec(
        bg: t.dark ? Colors.white : Colors.black,
        fg: t.dark ? Colors.black : Colors.white,
        label: 'Apple로 시작하기',
        icon: Icon(Icons.apple, size: 22, color: t.dark ? Colors.black : Colors.white),
      ),
      LoginProvider.google => _Spec(
        bg: t.dark ? const Color(0xFF1F1B16) : Colors.white,
        fg: t.dark ? Colors.white : const Color(0xFF2A2118),
        label: 'Google로 시작하기',
        icon: const _GoogleMark(),
        border: t.dark ? Colors.white.withOpacity(0.12) : const Color(0xFFDDD0B8),
      ),
    };

    return Opacity(
      opacity: disabled ? 0.4 : 1,
      child: GestureDetector(
        onTap: disabled || busy ? null : onTap,
        child: Container(
          height: 54,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: spec.bg,
            borderRadius: BorderRadius.circular(14),
            border: spec.border != null ? Border.all(color: spec.border!) : null,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(alignment: Alignment.centerLeft, child: SizedBox(width: 22, height: 22, child: spec.icon)),
              busy
                ? SizedBox(
                    width: 18, height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: spec.fg),
                  )
                : Text(spec.label, style: ts(15, w: FontWeight.w700, c: spec.fg)),
            ],
          ),
        ),
      ),
    );
  }
}

class _Spec {
  final Color bg, fg;
  final Color? border;
  final String label;
  final Widget icon;
  _Spec({required this.bg, required this.fg, required this.label, required this.icon, this.border});
}

// 카카오톡 말풍선 마크 (단순 SVG-like 셰입)
class _KakaoMark extends StatelessWidget {
  final Color color;
  const _KakaoMark({required this.color});
  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: const Size(22, 22), painter: _KakaoPainter(color));
  }
}

class _KakaoPainter extends CustomPainter {
  final Color color;
  _KakaoPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = color..style = PaintingStyle.fill;
    final r = RRect.fromRectAndCorners(
      Rect.fromLTWH(1, 3, size.width - 2, size.height - 7),
      topLeft: const Radius.circular(7), topRight: const Radius.circular(7),
      bottomLeft: const Radius.circular(7), bottomRight: const Radius.circular(7),
    );
    canvas.drawRRect(r, p);
    // 꼬리
    final tail = Path()
      ..moveTo(7, size.height - 4)
      ..lineTo(5, size.height - 1)
      ..lineTo(11, size.height - 4)
      ..close();
    canvas.drawPath(tail, p);
  }
  @override
  bool shouldRepaint(_) => false;
}

// 구글 G 마크 (단순화)
class _GoogleMark extends StatelessWidget {
  const _GoogleMark();
  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: const Size(22, 22), painter: _GooglePainter());
  }
}

class _GooglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 1;
    // 4색 호 — 단순화된 G
    final colors = [const Color(0xFF4285F4), const Color(0xFFEA4335), const Color(0xFFFBBC04), const Color(0xFF34A853)];
    for (int i = 0; i < 4; i++) {
      final p = Paint()..color = colors[i]..style = PaintingStyle.stroke..strokeWidth = 2.4..strokeCap = StrokeCap.round;
      canvas.drawArc(Rect.fromCircle(center: c, radius: r), -1.5708 + i * 1.5708, 1.4, false, p);
    }
    // 가로선 (G의 입)
    final bar = Paint()..color = const Color(0xFF4285F4)..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(c.dx, c.dy - 1, r - 1, 2), bar);
  }
  @override
  bool shouldRepaint(_) => false;
}
