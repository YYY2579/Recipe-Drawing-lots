import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/database/app_database.dart';
import 'package:drift/drift.dart';
import 'core/draw/draw_service.dart';
import 'features/draw/pages/home_draw_page.dart';
import 'features/draw/pages/result_page.dart';
import 'features/draw/pages/recipe_detail_light_page.dart';
import 'features/recipes/pages/recipes_page.dart';
import 'features/recipes/pages/recipe_edit_page.dart';
import 'features/pools/pages/pools_page.dart';
import 'features/pools/pages/pool_detail_page.dart';
import 'features/favorites/pages/favorites_page.dart';
import 'features/history/pages/history_page.dart';
import 'features/settings/pages/settings_page.dart';
import 'features/settings/pages/my_profile_page.dart';
import 'features/cooking_records/pages/cooking_records_page.dart';
import 'features/cooking_records/pages/cooking_stats_page.dart';
import 'shared/widgets/app_scaffold.dart';

/// 数据库单例。
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

/// 当前选中的签池 id（默认川菜）。
final currentPoolProvider = StateProvider<String>((ref) => 'p-sichuan');

/// 设置（单行）。
final settingsProvider = FutureProvider<SettingsData?>((ref) async {
  final db = ref.watch(databaseProvider);
  return db.getSettings();
});

/// 抽签状态机。依赖当前签池与设置中的「最近不重复」次数。
final drawNotifierProvider =
    StateNotifierProvider<DrawNotifier, DrawState>((ref) {
  final db = ref.watch(databaseProvider);
  final poolId = ref.watch(currentPoolProvider);
  final settings = ref.watch(settingsProvider).valueOrNull;
  final exclude = settings?.excludeRecentCount ?? 1;
  return DrawNotifier(
    db: db,
    poolId: poolId,
    excludeRecentCount: exclude,
  );
});

/// 某签池内的菜谱列表（用于首页签筒渲染候选）。
final poolRecipesProvider =
    FutureProvider.family<List<RecipeData>, String>((ref, poolId) async {
  final db = ref.watch(databaseProvider);
  return db.recipesForPool(poolId);
});

/// 全部签池（用于首页切换）。
final allPoolsProvider = FutureProvider<List<PoolData>>((ref) async {
  final db = ref.watch(databaseProvider);
  return db.allPools();
});

/// 单个菜谱（结果页 / 详情页）。
final recipeByIdProvider =
    FutureProvider.family<RecipeData?, String>((ref, id) async {
  final db = ref.watch(databaseProvider);
  return db.recipeById(id);
});

/// 菜谱的食材 / 调料 / 步骤。
final ingredientsForRecipeProvider =
    FutureProvider.family<List<IngredientData>, String>((ref, id) async {
  final db = ref.watch(databaseProvider);
  return (db.select(db.ingredients)
        ..where((t) => t.recipeId.equals(id)))
      .get();
});

final seasoningsForRecipeProvider =
    FutureProvider.family<List<SeasoningData>, String>((ref, id) async {
  final db = ref.watch(databaseProvider);
  return (db.select(db.seasonings)
        ..where((t) => t.recipeId.equals(id)))
      .get();
});

final stepsForRecipeProvider =
    FutureProvider.family<List<RecipeStepData>, String>((ref, id) async {
  final db = ref.watch(databaseProvider);
  return (db.select(db.recipeSteps)
        ..where((t) => t.recipeId.equals(id))
        ..orderBy([(t) => OrderingTerm(expression: t.stepNumber)])).get();
});

/// 全部菜谱（菜谱库 / 编辑后失效刷新）。
final allRecipesProvider = FutureProvider<List<RecipeData>>((ref) async {
  final db = ref.watch(databaseProvider);
  return db.allRecipes();
});

/// 收藏列表。
final favoriteRecipesProvider = FutureProvider<List<RecipeData>>((ref) async {
  final db = ref.watch(databaseProvider);
  return db.favoriteRecipes();
});

/// 抽签历史。
final historyProvider = FutureProvider<List<DrawHistoryData>>((ref) async {
  final db = ref.watch(databaseProvider);
  return db.history();
});

/// 做饭记录（按天主记录，倒序）。
final cookingRecordsProvider =
    FutureProvider<List<CookingRecordData>>((ref) async {
  final db = ref.watch(databaseProvider);
  return db.allCookingRecords();
});

/// 某条做饭记录的菜品条目。
final cookingItemsProvider =
    FutureProvider.family<List<CookingRecordItemData>, int>((ref, recordId) async {
  final db = ref.watch(databaseProvider);
  return db.itemsForRecord(recordId);
});

/// 做饭记录模板。
final cookingTemplatesProvider =
    FutureProvider<List<CookingTemplateData>>((ref) async {
  final db = ref.watch(databaseProvider);
  return db.allCookingTemplates();
});

/// 收支统计周期。
enum StatsPeriod { today, week, month, all }

/// 周期消费统计：按所选周期统计总支出。
/// 用枚举做 family key（稳定、可比较），避免用 (DateTime,DateTime) 元组
/// 每次重建导致统计长期转圈的问题。
final cookingStatsProvider =
    FutureProvider.family<double, StatsPeriod>((ref, period) async {
  final db = ref.watch(databaseProvider);
  final now = DateTime.now();
  // 用 switch expression 保证每个分支都终止并返回独立值；
  // 原 switch 语句每个 case 都缺 break/return，存在 fall-through 隐患。
  final from = switch (period) {
    StatsPeriod.today => DateTime(now.year, now.month, now.day),
    StatsPeriod.week => DateTime(
        now.subtract(Duration(days: now.weekday - 1)).year,
        now.subtract(Duration(days: now.weekday - 1)).month,
        now.subtract(Duration(days: now.weekday - 1)).day),
    StatsPeriod.month => DateTime(now.year, now.month, 1),
    StatsPeriod.all => DateTime(2000),
  };
  return db.totalSpentBetween(from, now);
});

/// 全部记账累计支出（主页顶部「累计支出」汇总，随新增/删除实时刷新）。
final cookingTotalProvider = FutureProvider<double>((ref) async {
  final db = ref.watch(databaseProvider);
  return db.totalSpentAll();
});

/// 自定义时间段统计结果：总消费额 + 分类消费明细 + 按日消费趋势。
class CookingRangeStats {
  final double total;
  final Map<String, double> byCategory; // 分类 -> 金额
  final List<(DateTime, double)> trend; // 按日（升序）：日期 -> 当日金额
  const CookingRangeStats({
    required this.total,
    required this.byCategory,
    required this.trend,
  });
}

/// 自定义时间段统计：给定起止日期，汇总区间内的消费数据。
/// 同时支撑统计页的「自定义」模式与预设周期（把周期换算成 (from,to) 传入即可）。
final cookingRangeStatsProvider =
    FutureProvider.family<CookingRangeStats, (DateTime, DateTime)>(
        (ref, range) async {
  final (from, to) = range;
  final db = ref.watch(databaseProvider);
  final rows = await db.itemsWithDateBetween(from, to);

  double total = 0;
  final byCategory = <String, double>{};
  final byDay = <DateTime, double>{};
  for (final (item, date) in rows) {
    final price = item.price ?? 0;
    total += price;
    final cat = item.category ?? '其他';
    byCategory[cat] = (byCategory[cat] ?? 0) + price;
    final day = DateTime(date.year, date.month, date.day);
    byDay[day] = (byDay[day] ?? 0) + price;
  }

  final trend = byDay.entries
      .map((e) => (e.key, e.value))
      .toList()
    ..sort((a, b) => a.$1.compareTo(b.$1));

  return CookingRangeStats(
      total: total, byCategory: byCategory, trend: trend);
});

/// 单个签池（详情页）。
final poolByIdProvider =
    FutureProvider.family<PoolData?, String>((ref, id) async {
  final db = ref.watch(databaseProvider);
  return db.poolById(id);
});

/// 全局路由：主页 5 个 Tab 用 StatefulShellRoute.indexedStack 托管，
/// 切换 Tab 时保留各自状态（页面内切换，不再重建页面）。其余为全屏子页。
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: '/', builder: (c, s) => const HomeDrawPage()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/pools', builder: (c, s) => const PoolsPage()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/recipes', builder: (c, s) => const RecipesPage()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: '/profile', builder: (c, s) => const MyProfilePage()),
            GoRoute(
                path: '/settings', builder: (c, s) => const SettingsPage()),
            GoRoute(
                path: '/history', builder: (c, s) => const HistoryPage()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: '/cooking-records',
                builder: (c, s) => const CookingRecordsPage()),
          ]),
        ],
      ),
      // 全屏子页（脱离 Tab 外壳，独立显示 + 返回）。
      GoRoute(path: '/result', builder: (c, s) => const ResultPage()),
      GoRoute(
        path: '/recipe/:id',
        builder: (c, s) => RecipeDetailLightPage(id: s.pathParameters['id']!),
      ),
      GoRoute(
        path: '/recipe/:id/edit',
        builder: (c, s) => RecipeEditPage(id: s.pathParameters['id']!),
      ),
      GoRoute(
        path: '/recipes/new',
        builder: (c, s) => const RecipeEditPage(id: 'new'),
      ),
      GoRoute(
        path: '/pools/:id',
        builder: (c, s) => PoolDetailPage(id: s.pathParameters['id']!),
      ),
      GoRoute(
        path: '/favorites',
        builder: (c, s) => const FavoritesPage(),
      ),
      GoRoute(
        path: '/cooking-stats',
        builder: (c, s) => const CookingStatsPage(),
      ),
    ],
  );
});
