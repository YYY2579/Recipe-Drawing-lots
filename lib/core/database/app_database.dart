import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables.dart';

part 'app_database.g.dart';

/// 应用数据库（Drift 代码生成：运行 `dart run build_runner build` 生成 app_database.g.dart）
@DriftDatabase(
  tables: [
    Recipes,
    Ingredients,
    Seasonings,
    RecipeSteps,
    Pools,
    PoolRecipes,
    DrawHistories,
    Settings,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // ---------- 菜谱 ----------
  Future<int> countRecipes() async => (await select(recipes).get()).length;

  Future<void> insertRecipe(RecipesCompanion c) =>
      into(recipes).insert(c, mode: InsertMode.replace);

  Future<void> insertIngredient(IngredientsCompanion c) =>
      into(ingredients).insert(c);

  Future<void> insertSeasoning(SeasoningsCompanion c) =>
      into(seasonings).insert(c);

  Future<void> insertStep(RecipeStepsCompanion c) => into(recipeSteps).insert(c);

  /// 某个签池内的全部菜谱（按 PoolRecipes 关联）
  Future<List<RecipeData>> recipesForPool(String poolId) {
    final q = select(recipes).join([
      innerJoin(poolRecipes, poolRecipes.recipeId.equalsExp(recipes.id)),
    ])
      ..where(poolRecipes.poolId.equals(poolId));
    return q.map((row) => row.readTable(recipes)).get();
  }

  Future<RecipeData?> recipeById(String id) =>
      (select(recipes)..where((r) => r.id.equals(id))).getSingleOrNull();

  Future<List<RecipeData>> allRecipes() => select(recipes).get();

  Future<List<String>> recentRecipeIds(String poolId, {int limit = 20}) {
    final q = select(drawHistories)
      ..where((h) => h.poolId.equals(poolId))
      ..orderBy([(h) => OrderingTerm.desc(h.drawTime)])
      ..limit(limit);
    return q.map((h) => h.recipeId).get();
  }

  Future<void> insertHistory(String poolId, String recipeId) =>
      into(drawHistories).insert(DrawHistoriesCompanion(
        poolId: Value(poolId),
        recipeId: Value(recipeId),
        drawTime: Value(DateTime.now()),
      ));

  Future<void> setFavorite(String id, bool favorite) async {
    final r = await recipeById(id);
    if (r != null) {
      await update(recipes).replace(r.copyWith(isFavorite: favorite));
    }
  }

  // ---------- 签池 ----------
  Future<void> insertPool(PoolsCompanion c) =>
      into(pools).insert(c, mode: InsertMode.replace);

  Future<void> insertPoolRecipe(PoolRecipesCompanion c) =>
      into(poolRecipes).insert(c, mode: InsertMode.replace);

  Future<List<PoolData>> allPools() => select(pools).get();

  Future<PoolData?> poolById(String id) =>
      (select(pools)..where((p) => p.id.equals(id))).getSingleOrNull();

  // ---------- 设置 ----------
  Future<SettingsData?> getSettings() =>
      (select(settings)..limit(1)).getSingleOrNull();

  Future<void> ensureSettings() async {
    final existing = await (select(settings)..limit(1)).get();
    if (existing.isEmpty) {
      await into(settings).insert(const SettingsCompanion());
    }
  }

  // ---------- 搜索 / 收藏 / 历史 ----------
  Future<List<RecipeData>> searchRecipes(String query) {
    final q = query.trim();
    if (q.isEmpty) return allRecipes();
    return (select(recipes)..where((r) => r.name.contains(q))).get();
  }

  Future<List<RecipeData>> favoriteRecipes() =>
      (select(recipes)..where((r) => r.isFavorite.equals(true))).get();

  Future<List<DrawHistoryData>> history({String? poolId, int? limit}) {
    final q = select(drawHistories);
    if (poolId != null) q.where((h) => h.poolId.equals(poolId));
    q.orderBy([(h) => OrderingTerm.desc(h.drawTime)]);
    if (limit != null) q.limit(limit);
    return q.get();
  }

  Future<int> clearHistory({String? poolId}) {
    if (poolId != null) {
      return (delete(drawHistories)..where((h) => h.poolId.equals(poolId))).go();
    }
    return delete(drawHistories).go();
  }

  // ---------- 菜谱 增删改 ----------
  Future<void> updateRecipe(RecipeData r) => update(recipes).replace(r);

  Future<void> deleteRecipeComponents(String id) async {
    await (delete(ingredients)..where((t) => t.recipeId.equals(id))).go();
    await (delete(seasonings)..where((t) => t.recipeId.equals(id))).go();
    await (delete(recipeSteps)..where((t) => t.recipeId.equals(id))).go();
    await (delete(poolRecipes)..where((t) => t.recipeId.equals(id))).go();
  }

  Future<void> deleteRecipe(String id) async {
    await deleteRecipeComponents(id);
    await (delete(recipes)..where((r) => r.id.equals(id))).go();
  }

  // ---------- 签池 增删改 ----------
  Future<void> updatePool(PoolData p) => update(pools).replace(p);

  Future<void> deletePool(String id) async {
    await (delete(poolRecipes)..where((t) => t.poolId.equals(id))).go();
    await (delete(pools)..where((p) => p.id.equals(id))).go();
  }

  Future<int> removeRecipeFromPool(String poolId, String recipeId) =>
      (delete(poolRecipes)
            ..where((t) => t.poolId.equals(poolId) & t.recipeId.equals(recipeId)))
          .go();

  // ---------- 设置 ----------
  Future<void> updateSettings({
    bool? soundEnabled,
    bool? animationEnabled,
    int? excludeRecentCount,
  }) async {
    final s = await getSettings();
    if (s == null) {
      await into(settings).insert(SettingsCompanion(
        soundEnabled: Value(soundEnabled ?? true),
        animationEnabled: Value(animationEnabled ?? true),
        excludeRecentCount: Value(excludeRecentCount ?? 1),
      ));
      return;
    }
    await update(settings).replace(s.copyWith(
      soundEnabled: soundEnabled ?? s.soundEnabled,
      animationEnabled: animationEnabled ?? s.animationEnabled,
      excludeRecentCount: excludeRecentCount ?? s.excludeRecentCount,
    ));
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'what_to_eat.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
