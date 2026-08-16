import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:what_to_eat/app/theme.dart';
import 'package:what_to_eat/providers.dart';
import 'package:what_to_eat/shared/widgets/app_scaffold.dart';

/// 我的：收藏 / 历史 / 设置入口 + 关于。
class MyProfilePage extends ConsumerWidget {
  const MyProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favAsync = ref.watch(favoriteRecipesProvider);
    final histAsync = ref.watch(historyProvider);
    final favCount =
        favAsync.when(data: (l) => l.length, loading: () => 0, error: (_, __) => 0);
    final histCount = histAsync.when(
        data: (l) => l.length, loading: () => 0, error: (_, __) => 0);

    return AppScaffold(
      title: '我的',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.cream,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppTheme.wood,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: const Icon(Icons.person, color: Colors.white, size: 32),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('今天吃什么',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 18)),
                      SizedBox(height: 4),
                      Text('让签筒替你做决定',
                          style: TextStyle(color: AppTheme.gray)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _Entry(
            icon: Icons.favorite_outline,
            title: '我的收藏',
            trailing: '$favCount',
            onTap: () => context.push('/favorites'),
          ),
          _Entry(
            icon: Icons.history,
            title: '抽签历史',
            trailing: '$histCount',
            onTap: () => context.push('/history'),
          ),
          _Entry(
            icon: Icons.settings_outlined,
            title: '设置',
            onTap: () => context.push('/settings'),
          ),
          _Entry(
            icon: Icons.info_outline,
            title: '关于',
            onTap: () => showAboutDialog(
              context: context,
              applicationName: '今天吃什么',
              applicationVersion: '1.0.0',
              children: const [
                Text('离线优先的菜谱随机抽签小工具。数据保存在本机 SQLite。'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Entry extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailing;
  final VoidCallback onTap;

  const _Entry({
    required this.icon,
    required this.title,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          leading: Icon(icon, color: AppTheme.wood),
          title: Text(title),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (trailing != null)
                Text(trailing!, style: const TextStyle(color: AppTheme.gray)),
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right, color: AppTheme.gray),
            ],
          ),
          onTap: onTap,
        ),
      );
}
