import 'dart:math' as math;
import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import '../theme/tokens.dart';
import '../models/models.dart';
import '../data/sample.dart';

// ─────────────────────────────────────────
// 텍스트 헬퍼
// ─────────────────────────────────────────
TextStyle ts(double size, {FontWeight? w, Color? c, double? letterSpacing, double? height}) =>
    TextStyle(
      fontSize: size,
      fontWeight: w,
      color: c,
      letterSpacing: letterSpacing,
      height: height,
      fontFamily: 'NotoSansKR',
      fontFeatures: const [FontFeature.tabularFigures()],
    );

// ─────────────────────────────────────────
// 카드 / 칩 / 버튼
// ─────────────────────────────────────────
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final Decoration? decoration;
  const AppCard({super.key, required this.child, this.padding = const EdgeInsets.all(18), this.color, this.decoration});

  @override
  Widget build(BuildContext context) {
    final t = AppTheme.of(context);
    return Container(
      padding: padding,
      decoration: decoration ?? BoxDecoration(
        color: color ?? t.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 3, offset: const Offset(0, 1)),
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16, offset: const Offset(0, 4)),
        ],
      ),
      child: child,
    );
  }
}

class AppChip extends StatelessWidget {
  final Widget child;
  final bool active;
  final Color? color;
  const AppChip({super.key, required this.child, this.active = false, this.color});
  @override
  Widget build(BuildContext context) {
    final t = AppTheme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: active ? (color ?? t.primary) : t.surfaceAlt,
        borderRadius: BorderRadius.circular(999),
        border: active ? null : Border.all(color: t.line),
      ),
      child: DefaultTextStyle(
        style: ts(13, w: FontWeight.w600, c: active ? Colors.white : t.textSec),
        child: child,
      ),
    );
  }
}

class PrimaryBtn extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onTap;
  const PrimaryBtn({super.key, required this.text, this.icon, this.onTap});
  @override
  Widget build(BuildContext context) {
    final t = AppTheme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(color: t.primary, borderRadius: BorderRadius.circular(16)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[Icon(icon, size: 20, color: Colors.white), const SizedBox(width: 8)],
            Text(text, style: ts(16, w: FontWeight.w700, c: Colors.white)),
          ],
        ),
      ),
    );
  }
}

class FabButton extends StatelessWidget {
  final VoidCallback? onTap;
  const FabButton({super.key, this.onTap});
  @override
  Widget build(BuildContext context) {
    final t = AppTheme.of(context);
    final inset = MediaQuery.of(context).padding.bottom;
    return Positioned(
      right: 20,
      bottom: inset + 90, // 플로팅 탭바(64+14) 위에 살짝 띄움
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 60, height: 60,
          decoration: BoxDecoration(
            color: t.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: t.primary.withOpacity(0.33), blurRadius: 20, offset: const Offset(0, 8)),
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6, offset: const Offset(0, 2)),
            ],
          ),
          child: const Icon(Icons.add, size: 28, color: Colors.white),
        ),
      ),
    );
  }
}

class Avatar extends StatelessWidget {
  final Member member;
  final double size;
  final bool ring;
  const Avatar({super.key, required this.member, this.size = 32, this.ring = false});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: member.color.withOpacity(0.2),
        shape: BoxShape.circle,
        border: ring ? Border.all(color: member.color, width: 2) : null,
      ),
      child: Text(member.emoji, style: TextStyle(fontSize: size * 0.5)),
    );
  }
}

class CatIcon extends StatelessWidget {
  final CategoryDef category;
  final double size;
  const CatIcon({super.key, required this.category, this.size = 40});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: category.color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(category.emoji, style: TextStyle(fontSize: size * 0.5)),
    );
  }
}

// ─────────────────────────────────────────
// 도넛 차트
// ─────────────────────────────────────────
class DonutSegment {
  final double value;
  final Color color;
  const DonutSegment(this.value, this.color);
}

class Donut extends StatelessWidget {
  final List<DonutSegment> data;
  final double size;
  final double thickness;
  final String centerLabel;
  final String centerValue;
  const Donut({super.key, required this.data, this.size = 180, this.thickness = 28, required this.centerLabel, required this.centerValue});

  @override
  Widget build(BuildContext context) {
    final t = AppTheme.of(context);
    return SizedBox(
      width: size, height: size,
      child: Stack(alignment: Alignment.center, children: [
        CustomPaint(size: Size(size, size), painter: _DonutPainter(data, thickness, t.line)),
        Column(mainAxisSize: MainAxisSize.min, children: [
          Text(centerLabel, style: ts(12, w: FontWeight.w500, c: t.textSec)),
          const SizedBox(height: 2),
          Text(centerValue, style: ts(22, w: FontWeight.w800, c: t.text)),
        ]),
      ]),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final List<DonutSegment> data;
  final double thickness;
  final Color trackColor;
  _DonutPainter(this.data, this.thickness, this.trackColor);

  @override
  void paint(Canvas canvas, Size size) {
    final r = size.width / 2 - thickness / 2;
    final c = Offset(size.width / 2, size.height / 2);
    final track = Paint()..style = PaintingStyle.stroke..strokeWidth = thickness..color = trackColor;
    canvas.drawCircle(c, r, track);

    final total = data.fold<double>(0, (s, d) => s + d.value);
    if (total <= 0) return;
    double start = -math.pi / 2;
    for (final d in data) {
      final sweep = (d.value / total) * 2 * math.pi;
      final p = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = thickness
        ..color = d.color
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(Rect.fromCircle(center: c, radius: r), start, sweep, false, p);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter old) => true;
}

// ─────────────────────────────────────────
// 가로 막대
// ─────────────────────────────────────────
class HBarItem {
  final Widget? icon;
  final String label;
  final int value;
  final Color color;
  const HBarItem({this.icon, required this.label, required this.value, required this.color});
}

class HBars extends StatelessWidget {
  final List<HBarItem> data;
  final int? max;
  const HBars({super.key, required this.data, this.max});
  @override
  Widget build(BuildContext context) {
    final t = AppTheme.of(context);
    final m = max ?? data.fold<int>(0, (s, d) => d.value > s ? d.value : s);
    return Column(
      children: [
        for (int i = 0; i < data.length; i++) ...[
          if (i > 0) const SizedBox(height: 14),
          Row(children: [
            if (data[i].icon != null) ...[data[i].icon!, const SizedBox(width: 10)],
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(data[i].label, style: ts(13, w: FontWeight.w600, c: t.text)),
                  Text(fmt(data[i].value), style: ts(13, w: FontWeight.w700, c: t.text)),
                ]),
                const SizedBox(height: 5),
                Stack(children: [
                  Container(height: 8, decoration: BoxDecoration(color: t.line, borderRadius: BorderRadius.circular(4))),
                  FractionallySizedBox(
                    widthFactor: m == 0 ? 0 : data[i].value / m,
                    child: Container(height: 8, decoration: BoxDecoration(color: data[i].color, borderRadius: BorderRadius.circular(4))),
                  ),
                ]),
              ]),
            ),
          ]),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────
// 플로팅 알약 탭바 (반투명 + 블러)
// ─────────────────────────────────────────
class AppTabBar extends StatelessWidget {
  final String active;
  final void Function(String tabId)? onTap;
  const AppTabBar({super.key, required this.active, this.onTap});

  static const _tabs = [
    {'id': 'home', 'label': '홈'},
    {'id': 'list', 'label': '거래'},
    {'id': 'fixed', 'label': '고정지출'},
    {'id': 'settings', 'label': '설정'},
  ];

  IconData _iconFor(String id) {
    switch (id) {
      case 'home': return Icons.home_outlined;
      case 'list': return Icons.list_rounded;
      case 'fixed': return Icons.repeat_rounded;
      case 'settings': return Icons.settings_outlined;
    }
    return Icons.circle;
  }

  /// 탭바가 차지하는 총 높이 (콘텐츠 padding bottom 계산용)
  static double totalHeight(BuildContext context) {
    final inset = MediaQuery.of(context).padding.bottom;
    return 64 /* 바 높이 */ + 14 /* 화면 하단 마진 */ + inset;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppTheme.of(context);
    final inset = MediaQuery.of(context).padding.bottom;
    final fillColor = (t.dark ? const Color(0xFF252019) : Colors.white).withOpacity(0.78);

    return Positioned(
      left: 18, right: 18, bottom: inset + 14,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: t.dark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.04)),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(t.dark ? 0.4 : 0.10), blurRadius: 24, offset: const Offset(0, 8)),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _tabs.map((tab) {
                final on = tab['id'] == active;
                final c = on ? t.primary : t.textTer;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => onTap?.call(tab['id']!),
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                      decoration: BoxDecoration(
                        color: on ? t.primarySoft : Colors.transparent,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(_iconFor(tab['id']!), size: 22, color: c),
                          const SizedBox(height: 2),
                          Text(tab['label']!, style: ts(10, w: on ? FontWeight.w700 : FontWeight.w500, c: c)),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// 화면 셸 — 시스템 status bar/네비 inset 자동 처리
// ─────────────────────────────────────────
class AppScreen extends StatelessWidget {
  final Widget child;
  final bool scrollable;
  const AppScreen({super.key, required this.child, this.scrollable = true});
  @override
  Widget build(BuildContext context) {
    final t = AppTheme.of(context);
    final topInset = MediaQuery.of(context).padding.top;
    final body = scrollable ? SingleChildScrollView(child: child) : child;
    return Container(
      color: t.bg,
      child: Padding(
        padding: EdgeInsets.only(top: topInset),
        child: body,
      ),
    );
  }
}

// ─────────────────────────────────────────
// 일반 정보 row (label / value)
// ─────────────────────────────────────────
class FieldRow extends StatelessWidget {
  final String label;
  final Widget value;
  final bool last;
  const FieldRow({super.key, required this.label, required this.value, this.last = false});
  @override
  Widget build(BuildContext context) {
    final t = AppTheme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        border: last ? null : Border(bottom: BorderSide(color: t.line, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: ts(13, w: FontWeight.w600, c: t.textSec)),
          Flexible(child: DefaultTextStyle.merge(
            style: ts(15, c: t.text),
            textAlign: TextAlign.right,
            child: value,
          )),
        ],
      ),
    );
  }
}

// 작은 점 구분자 (· 대용으로 쓰는 dot)
class Dot extends StatelessWidget {
  final Color? color;
  const Dot({super.key, this.color});
  @override
  Widget build(BuildContext context) {
    return Container(width: 2, height: 2,
      decoration: BoxDecoration(color: color ?? AppTheme.of(context).textTer, borderRadius: BorderRadius.circular(1)));
  }
}
