import 'package:flutter/material.dart';

class AppTokens {
  final bool dark;

  // 배경
  final Color bg;
  final Color bgAlt;
  final Color surface;
  final Color surfaceAlt;

  // 텍스트
  final Color text;
  final Color textSec;
  final Color textTer;

  // 라인
  final Color line;
  final Color lineStrong;

  // 브랜드
  final Color primary;
  final Color primarySoft;
  final Color primaryDark;

  // 시그널
  final Color positive;
  final Color positiveSoft;
  final Color negative;
  final Color negativeSoft;

  final List<Color> chart;

  const AppTokens({
    required this.dark,
    required this.bg,
    required this.bgAlt,
    required this.surface,
    required this.surfaceAlt,
    required this.text,
    required this.textSec,
    required this.textTer,
    required this.line,
    required this.lineStrong,
    required this.primary,
    required this.primarySoft,
    required this.primaryDark,
    required this.positive,
    required this.positiveSoft,
    required this.negative,
    required this.negativeSoft,
    required this.chart,
  });

  static const _chart = <Color>[
    Color(0xFFF4A574), Color(0xFF7BB48E), Color(0xFFE8B86E), Color(0xFFA99CD9),
    Color(0xFFE89A9A), Color(0xFF7CB7C7), Color(0xFFD4A5C9), Color(0xFFC9B58A),
    Color(0xFF9CC5A1), Color(0xFFE8C376), Color(0xFFB5A099), Color(0xFF8AA0C9),
  ];

  static const light = AppTokens(
    dark: false,
    bg: Color(0xFFFFFAF2),
    bgAlt: Color(0xFFF5EFE3),
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFFAF5EC),
    text: Color(0xFF2A2118),
    textSec: Color(0xFF7A6B58),
    textTer: Color(0xFFB5A691),
    line: Color(0xFFEDE3D2),
    lineStrong: Color(0xFFDDD0B8),
    primary: Color(0xFFE87A3E),
    primarySoft: Color(0xFFFFE8D6),
    primaryDark: Color(0xFFC25E27),
    positive: Color(0xFF6FA876),
    positiveSoft: Color(0xFFE2EEDD),
    negative: Color(0xFFD9614C),
    negativeSoft: Color(0xFFFBE3DC),
    chart: _chart,
  );

  static const dark_ = AppTokens(
    dark: true,
    bg: Color(0xFF161310),
    bgAlt: Color(0xFF1F1B16),
    surface: Color(0xFF252019),
    surfaceAlt: Color(0xFF2D271F),
    text: Color(0xFFF5EEDF),
    textSec: Color(0xFFB5A691),
    textTer: Color(0xFF7A6B58),
    line: Color(0xFF332C22),
    lineStrong: Color(0xFF473D2E),
    primary: Color(0xFFF08A4B),
    primarySoft: Color(0xFF3A2A1C),
    primaryDark: Color(0xFFFFA770),
    positive: Color(0xFF8FC09A),
    positiveSoft: Color(0xFF283526),
    negative: Color(0xFFE8806B),
    negativeSoft: Color(0xFF3A2620),
    chart: _chart,
  );
}

class AppTheme extends InheritedWidget {
  final AppTokens t;
  const AppTheme({super.key, required this.t, required super.child});

  static AppTokens of(BuildContext context) {
    final w = context.dependOnInheritedWidgetOfExactType<AppTheme>();
    assert(w != null, 'AppTheme not found in widget tree');
    return w!.t;
  }

  @override
  bool updateShouldNotify(AppTheme oldWidget) => oldWidget.t != t;
}
