import 'package:flutter/material.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';
import '../data/sample.dart';

class SettingsScreen extends StatelessWidget {
  final void Function(String)? onTab;
  final VoidCallback? onOpenGroup;
  const SettingsScreen({super.key, this.onTab, this.onOpenGroup});

  Widget _row(BuildContext context, {required IconData icon, required Color iconBg,
    required String title, String? sub, String? value, bool last = false, bool danger = false, VoidCallback? onTap}) {
    final t = AppTheme.of(context);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: last ? null : Border(bottom: BorderSide(color: t.line, width: 0.5)),
        ),
        child: Row(children: [
          Container(
            width: 32, height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, size: 18, color: danger ? t.negative : t.text),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: ts(14, w: FontWeight.w600, c: danger ? t.negative : t.text)),
            if (sub != null) ...[
              const SizedBox(height: 2),
              Text(sub, style: ts(11, c: t.textSec)),
            ],
          ])),
          if (value != null) Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Text(value, style: ts(13, c: t.textSec)),
          ),
          Icon(Icons.chevron_right, size: 14, color: t.textTer),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppTheme.of(context);
    return Stack(children: [
      AppScreen(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
            child: Text('설정', style: ts(26, w: FontWeight.w800, c: t.text, letterSpacing: -0.5)),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              // 프로필
              AppCard(
                padding: const EdgeInsets.all(18),
                child: Row(children: [
                  Avatar(member: members[0], size: 56),
                  const SizedBox(width: 14),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(members[0].nickname, style: ts(17, w: FontWeight.w800, c: t.text)),
                    const SizedBox(height: 2),
                    Text('김씨네 가족 · 그룹장', style: ts(12, c: t.textSec)),
                  ])),
                  Icon(Icons.chevron_right, size: 16, color: t.textTer),
                ]),
              ),
              const SizedBox(height: 14),

              _section(t, '그룹', AppCard(
                padding: EdgeInsets.zero,
                child: Column(children: [
                  _row(context,
                    icon: Icons.group_outlined, iconBg: t.primarySoft,
                    title: '가족 그룹 관리', sub: '멤버 3명 · 코드 K7M2P9',
                    onTap: onOpenGroup,
                  ),
                  _row(context,
                    icon: Icons.account_balance_wallet_outlined, iconBg: const Color(0xFFE2EEDD),
                    title: '카테고리 관리', sub: '기본 12개 사용 중', last: true,
                  ),
                ]),
              )),
              const SizedBox(height: 14),

              _section(t, '알림', AppCard(
                padding: EdgeInsets.zero,
                child: Column(children: [
                  _row(context, icon: Icons.notifications_outlined, iconBg: const Color(0xFFFBE3DC),
                    title: '푸시 알림', value: '켜짐'),
                  _row(context, icon: Icons.repeat_rounded, iconBg: const Color(0xFFE2EEDD),
                    title: '고정 지출 알림', sub: '3일 전부터 알림'),
                  _row(context, icon: Icons.show_chart, iconBg: t.primarySoft,
                    title: '월말 리포트', value: '매월 1일', last: true),
                ]),
              )),
              const SizedBox(height: 14),

              _section(t, '화면', AppCard(
                padding: EdgeInsets.zero,
                child: _row(context,
                  icon: t.dark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                  iconBg: t.primarySoft,
                  title: '다크 모드', value: t.dark ? '켜짐' : '시스템', last: true,
                ),
              )),
              const SizedBox(height: 14),

              _section(t, '기타', AppCard(
                padding: EdgeInsets.zero,
                child: Column(children: [
                  _row(context, icon: Icons.file_download_outlined, iconBg: t.surfaceAlt,
                    title: '데이터 내보내기', sub: 'CSV · v1.1 출시 예정'),
                  _row(context, icon: Icons.info_outlined, iconBg: t.surfaceAlt,
                    title: '앱 정보', value: 'v1.0.0'),
                  _row(context, icon: Icons.logout, iconBg: t.negativeSoft,
                    title: '로그아웃', danger: true, last: true),
                ]),
              )),
            ]),
          ),
        ]),
      ),
      AppTabBar(active: 'settings', onTap: onTab),
    ]);
  }

  Widget _section(t, String title, Widget child) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
        child: Text(title, style: ts(12, w: FontWeight.w700, c: t.textSec)),
      ),
      child,
    ],
  );
}
