import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:what_to_eat/app/theme.dart';
import 'package:what_to_eat/core/database/app_database.dart';
import 'package:what_to_eat/core/sound/sound_service.dart';
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
  final _bambooKey = GlobalKey<BambooTube3DState>();
  bool _busy = false;

  // 入场动画：标题与竹筒淡入上浮，提升页面质感。
  late final AnimationController _appear;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _appear = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _fade = CurvedAnimation(parent: _appear, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(_fade);
    _appear.forward();
  }

  Future<void> _onDraw(List<RecipeData> recipes) async {
    if (_busy) return;
    final settings = ref.read(settingsProvider).valueOrNull;
    final soundEnabled = settings?.soundEnabled ?? true;
    final anim = settings?.animationEnabled ?? true;

    // 竹筒摇晃音效 + 3D 摇晃动画（抽签开始即触发）。
    ref.read(soundServiceProvider)
      ..setEnabled(soundEnabled)
      ..playShake();

    setState(() => _busy = true);
    if (anim) {
      // 模型未就绪时摇晃可能抛错，单步容错，绝不阻断抽签。
      try {
        await _bambooKey.currentState?.shake();
      } catch (_) {
        // 忽略摇晃动画异常，继续抽签流程。
      }
    }
    if (!mounted) return;
    try {
      await ref.read(drawNotifierProvider.notifier).draw();
    } finally {
      // 无论抽签是否成功，都必须复位 _busy，确保可再次抽签。
      if (mounted) setState(() => _busy = false);
    }
    if (mounted) context.push('/result');
  }

  @override
  void dispose() {
    _appear.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final poolId = ref.watch(currentPoolProvider);
    final recipesAsync = ref.watch(poolRecipesProvider(poolId));
    final drawState = ref.watch(drawNotifierProvider);
    final poolsAsync = ref.watch(allPoolsProvider);

    return recipesAsync.when(
      loading: () => const AppScaffold(
          title: '今天吃什么？',
          body: Center(child: CircularProgressIndicator())),
      error: (e, _) => AppScaffold(
        title: '今天吃什么？',
        body: Center(child: Text('加载失败：$e')),
      ),
      data: (recipes) {
        final pools = poolsAsync.valueOrNull ?? [];
        final current = pools.where((p) => p.id == poolId).firstOrNull;
        final poolName = current?.name ?? '川菜';
        final count = recipes.length;
        final luckyStar =
            ref.watch(settingsProvider).valueOrNull?.luckyStarEnabled ?? false;

        return AppScaffold(
          title: '今天吃什么？',
          actions: [
            IconButton(
              tooltip: luckyStar ? '幸运星模式：开' : '幸运星模式：关',
              icon: Icon(
                luckyStar ? Icons.star_rounded : Icons.star_outline_rounded,
                color: luckyStar ? const Color(0xFFE2B33B) : null,
              ),
              onPressed: () async {
                await ref.read(databaseProvider).updateSettings(
                      luckyStarEnabled: !luckyStar,
                    );
                ref.invalidate(settingsProvider);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(!luckyStar
                          ? '幸运星模式已开启：出去吃 / 点外卖概率提升至 40%'
                          : '幸运星模式已关闭'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () => context.go('/profile'),
            ),
          ],
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // 标题区（入场淡入）
                FadeTransition(
                  opacity: _fade,
                  child: Column(
                    children: [
                      const Text(
                        '今天吃什么？',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.darkBrown,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        '让签筒替你做决定',
                        style: TextStyle(
                          color: AppTheme.gray,
                          fontSize: 13.5,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                _PoolSelector(
                  poolName: poolName,
                  count: count,
                  pools: pools,
                  onSelected: (id) =>
                      ref.read(currentPoolProvider.notifier).state = id,
                ),
                const SizedBox(height: 10),
                // 竹筒区（入场淡入 + 上浮）
                Expanded(
                  child: FadeTransition(
                    opacity: _fade,
                    child: SlideTransition(
                      position: _slide,
                      child: GestureDetector(
                        onTap: _busy ? null : () => _onDraw(recipes),
                        behavior: HitTestBehavior.opaque,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            BambooTube3D(key: _bambooKey),
                            if (!_busy)
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppTheme.cream,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color:
                                          AppTheme.wood.withOpacity(0.25),
                                    ),
                                  ),
                                  child: const Text(
                                    '轻触竹筒，揭晓今日菜单',
                                    style: TextStyle(
                                      color: AppTheme.gray,
                                      fontSize: 12.5,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (drawState.previousResult != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.history_rounded,
                            size: 15, color: AppTheme.gray),
                        const SizedBox(width: 6),
                        Text(
                          '最近抽过：${drawState.previousResult!.recipeName}',
                          style: const TextStyle(
                            color: AppTheme.gray,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text('点下方按钮，开始抽签',
                        style: TextStyle(color: AppTheme.gray, fontSize: 13)),
                  ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _busy ? null : () => _onDraw(recipes),
                      icon: const Icon(Icons.auto_awesome_rounded, size: 18),
                      label: const Text('抽一签'),
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

/// 顶部签池选择器（点击切换当前签池），带图标与微阴影。
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        decoration: BoxDecoration(
          color: AppTheme.cream,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.wood.withOpacity(0.3)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.restaurant_menu_rounded,
                size: 16, color: AppTheme.gray),
            const SizedBox(width: 8),
            const Text('当前签池',
                style: TextStyle(color: AppTheme.gray, fontSize: 13)),
            const SizedBox(width: 8),
            Text(poolName,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, color: AppTheme.darkBrown)),
            const SizedBox(width: 8),
            Text('$count 道菜',
                style: const TextStyle(color: AppTheme.gray, fontSize: 12)),
            const SizedBox(width: 4),
            const Icon(Icons.expand_more_rounded,
                color: AppTheme.gray, size: 18),
          ],
        ),
      ),
    );
  }
}
