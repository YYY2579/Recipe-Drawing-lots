import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:drift/drift.dart' hide Column;

import 'package:what_to_eat/app/theme.dart';
import 'package:what_to_eat/core/database/app_database.dart';
import 'package:what_to_eat/providers.dart';
import 'package:what_to_eat/shared/widgets/app_scaffold.dart';

/// 签池详情：管理池内菜谱（增删关联）。
class PoolDetailPage extends ConsumerWidget {
  final String id;
  const PoolDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final poolAsync = ref.watch(poolByIdProvider(id));
    final inPoolAsync = ref.watch(poolRecipesProvider(id));
    final allAsync = ref.watch(allRecipesProvider);

    return poolAsync.when(
      loading: () => const AppScaffold(
        title: '签池详情',
        showBack: true,
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => AppScaffold(
        title: '签池详情',
        showBack: true,
        body: Center(child: Text('加载失败：$e')),
      ),
      data: (pool) {
        if (pool == null) {
          return const AppScaffold(
            title: '签池详情',
            showBack: true,
            body: Center(child: Text('签池不存在')),
          );
        }
        return AppScaffold(
          title: pool.name,
          showBack: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_outline, color: AppTheme.red),
              onPressed: () => _confirmDelete(context, ref, pool),
            ),
          ],
          body: allAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('加载失败：$e')),
            data: (all) => inPoolAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('加载失败：$e')),
              data: (inPool) {
                final inIds = inPool.map((r) => r.id).toSet();
                final available = all.where((r) => !inIds.contains(r.id)).toList();
                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (pool.description != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(pool.description!,
                            style: const TextStyle(color: AppTheme.gray)),
                      ),
                    Text('池内菜谱（${inPool.length}）',
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16)),
                    const SizedBox(height: 8),
                    if (inPool.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Text('还没有菜谱，从下方添加',
                            style: TextStyle(color: AppTheme.gray)),
                      ),
                    ...inPool.map((r) => _RecipeRow(
                          name: r.name,
                          trailing: IconButton(
                            icon: const Icon(Icons.remove_circle_outline,
                                color: AppTheme.red),
                            onPressed: () async {
                              await ref
                                  .read(databaseProvider)
                                  .removeRecipeFromPool(id, r.id);
                              ref.invalidate(poolRecipesProvider(id));
                            },
                          ),
                        )),
                    const SizedBox(height: 16),
                    Text('添加更多菜谱',
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16)),
                    const SizedBox(height: 8),
                    if (available.isEmpty)
                      const Text('全部菜谱都已在池中',
                          style: TextStyle(color: AppTheme.gray)),
                    ...available.map((r) => _RecipeRow(
                          name: r.name,
                          trailing: IconButton(
                            icon: const Icon(Icons.add_circle_outline,
                                color: AppTheme.wood),
                            onPressed: () async {
                              await ref.read(databaseProvider).insertPoolRecipe(
                                PoolRecipesCompanion(
                                  poolId: Value(id),
                                  recipeId: Value(r.id),
                                ),
                              );
                              ref.invalidate(poolRecipesProvider(id));
                            },
                          ),
                        )),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, WidgetRef ref, PoolData pool) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('删除签池'),
        content: Text('确定删除「${pool.name}」吗？池内菜谱不会被删除，仅解除关联。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('删除', style: TextStyle(color: AppTheme.red)),
          ),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(databaseProvider).deletePool(pool.id);
      ref.invalidate(allPoolsProvider);
      if (context.mounted) context.pop();
    }
  }
}

class _RecipeRow extends StatelessWidget {
  final String name;
  final Widget trailing;
  const _RecipeRow({required this.name, required this.trailing});

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          title: Text(name),
          trailing: trailing,
        ),
      );
}
