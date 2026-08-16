import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:what_to_eat/core/database/app_database.dart';
import 'package:what_to_eat/features/draw/widgets/bamboo_tube.dart';
import 'package:what_to_eat/providers.dart';
import 'package:what_to_eat/shared/widgets/app_scaffold.dart';

class HomeDrawPage extends ConsumerStatefulWidget {
  const HomeDrawPage({super.key});

  @override
  ConsumerState<HomeDrawPage> createState() => _HomeDrawPageState();
}

class _HomeDrawPageState extends ConsumerState<HomeDrawPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  int _targetIndex = -1;
  int _seed = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onDraw(List<RecipeData> recipes) async {
    if (_controller.isAnimating) return;
    final result = await ref.read(drawNotifierProvider.notifier).draw();
    if (!mounted) return;

    final anim =
        ref.read(settingsProvider).valueOrNull?.animationEnabled ?? true;
    if (anim) {
      final idx = recipes.indexWhere((r) => r.id == result.recipeId);
      setState(() {
        _targetIndex = idx;
        _seed = result.animationSeed;
      });
      await _controller.forward(from: 0);
      if (!mounted) return;
    }
    if (mounted) context.push('/result');
  }

  @override
  Widget build(BuildContext context) {
    final poolId = ref.watch(currentPoolProvider);
    final recipesAsync = ref.watch(poolRecipesProvider(poolId));
    final drawState = ref.watch(drawNotifierProvider);
    final poolsAsync = ref.watch(allPoolsProvider);

    return recipesAsync.when(
      loading: () =>
          const AppScaffold(title: '今天吃什么？', body: Center(child: CircularProgressIndicator())),
      error: (e, _) => AppScaffold(
        title: '今天吃什么？',
        body: Center(child: Text('加载失败：$e')),
      ),
      data: (recipes) {
        final pools = poolsAsync.valueOrNull ?? [];
        final current = pools.where((p) => p.id == poolId).firstOrNull;
        final poolName = current?.name ?? '川菜';
        final count = recipes.length;

        return AppScaffold(
          title: '今天吃什么？',
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () => context.go('/profile'),
            ),
          ],
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Text(
                  '今天吃什么？',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 4),
                const Text(
                  '让签筒替你做决定',
                  style: TextStyle(color: AppThemeGray),
                ),
                const SizedBox(height: 16),
                _PoolSelector(
                  poolName: poolName,
                  count: count,
                  pools: pools,
                  onSelected: (id) =>
                      ref.read(currentPoolProvider.notifier).state = id,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: CustomPaint(
                  size: Size(MediaQuery.of(context).size.width - 48, 320),
                  painter: BambooTubePainter(
                      progress: _controller,
                      recipes: recipes,
                      targetIndex: _targetIndex,
                      seed: _seed,
                    ),
                  ),
                ),
                if (drawState.result != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      '最近抽过：${drawState.result!.recipeName}',
                      style: const TextStyle(color: AppThemeGray),
                    ),
                  )
                else
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text('点下方按钮，开始抽签',
                        style: TextStyle(color: AppThemeGray)),
                  ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: drawState.isDrawing
                          ? null
                          : () => _onDraw(recipes),
                      child: const Text('抽一签'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// 顶部签池选择器（点击切换当前签池）。
class _PoolSelector extends StatelessWidget {
  final String poolName;
  final int count;
  final List<PoolData> pools;
  final ValueChanged<String> onSelected;

  const _PoolSelector({
    required this.poolName,
    required this.count,
    required this.pools,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onSelected,
      itemBuilder: (ctx) => pools
          .map((p) => PopupMenuItem(value: p.id, child: Text(p.name)))
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F3EA),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFB98252).withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('当前签池', style: TextStyle(color: AppThemeGray)),
            const SizedBox(width: 8),
            Text(poolName,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, color: Color(0xFF292621))),
            const SizedBox(width: 8),
            Text('$count 道菜 · 点击切换',
                style: const TextStyle(color: AppThemeGray, fontSize: 12)),
            const SizedBox(width: 4),
            const Icon(Icons.expand_more, color: AppThemeGray, size: 18),
          ],
        ),
      ),
    );
  }
}

/// 局部灰色常量（避免重复 import 主题）。
const Color AppThemeGray = Color(0xFF817A70);
