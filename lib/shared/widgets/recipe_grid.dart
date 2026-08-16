import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:what_to_eat/core/database/app_database.dart';
import 'package:what_to_eat/shared/widgets/recipe_card.dart';

/// 菜谱双列网格（菜谱库 / 收藏页 复用）。
class RecipeGrid extends StatelessWidget {
  final List<RecipeData> recipes;
  final bool showActions;
  final void Function(RecipeData)? onDelete;

  const RecipeGrid({
    super.key,
    required this.recipes,
    this.showActions = false,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (recipes.isEmpty) {
      return const Center(child: Text('暂无菜谱'));
    }
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemCount: recipes.length,
      itemBuilder: (ctx, i) {
        final r = recipes[i];
        return RecipeCard(
          recipe: r,
          onTap: () => ctx.push('/recipe/${r.id}'),
          onEdit: () => ctx.push('/recipe/${r.id}/edit'),
          onDelete: onDelete == null ? null : () => onDelete!(r),
          showActions: showActions,
        );
      },
    );
  }
}
