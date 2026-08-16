import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:what_to_eat/app/theme.dart';
import 'package:what_to_eat/core/database/app_database.dart';
import 'package:what_to_eat/providers.dart';

/// 菜谱卡片（双列网格单元）。
/// 顶部食物占位 + 收藏按钮；下方菜名、分类、难度与时间。
class RecipeCard extends ConsumerWidget {
  final RecipeData recipe;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showActions;

  const RecipeCard({
    super.key,
    required this.recipe,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.showActions = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories =
        (jsonDecode(recipe.categoriesJson ?? '[]') as List).cast<String>();
    final diff = recipe.difficulty ?? 0;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 56,
                    width: 56,
                    decoration: BoxDecoration(
                      color: AppTheme.cream,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                        child: Text('🍲', style: TextStyle(fontSize: 28))),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      recipe.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: recipe.isFavorite ? AppTheme.red : AppTheme.gray,
                      size: 20,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () async {
                      await ref
                          .read(databaseProvider)
                          .setFavorite(recipe.id, !recipe.isFavorite);
                      ref.invalidate(recipeByIdProvider(recipe.id));
                      ref.invalidate(favoriteRecipesProvider);
                      ref.invalidate(allRecipesProvider);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                recipe.name,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 15),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                categories.take(2).join(' · '),
                style: const TextStyle(color: AppTheme.gray, fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Text(
                    '★' * diff + '☆' * (5 - diff),
                    style: TextStyle(color: AppTheme.wood, fontSize: 12),
                  ),
                  const Spacer(),
                  Text(
                    '${recipe.cookingTime ?? '-'}分钟',
                    style: const TextStyle(color: AppTheme.gray, fontSize: 12),
                  ),
                ],
              ),
              if (showActions) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: onEdit,
                      child: const Text('编辑'),
                    ),
                    TextButton(
                      onPressed: onDelete,
                      child: const Text('删除',
                          style: TextStyle(color: AppTheme.red)),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
