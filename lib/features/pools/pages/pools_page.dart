import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:drift/drift.dart' hide Column;

import 'package:what_to_eat/app/theme.dart';
import 'package:what_to_eat/core/database/app_database.dart';
import 'package:what_to_eat/providers.dart';
import 'package:what_to_eat/shared/widgets/app_scaffold.dart';

/// 签池列表：新建 / 编辑 / 删除签池，点进管理池内菜谱。
class PoolsPage extends ConsumerWidget {
  const PoolsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final poolsAsync = ref.watch(allPoolsProvider);
    return AppScaffold(
      title: '签池',
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => _showPoolDialog(context, ref),
        ),
      ],
      body: poolsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('加载失败：$e')),
        data: (pools) {
          if (pools.isEmpty) {
            return const Center(child: Text('还没有签池，点右上角 + 新建'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: pools.length,
            itemBuilder: (ctx, i) => _PoolTile(
              pool: pools[i],
              onTap: () => context.push('/pools/${pools[i].id}'),
              onEdit: () => _showPoolDialog(context, ref, pools[i]),
              onDelete: () => _confirmDelete(context, ref, pools[i]),
            ),
          );
        },
      ),
    );
  }

  Future<void> _showPoolDialog(BuildContext context, WidgetRef ref,
      [PoolData? pool]) async {
    final nameC = TextEditingController(text: pool?.name ?? '');
    final descC = TextEditingController(text: pool?.description ?? '');
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(pool == null ? '新建签池' : '编辑签池'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameC,
              decoration: const InputDecoration(labelText: '名称'),
            ),
            TextField(
              controller: descC,
              decoration: const InputDecoration(labelText: '描述（可选）'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('保存'),
          ),
        ],
      ),
    );
    if (saved == true) {
      final name = nameC.text.trim();
      if (name.isEmpty) return;
      final db = ref.read(databaseProvider);
      final now = DateTime.now();
      final desc = descC.text.trim().isEmpty ? null : descC.text.trim();
      if (pool == null) {
        final id = 'p${now.microsecondsSinceEpoch}';
        await db.insertPool(PoolsCompanion(
          id: Value(id),
          name: Value(name),
          description: Value(desc),
          createdAt: Value(now),
          updatedAt: Value(now),
        ));
      } else {
        await db.updatePool(pool.copyWith(
          name: name,
          description: Value(desc),
          updatedAt: Value(now),
        ));
      }
      ref.invalidate(allPoolsProvider);
    }
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
    }
  }
}

class _PoolTile extends ConsumerWidget {
  final PoolData pool;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _PoolTile({
    required this.pool,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countAsync = ref.watch(poolRecipesProvider(pool.id));
    final count =
        countAsync.when(data: (l) => l.length, loading: () => 0, error: (_, __) => 0);
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppTheme.cream,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.list_alt_outlined, color: AppTheme.wood),
        ),
        title: Text(pool.name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: pool.description != null ? Text(pool.description!) : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$count 道', style: const TextStyle(color: AppTheme.gray)),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, color: AppTheme.gray),
          ],
        ),
      ),
    );
  }
}
