import 'dart:math' as math;
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
    return Positioned(
      right: 20,
      bottom: 100,
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
// 상단 상태바 / 홈 인디케이터
// ─────────────────────────────────────────
class StatusBar extends StatelessWidget {
  const StatusBar({super.key});
  @override
  Widget build(BuildContext context) {
    final t = AppTheme.of(context);
    final c = t.text;
    return Container(
      height: 47,
      padding: const EdgeInsets.fromLTRB(28, 14, 28, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('9:41', style: ts(17, w: FontWeight.w600, c: c)),
          Row(children: [
            CustomPaint(size: const Size(17, 11), painter: _SignalPainter(c)),
            const SizedBox(width: 5),
            CustomPaint(size: const Size(24, 11), painter: _BatteryPainter(c)),
          ]),
        ],
      ),
    );
  }
}

class _SignalPainter extends CustomPainter {
  final Color color;
  _SignalPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = color;
    final bars = [const Rect.fromLTWH(0, 7, 3, 4), const Rect.fromLTWH(4.5, 5, 3, 6), const Rect.fromLTWH(9, 2.5, 3, 8.5), const Rect.fromLTWH(13.5, 0, 3, 11)];
    for (final r in bars) {
      canvas.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(0.5)), p);
    }
  }
  @override
  bool shouldRepaint(_) => false;
}

class _BatteryPainter extends CustomPainter {
  final Color color;
  _BatteryPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()..style = PaintingStyle.stroke..strokeWidth = 1..color = color;
    final fill = Paint()..color = color;
    canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(0.5, 0.5, 20, 10), const Radius.circular(2.5)), stroke);
    canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(2, 2, 17, 7), const Radius.circular(1.5)), fill);
    final tip = Path()..moveTo(22, 4)..lineTo(22, 7)..cubicTo(22.7, 6.7, 23, 6.1, 23, 5.5)..cubicTo(23, 4.9, 22.7, 4.3, 22, 4)..close();
    canvas.drawPath(tip, fill);
  }
  @override
  bool shouldRepaint(_) => false;
}

class HomeIndicator extends StatelessWidget {
  const HomeIndicator({super.key});
  @override
  Widget build(BuildContext context) {
    final t = AppTheme.of(context);
    return Positioned(
      bottom: 8,
      left: 0, right: 0,
      child: Center(
        child: Container(
          width: 134, height: 5,
          decoration: BoxDecoration(
            color: t.dark ? Colors.white.withOpacity(0.55) : Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// 하단 탭바
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

  @override
  Widget build(BuildContext context) {
    final t = AppTheme.of(context);
    return Positioned(
      left: 0, right: 0, bottom: 0,
      child: Container(
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        decoration: BoxDecoration(
          color: t.surface,
          border: Border(top: BorderSide(color: t.line, width: 0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _tabs.map((tab) {
            final on = tab['id'] == active;
            final c = on ? t.primary : t.textTer;
            return GestureDetector(
              onTap: () => onTap?.call(tab['id']!),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_iconFor(tab['id']!), size: 24, color: c),
                    const SizedBox(height: 3),
                    Text(tab['label']!, style: ts(10.5, w: on ? FontWeight.w700 : FontWeight.w500, c: c)),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// 화면 셸
// ─────────────────────────────────────────
class AppScreen extends StatelessWidget {
  final Widget child;
  final bool scrollable;
  final double padTop;
  const AppScreen({super.key, required this.child, this.scrollable = true, this.padTop = 47});
  @override
  Widget build(BuildContext context) {
    final t = AppTheme.of(context);
    final body = scrollable ? SingleChildScrollView(child: child) : child;
    return Container(
      color: t.bg,
      child: Stack(children: [
        Positioned.fill(
          top: padTop,
          child: ClipRect(child: body),
        ),
        const Positioned(top: 0, left: 0, right: 0, child: StatusBar()),
        const HomeIndicator(),
      ]),
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
