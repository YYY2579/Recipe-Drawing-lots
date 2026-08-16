import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:what_to_eat/core/database/app_database.dart';
import 'package:what_to_eat/providers.dart';
import 'package:what_to_eat/shared/widgets/app_scaffold.dart';
import 'package:what_to_eat/shared/widgets/recipe_grid.dart';

/// 我的收藏。
class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favAsync = ref.watch(favoriteRecipesProvider);
    return AppScaffold(
      title: '我的收藏',
      showBack: true,
      body: favAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('加载失败：$e')),
        data: (favs) => RecipeGrid(
          recipes: favs,
          showActions: true,
          onDelete: (r) async {
            await ref.read(databaseProvider).setFavorite(r.id, false);
            ref.invalidate(favoriteRecipesProvider);
            ref.invalidate(allRecipesProvider);
          },
        ),
      ),
    );
  }
}
