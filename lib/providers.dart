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

/// 单个签池（详情页）。
final poolByIdProvider =
    FutureProvider.family<PoolData?, String>((ref, id) async {
  final db = ref.watch(databaseProvider);
  return db.poolById(id);
});

/// 全局路由。
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (c, s) => const HomeDrawPage()),
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
        path: '/recipes',
        builder: (c, s) => const RecipesPage(),
      ),
      GoRoute(
        path: '/recipes/new',
        builder: (c, s) => const RecipeEditPage(id: 'new'),
      ),
      GoRoute(
        path: '/pools',
        builder: (c, s) => const PoolsPage(),
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
        path: '/history',
        builder: (c, s) => const HistoryPage(),
      ),
      GoRoute(
        path: '/settings',
        builder: (c, s) => const SettingsPage(),
      ),
      GoRoute(
        path: '/profile',
        builder: (c, s) => const MyProfilePage(),
      ),
    ],
  );
});
