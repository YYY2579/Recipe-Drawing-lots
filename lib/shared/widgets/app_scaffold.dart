import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 统一页面外壳：AppBar + 正文 + 浮窗按钮。
/// 底部 5 Tab 导航由 [MainShell] 统一提供（IndexedStack 保留各 Tab 状态）。
class AppScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final bool showBack;
  final VoidCallback? onBack;
  final Widget? floatingActionButton;

  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.showBack = false,
    this.onBack,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
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
      floatingActionButton: floatingActionButton,
    );
  }
}

/// 主页 5 Tab 的持久化外壳：用 StatefulShellRoute 的 IndexedStack 保留各 Tab
/// 状态，切换 Tab 时不再重建页面（避免「像打开新页面一样」的别扭体验）。
class MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const MainShell({super.key, required this.navigationShell});

  void _onTap(int index) {
    // 再次点击当前 Tab 时回到该 Tab 的初始页。
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: _onTap,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.spa_outlined), label: '抽签'),
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_outlined), label: '签池'),
          BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_outlined), label: '菜谱'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: '我的'),
          BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu_outlined), label: '记账'),
        ],
      ),
    );
  }
}
