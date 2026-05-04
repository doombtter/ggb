import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme/tokens.dart';
import 'models/models.dart';
import 'data/sample.dart';
import 'screens/onboarding.dart';
import 'screens/login.dart';
import 'screens/home.dart';
import 'screens/list.dart';
import 'screens/detail.dart';
import 'screens/add_entry.dart';
import 'screens/ocr.dart';
import 'screens/manual.dart';
import 'screens/fixed.dart';
import 'screens/fixed_add.dart';
import 'screens/variable_dialog.dart';
import 'screens/report.dart';
import 'screens/group.dart';
import 'screens/settings.dart';

void main() {
  runApp(const GgbApp());
}

class GgbApp extends StatefulWidget {
  const GgbApp({super.key});
  @override
  State<GgbApp> createState() => _GgbAppState();
}

class _GgbAppState extends State<GgbApp> {
  bool _dark = false;

  @override
  Widget build(BuildContext context) {
    final tokens = _dark ? AppTokens.dark_ : AppTokens.light;
    return MaterialApp(
      title: '우리집 가계부',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: tokens.bg,
        textTheme: GoogleFonts.notoSansKrTextTheme(
          ThemeData(brightness: _dark ? Brightness.dark : Brightness.light).textTheme,
        ),
        primaryColor: tokens.primary,
        brightness: _dark ? Brightness.dark : Brightness.light,
      ),
      home: AppTheme(
        t: tokens,
        child: AppShell(
          dark: _dark,
          onToggleDark: () => setState(() => _dark = !_dark),
        ),
      ),
    );
  }
}

enum AppRoute { onboarding, login, home, list, fixed, settings, addEntry, ocr, manual, fixedAdd, variableDialog, report, group, detail }

class AppShell extends StatefulWidget {
  final bool dark;
  final VoidCallback? onToggleDark;
  const AppShell({super.key, required this.dark, this.onToggleDark});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  AppRoute _route = AppRoute.onboarding;
  Transaction? _detailTx;

  void _go(AppRoute r) => setState(() => _route = r);

  void _onTab(String id) {
    switch (id) {
      case 'home': _go(AppRoute.home); break;
      case 'list': _go(AppRoute.list); break;
      case 'fixed': _go(AppRoute.fixed); break;
      case 'settings': _go(AppRoute.settings); break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppTheme.of(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: widget.dark ? Brightness.light : Brightness.dark,
      statusBarBrightness: widget.dark ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: t.bg,
      systemNavigationBarIconBrightness: widget.dark ? Brightness.light : Brightness.dark,
      systemNavigationBarDividerColor: Colors.transparent,
    ));

    final body = switch (_route) {
      AppRoute.onboarding => OnboardingScreen(onStart: () => _go(AppRoute.login)),
      AppRoute.login => LoginScreen(onLogin: (_) => _go(AppRoute.home)),
      AppRoute.home => HomeScaffold(onTab: _onTab, onFab: () => _go(AppRoute.addEntry)),
      AppRoute.list => TxListScreen(
        onTab: _onTab,
        onFab: () => _go(AppRoute.addEntry),
        onTap: (tx) { setState(() { _detailTx = tx; _route = AppRoute.detail; }); },
      ),
      AppRoute.fixed => FixedScreen(onTab: _onTab, onAdd: () => _go(AppRoute.fixedAdd)),
      AppRoute.settings => SettingsScreen(onTab: _onTab, onOpenGroup: () => _go(AppRoute.group)),
      AppRoute.addEntry => AddEntryScreen(
        onClose: () => _go(AppRoute.home),
        onReceipt: () => _go(AppRoute.ocr),
        onManual: () => _go(AppRoute.manual),
      ),
      AppRoute.ocr => OCRScreen(onBack: () => _go(AppRoute.addEntry), onSave: () => _go(AppRoute.home)),
      AppRoute.manual => ManualScreen(onBack: () => _go(AppRoute.addEntry), onSave: () => _go(AppRoute.home)),
      AppRoute.fixedAdd => FixedAddScreen(onBack: () => _go(AppRoute.fixed), onDone: () => _go(AppRoute.fixed)),
      AppRoute.variableDialog => VariableDialogScreen(
        onClose: () => _go(AppRoute.fixed),
        onSave: () => _go(AppRoute.fixed),
        onSkip: () => _go(AppRoute.fixed),
      ),
      AppRoute.report => ReportScreen(onBack: () => _go(AppRoute.home)),
      AppRoute.group => GroupScreen(onBack: () => _go(AppRoute.settings)),
      AppRoute.detail => TxDetailScreen(tx: _detailTx ?? transactions.first, onBack: () => _go(AppRoute.list)),
    };

    return Scaffold(
      backgroundColor: AppTheme.of(context).bg,
      body: SafeArea(
        top: false, bottom: false,
        child: Stack(children: [
          Positioned.fill(child: body),
          Positioned(
            top: 56, right: 12,
            child: _DebugMenu(
              go: _go,
              dark: widget.dark,
              onToggleDark: widget.onToggleDark,
            ),
          ),
        ]),
      ),
    );
  }
}

class _DebugMenu extends StatelessWidget {
  final void Function(AppRoute) go;
  final bool dark;
  final VoidCallback? onToggleDark;
  const _DebugMenu({required this.go, required this.dark, this.onToggleDark});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: '데모 메뉴',
      icon: const Icon(Icons.developer_mode, size: 18, color: Colors.black54),
      onSelected: (v) {
        if (v == 'dark') { onToggleDark?.call(); return; }
        go(AppRoute.values.firstWhere((r) => r.name == v));
      },
      itemBuilder: (c) => [
        for (final r in AppRoute.values)
          PopupMenuItem(value: r.name, child: Text(r.name)),
        const PopupMenuDivider(),
        PopupMenuItem(value: 'dark', child: Text(dark ? '라이트 모드' : '다크 모드')),
      ],
    );
  }
}
