import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';

import 'app_database.dart';

/// V1 数据备份：导出 / 导入 JSON。
///
/// 导出格式（schemaVersion: 1）：
/// {
///   "app": "what_to_eat",
///   "schemaVersion": 1,
///   "exportedAt": "ISO8601",
///   "recipes": [ {id,name,difficulty,cookingTime,servings,description,
///                 isFavorite,categories[],flavors[],
///                 ingredients:[{name,amount,unit}],
///                 seasonings:[name], steps:[{stepNumber,description}] } ],
///   "pools":    [ {id,name,description,recipeIds:[]} ],
///   "settings": {soundEnabled,animationEnabled,excludeRecentCount} | null,
///   "history":  [ {poolId,recipeId,drawTime} ]
/// }
///
/// 导入语义：菜谱 / 签池 / 设置按 id 覆盖（upsert）；历史增量合并（已存在的跳过）。
/// 全部在事务内执行，任一失败整体回滚。

const String _backupAppTag = 'what_to_eat';
const int _backupSchemaVersion = 1;

/// 导出全部数据，并让用户选择保存位置。返回给 UI 的提示文案。
Future<String> exportBackup(AppDatabase db) async {
  final recipes = await db.allRecipes();
  final recipeList = <Map<String, dynamic>>[];
  for (final r in recipes) {
    final ings = await (db.select(db.ingredients)
          ..where((t) => t.recipeId.equals(r.id)))
        .get();
    final seas = await (db.select(db.seasonings)
          ..where((t) => t.recipeId.equals(r.id)))
        .get();
    final steps = await (db.select(db.recipeSteps)
          ..where((t) => t.recipeId.equals(r.id))
          ..orderBy([(t) => OrderingTerm.asc(t.stepNumber)]))
        .get();
    recipeList.add({
      'id': r.id,
      'name': r.name,
      'difficulty': r.difficulty,
      'cookingTime': r.cookingTime,
      'servings': r.servings,
      'description': r.description,
      'isFavorite': r.isFavorite,
      'categories': _decodeList(r.categoriesJson),
      'flavors': _decodeList(r.flavorsJson),
      'ingredients': ings
          .map((e) => {
                'name': e.name,
                'amount': e.amount,
                'unit': e.unit,
              })
          .toList(),
      'seasonings': seas.map((e) => e.name).toList(),
      'steps': steps
          .map((e) => {
                'stepNumber': e.stepNumber,
                'description': e.description,
              })
          .toList(),
    });
  }

  final pools = await db.allPools();
  final poolList = <Map<String, dynamic>>[];
  for (final p in pools) {
    final links = await (db.select(db.poolRecipes)
          ..where((t) => t.poolId.equals(p.id)))
        .get();
    poolList.add({
      'id': p.id,
      'name': p.name,
      'description': p.description,
      'recipeIds': links.map((e) => e.recipeId).toList(),
    });
  }

  final s = await db.getSettings();
  final settings = s == null
      ? null
      : {
          'soundEnabled': s.soundEnabled,
          'animationEnabled': s.animationEnabled,
          'excludeRecentCount': s.excludeRecentCount,
        };

  final histories = await db.history();
  final histList = histories
      .map((h) => {
            'poolId': h.poolId,
            'recipeId': h.recipeId,
            'drawTime': h.drawTime.toIso8601String(),
          })
      .toList();

  final payload = {
    'app': _backupAppTag,
    'schemaVersion': _backupSchemaVersion,
    'exportedAt': DateTime.now().toIso8601String(),
    'recipes': recipeList,
    'pools': poolList,
    'settings': settings,
    'history': histList,
  };

  final json = const JsonEncoder.withIndent('  ').convert(payload);

  final out = await FilePicker.platform.saveFile(
    dialogTitle: '保存备份',
    fileName: 'what_to_eat_backup.json',
    type: FileType.custom,
    allowedExtensions: ['json'],
  );
  if (out == null) return '已取消导出';

  await File(out).writeAsString(json);
  return '已导出 ${recipes.length} 道菜谱 / ${pools.length} 个签池 → $out';
}

/// 选择一个备份文件并导入。返回给 UI 的提示文案。
Future<String> importBackup(AppDatabase db) async {
  final res = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['json'],
    withData: true,
  );
  if (res == null || res.files.isEmpty) return '已取消导入';

  final file = res.files.single;
  final content = file.bytes != null
      ? utf8.decode(file.bytes!)
      : await File(file.path!).readAsString();

  late final Map<String, dynamic> data;
  try {
    data = jsonDecode(content) as Map<String, dynamic>;
  } catch (e) {
    return '文件不是合法 JSON：$e';
  }
  if (data['app'] != _backupAppTag) {
    return '文件格式不正确（不是「今日吃什么」的备份）';
  }

  final recipes = (data['recipes'] as List?) ?? [];
  final pools = (data['pools'] as List?) ?? [];
  final settings = data['settings'] as Map<String, dynamic>?;
  final history = (data['history'] as List?) ?? [];

  await db.transaction(() async {
    final importedRecipeIds = <String>{};

    for (final raw in recipes) {
      final r = raw as Map<String, dynamic>;
      final id = r['id'] as String;
      final now = DateTime.now();
      final existing = await db.recipeById(id);

      await db.insertRecipe(RecipesCompanion(
        id: Value(id),
        name: Value(r['name'] as String),
        difficulty: Value(r['difficulty'] as int?),
        cookingTime: Value(r['cookingTime'] as int?),
        servings: Value(r['servings'] as int?),
        description: Value(r['description'] as String?),
        imagePath: const Value(null),
        categoriesJson: Value(jsonEncode(r['categories'] ?? const [])),
        flavorsJson: Value(jsonEncode(r['flavors'] ?? const [])),
        isFavorite: Value(r['isFavorite'] as bool? ?? false),
        createdAt: Value(existing?.createdAt ?? now),
        updatedAt: Value(now),
      ));

      // 清掉旧组件后按备份重建（deleteRecipeComponents 同时清掉了该菜的签池关联）
      await db.deleteRecipeComponents(id);
      for (final ing in (r['ingredients'] ?? const <dynamic>[])) {
        final m = ing as Map<String, dynamic>;
        await db.insertIngredient(IngredientsCompanion(
          recipeId: Value(id),
          name: Value(m['name'] as String),
          amount: Value((m['amount'] as num?)?.toDouble()),
          unit: Value(m['unit'] as String?),
          note: const Value(null),
        ));
      }
      for (final seas in (r['seasonings'] ?? const <dynamic>[])) {
        final name = seas is String
            ? seas
            : (seas as Map<String, dynamic>)['name'] as String;
        await db.insertSeasoning(SeasoningsCompanion(
          recipeId: Value(id),
          name: Value(name),
          amount: const Value(null),
          unit: const Value(null),
          note: const Value(null),
        ));
      }
      for (final st in (r['steps'] ?? const <dynamic>[])) {
        final m = st as Map<String, dynamic>;
        await db.insertStep(RecipeStepsCompanion(
          recipeId: Value(id),
          stepNumber: Value(m['stepNumber'] as int),
          description: Value(m['description'] as String),
          imagePath: const Value(null),
        ));
      }
      importedRecipeIds.add(id);
    }

    for (final raw in pools) {
      final p = raw as Map<String, dynamic>;
      final pid = p['id'] as String;
      await db.insertPool(PoolsCompanion(
        id: Value(pid),
        name: Value(p['name'] as String),
        description: Value(p['description'] as String?),
        createdAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ));
      // 重建该池的菜谱关联（只保留备份中确实存在且已导入的菜）
      await (db.delete(db.poolRecipes)
            ..where((t) => t.poolId.equals(pid)))
          .go();
      for (final rid in (p['recipeIds'] ?? const <dynamic>[])) {
        final recipeId = rid as String;
        if (importedRecipeIds.contains(recipeId)) {
          await db.insertPoolRecipe(PoolRecipesCompanion(
            poolId: Value(pid),
            recipeId: Value(recipeId),
            weight: const Value(null),
          ));
        }
      }
    }

    if (settings != null) {
      await db.updateSettings(
        soundEnabled: settings['soundEnabled'] as bool?,
        animationEnabled: settings['animationEnabled'] as bool?,
        excludeRecentCount: settings['excludeRecentCount'] as int?,
      );
    }

    // 历史增量合并：已存在的（同池+同菜+同时间）跳过
    final existingKeys = <String>{
      for (final h in await db.history())
        '${h.poolId}|${h.recipeId}|${h.drawTime.toIso8601String()}'
    };
    for (final raw in history) {
      final h = raw as Map<String, dynamic>;
      final key =
          '${h['poolId']}|${h['recipeId']}|${h['drawTime']}';
      if (existingKeys.contains(key)) continue;
      await db.into(db.drawHistories).insert(DrawHistoriesCompanion(
        poolId: Value(h['poolId'] as String),
        recipeId: Value(h['recipeId'] as String),
        drawTime: Value(DateTime.parse(h['drawTime'] as String)),
      ));
    }
  });

  return '导入完成：${recipes.length} 道菜谱 / ${pools.length} 个签池'
      '${settings != null ? ' / 设置' : ''}';
}

List<dynamic> _decodeList(String? json) {
  if (json == null || json.isEmpty) return const [];
  try {
    final v = jsonDecode(json);
    return v is List ? v : const [];
  } catch (_) {
    return const [];
  }
}
