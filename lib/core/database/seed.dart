import 'dart:convert';

import 'package:drift/drift.dart';

import 'app_database.dart';

/// 首次启动时把 `assets/seed/*.json` 写入本地库（仅当 Recipes 为空）。
/// [recipes] / [pools] 为已解析的 JSON（List<dynamic>）。
Future<void> seedIfEmpty(
  AppDatabase db, {
  required List<dynamic> recipes,
  required List<dynamic> pools,
}) async {
  if (await db.countRecipes() > 0) return;

  for (final raw in recipes) {
    final r = raw as Map<String, dynamic>;
    final id = r['id'] as String;
    final now = DateTime.now();

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
      createdAt: Value(now),
      updatedAt: Value(now),
    ));

    for (final ing in (r['ingredients'] ?? <dynamic>[])) {
      final m = ing as Map<String, dynamic>;
      await db.insertIngredient(IngredientsCompanion(
        recipeId: Value(id),
        name: Value(m['name'] as String),
        amount: Value((m['amount'] as num?)?.toDouble()),
        unit: Value(m['unit'] as String?),
        note: const Value(null),
      ));
    }

    for (final s in (r['seasonings'] ?? <dynamic>[])) {
      final name = s is String ? s : (s as Map<String, dynamic>)['name'] as String;
      await db.insertSeasoning(SeasoningsCompanion(
        recipeId: Value(id),
        name: Value(name),
        amount: const Value(null),
        unit: const Value(null),
        note: const Value(null),
      ));
    }

    for (final st in (r['steps'] ?? <dynamic>[])) {
      final m = st as Map<String, dynamic>;
      await db.insertStep(RecipeStepsCompanion(
        recipeId: Value(id),
        stepNumber: Value(m['stepNumber'] as int),
        description: Value(m['description'] as String),
        imagePath: const Value(null),
      ));
    }
  }

  for (final raw in pools) {
    final p = raw as Map<String, dynamic>;
    final now = DateTime.now();
    await db.insertPool(PoolsCompanion(
      id: Value(p['id'] as String),
      name: Value(p['name'] as String),
      description: Value(p['description'] as String?),
      createdAt: Value(now),
      updatedAt: Value(now),
    ));
    for (final rid in (p['recipeIds'] ?? <dynamic>[])) {
      await db.insertPoolRecipe(PoolRecipesCompanion(
        poolId: Value(p['id'] as String),
        recipeId: Value(rid as String),
        weight: const Value(null),
      ));
    }
  }

  await db.ensureSettings();
}
