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
    CookingRecords,
    CookingRecordItems,
    CookingTemplates,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  Future<void> onUpgrade(Migrator m, int from, int to) async {
    if (from < 2) {
      // 新增幸运星开关列
      await m.alterTable(TableMigration(settings,
          newColumns: [settings.luckyStarEnabled]));
      // 新增做饭记录三表
      await m.createTable(cookingRecords);
      await m.createTable(cookingRecordItems);
      await m.createTable(cookingTemplates);
    }
    if (from < 3) {
      // 记账条目新增「分类」列（可空，历史数据按「其他」统计）。
      await m.alterTable(TableMigration(cookingRecordItems,
          newColumns: [cookingRecordItems.category]));
    }
  }

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

  /// 删除菜谱的详情组件（食材 / 调料 / 步骤），保留签池关联。
  /// 编辑菜谱保存时用它「先清空再重插」，避免误删池内关联。
  Future<void> deleteRecipeDetailComponents(String id) async {
    await (delete(ingredients)..where((t) => t.recipeId.equals(id))).go();
    await (delete(seasonings)..where((t) => t.recipeId.equals(id))).go();
    await (delete(recipeSteps)..where((t) => t.recipeId.equals(id))).go();
  }

  /// 删除菜谱及其全部关联（详情组件 + 签池关联）。
  /// 用于整菜删除、备份导入重建关联。
  Future<void> deleteRecipeComponents(String id) async {
    await deleteRecipeDetailComponents(id);
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
    bool? luckyStarEnabled,
  }) async {
    final s = await getSettings();
    if (s == null) {
      await into(settings).insert(SettingsCompanion(
        soundEnabled: Value(soundEnabled ?? true),
        animationEnabled: Value(animationEnabled ?? true),
        excludeRecentCount: Value(excludeRecentCount ?? 1),
        luckyStarEnabled: Value(luckyStarEnabled ?? false),
      ));
      return;
    }
    await update(settings).replace(s.copyWith(
      soundEnabled: soundEnabled ?? s.soundEnabled,
      animationEnabled: animationEnabled ?? s.animationEnabled,
      excludeRecentCount: excludeRecentCount ?? s.excludeRecentCount,
      luckyStarEnabled: luckyStarEnabled ?? s.luckyStarEnabled,
    ));
  }

  // ---------- 做饭记录 ----------
  /// 插入一条全新的独立记录。用于「记一笔」每次独立成条（时间线每笔各自可见）。
  Future<int> insertCookingRecord(DateTime when, {String? note}) {
    return into(cookingRecords).insert(CookingRecordsCompanion(
      recordDate: Value(when),
      createdAt: Value(DateTime.now()),
      note: Value(note),
    ));
  }

  /// 更新主记录日期（补录 / 改日期），日期截断到当天 00:00。
  Future<void> updateCookingRecordDate(int id, DateTime day) async {
    final start = DateTime(day.year, day.month, day.day);
    await (update(cookingRecords)..where((t) => t.id.equals(id)))
        .write(CookingRecordsCompanion(recordDate: Value(start)));
  }

  Future<void> insertCookingItem(int recordId, String dishName,
      {double? price, String? note, String? category}) {
    return into(cookingRecordItems).insert(CookingRecordItemsCompanion(
      recordId: Value(recordId),
      dishName: Value(dishName),
      price: Value(price),
      note: Value(note),
      category: Value(category),
    ));
  }

  Future<void> updateCookingItem(CookingRecordItemData item) =>
      update(cookingRecordItems).replace(item);

  Future<void> deleteCookingItem(int id) =>
      (delete(cookingRecordItems)..where((t) => t.id.equals(id))).go();

  /// 删除某条记录下的全部条目（编辑记录前清空，避免重复）。
  Future<void> deleteItemsForRecord(int recordId) =>
      (delete(cookingRecordItems)..where((t) => t.recordId.equals(recordId)))
          .go();

  Future<void> deleteCookingRecord(int id) async {
    await (delete(cookingRecordItems)..where((t) => t.recordId.equals(id)))
        .go();
    await (delete(cookingRecords)..where((t) => t.id.equals(id))).go();
  }

  /// 全部做饭记录（按天倒序），用于时间线。
  Future<List<CookingRecordData>> allCookingRecords() =>
      (select(cookingRecords)
            ..orderBy([(t) => OrderingTerm.desc(t.recordDate)]))
          .get();

  Future<List<CookingRecordItemData>> itemsForRecord(int recordId) =>
      (select(cookingRecordItems)..where((t) => t.recordId.equals(recordId)))
          .get();

  /// 周期消费统计：返回 `[from, to)` 区间（含 from、不含 to 次日）内所有条目的总花费。
  /// 用「次日 00:00 开区间」判断，彻底规避 recordDate 带任意时分秒/亚秒时
  /// 闭区间 `23:59:59` 可能命不中的边界问题。
  Future<double> totalSpentBetween(DateTime from, DateTime to) async {
    final endExcl = _nextDay(to);
    final records = await (select(cookingRecords)
          ..where((t) =>
              t.recordDate.isBiggerOrEqualValue(from) &
              t.recordDate.isSmallerThanValue(endExcl)))
        .get();
    if (records.isEmpty) return 0;
    final ids = records.map((r) => r.id).toList();
    final items = await (select(cookingRecordItems)
          ..where((t) => t.recordId.isIn(ids)))
        .get();
    return items.fold<double>(
        0, (sum, it) => sum + (it.price ?? 0));
  }

  /// 全部记录的累计支出（用于主页顶部「累计支出」汇总）。
  Future<double> totalSpentAll() async {
    final items = await (select(cookingRecordItems)).get();
    return items.fold<double>(0, (sum, it) => sum + (it.price ?? 0));
  }

  /// 区间内的「记录条目 + 所属记录日期」，供自定义时间段统计使用。
  /// 返回 (条目, 记录日期) 列表；记录日期用于按日聚合趋势。
  /// 用 `[from, to)` 次日开区间，规避 recordDate 时分秒/亚秒边界命不中的问题。
  Future<List<(CookingRecordItemData, DateTime)>> itemsWithDateBetween(
      DateTime from, DateTime to) async {
    final endExcl = _nextDay(to);
    final records = await (select(cookingRecords)
          ..where((t) =>
              t.recordDate.isBiggerOrEqualValue(from) &
              t.recordDate.isSmallerThanValue(endExcl)))
        .get();
    if (records.isEmpty) return const [];
    final ids = records.map((r) => r.id).toList();
    final items = await (select(cookingRecordItems)
          ..where((t) => t.recordId.isIn(ids)))
        .get();
    final dateOf = {for (final r in records) r.id: r.recordDate};
    return items
        .where((it) => dateOf.containsKey(it.recordId))
        .map((it) => (it, dateOf[it.recordId]!))
        .toList();
  }

  /// 返回 [d] 当天的下一天 00:00（用于 `[from, to)` 的左闭右开统计边界）。
  static DateTime _nextDay(DateTime d) =>
      DateTime(d.year, d.month, d.day + 1);

  // ---------- 做饭记录模板 ----------
  Future<int> insertCookingTemplate(String name, String itemsJson) =>
      into(cookingTemplates).insert(CookingTemplatesCompanion(
        name: Value(name),
        itemsJson: Value(itemsJson),
      ));

  Future<List<CookingTemplateData>> allCookingTemplates() =>
      select(cookingTemplates).get();

  Future<void> deleteCookingTemplate(int id) =>
      (delete(cookingTemplates)..where((t) => t.id.equals(id))).go();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'what_to_eat.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
