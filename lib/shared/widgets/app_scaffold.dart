import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:what_to_eat/app/theme.dart';

/// 统一页面外壳：AppBar + 底部 4 Tab 导航。
/// 仅「抽签」Tab 在本轮完整可用，其余为占位。
class AppScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final bool showBack;
  final VoidCallback? onBack;

  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.showBack = false,
    this.onBack,
  });

  static const List<String> _routes = ['/', '/pools', '/recipes', '/profile'];

  int _indexFor(String loc) {
    if (loc.startsWith('/pools')) return 1;
    if (loc.startsWith('/recipes')) return 2;
    if (loc.startsWith('/profile')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final loc = GoRouterState.of(context).matchedLocation;
    final idx = _indexFor(loc);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: showBack
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
                onPressed: onBack ?? () => context.pop(),
              )
            : null,
        actions: actions,
      ),
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: idx,
        onTap: (i) {
          final target = _routes[i];
          if (target == loc) return;
          context.go(target);
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.spa_outlined), label: '抽签'),
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_outlined), label: '签池'),
          BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_outlined), label: '菜谱'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: '我的'),
        ],
      ),
    );
  }
}
