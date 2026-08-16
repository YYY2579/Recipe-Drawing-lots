import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:what_to_eat/app/theme.dart';
import 'package:what_to_eat/core/database/app_database.dart';
import 'package:what_to_eat/providers.dart';
import 'package:what_to_eat/shared/widgets/app_scaffold.dart';

/// 抽签历史。
class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final histAsync = ref.watch(historyProvider);
    final poolsAsync = ref.watch(allPoolsProvider);
    final allAsync = ref.watch(allRecipesProvider);

    return AppScaffold(
      title: '抽签历史',
      showBack: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.delete_sweep_outlined),
          onPressed: () => _confirmClear(context, ref),
        ),
      ],
      body: histAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('加载失败：$e')),
        data: (hist) {
          if (hist.isEmpty) {
            return const Center(child: Text('还没有抽签记录'));
          }
          final poolName = {
            for (final p in poolsAsync.valueOrNull ?? []) p.id: p.name
          };
          final recipeName = {
            for (final r in allAsync.valueOrNull ?? <RecipeData>[])
              r.id: r.name
          };
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: hist.length,
            itemBuilder: (ctx, i) {
              final h = hist[i];
              final name = recipeName[h.recipeId] ?? '未知菜谱';
              final pn = poolName[h.poolId] ?? '';
              return Card(
                child: ListTile(
                  onTap: () => context.push('/recipe/${h.recipeId}'),
                  leading: const Icon(Icons.history, color: AppTheme.wood),
                  title: Text(name),
                  subtitle: Text(
                    [
                      if (pn.isNotEmpty) '签池：$pn',
                      _fmtTime(h.drawTime),
                    ].join('   '),
                    style: const TextStyle(color: AppTheme.gray),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: AppTheme.gray),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _fmtTime(DateTime t) {
    final now = DateTime.now();
    final sameDay = t.year == now.year &&
        t.month == now.month &&
        t.day == now.day;
    final hm = '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
    if (sameDay) return '今天 $hm';
    return '${t.month}/${t.day} $hm';
  }

  Future<void> _confirmClear(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('清空历史'),
        content: const Text('确定清空全部抽签历史吗？此操作不可恢复。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('清空', style: TextStyle(color: AppTheme.red)),
          ),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(databaseProvider).clearHistory();
      ref.invalidate(historyProvider);
    }
  }
}
