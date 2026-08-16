import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:what_to_eat/app/theme.dart';
import 'package:what_to_eat/providers.dart';
import 'package:what_to_eat/shared/widgets/app_scaffold.dart';

class ResultPage extends ConsumerWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drawState = ref.watch(drawNotifierProvider);
    final result = drawState.result;

    if (result == null) {
      return AppScaffold(
        title: '今日一签',
        showBack: true,
        body: const Center(child: Text('还没有抽签结果，去首页抽一签吧')),
      );
    }

    final recipeAsync = ref.watch(recipeByIdProvider(result.recipeId));

    return AppScaffold(
      title: '今日一签',
      showBack: true,
      body: recipeAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('加载失败：$e')),
        data: (recipe) {
          if (recipe == null) {
            return const Center(child: Text('菜谱不存在'));
          }
          final categories = (jsonDecode(recipe.categoriesJson ?? '[]') as List)
              .cast<String>();
          final flavors = (jsonDecode(recipe.flavorsJson ?? '[]') as List)
              .cast<String>();
          final diff = recipe.difficulty ?? 0;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Text('今日一签', style: TextStyle(color: AppTheme.gray)),
                const SizedBox(height: 4),
                Text(recipe.name,
                    style: Theme.of(context).textTheme.displaySmall),
                const SizedBox(height: 6),
                Text(
                  [
                    if (categories.isNotEmpty) categories.join(' · '),
                    if (flavors.isNotEmpty) flavors.join(' · '),
                  ].join('   '),
                  style: const TextStyle(color: AppTheme.gray),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _Meta(
                        label: '难度',
                        value: '★' * diff + '☆' * (5 - diff)),
                    _Meta(
                        label: '时间',
                        value: '${recipe.cookingTime ?? '-'} 分钟'),
                    _Meta(label: '份量', value: '${recipe.servings ?? '-'} 人'),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppTheme.cream,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text('🍲', style: TextStyle(fontSize: 64)),
                  ),
                ),
                const SizedBox(height: 16),
                if (recipe.description != null)
                  Text(recipe.description!,
                      style: const TextStyle(fontSize: 15)),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () =>
                            context.push('/recipe/${recipe.id}'),
                        child: const Text('查看完整菜谱'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton.filled(
                      onPressed: () async {
                        await ref
                            .read(databaseProvider)
                            .setFavorite(recipe.id, !recipe.isFavorite);
                        ref.invalidate(recipeByIdProvider(recipe.id));
                      },
                      style: IconButton.styleFrom(
                        backgroundColor: AppTheme.red,
                        foregroundColor: Colors.white,
                      ),
                      icon: Icon(recipe.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => context.pop(),
                    child: const Text('再抽一签'),
                  ),
                ),
              ],
            )
                .animate()
                .fadeIn(duration: 400.ms)
                .slideY(begin: 0.1, end: 0),
          );
        },
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  final String label;
  final String value;
  const _Meta({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(value,
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(color: AppTheme.gray, fontSize: 12)),
        ],
      );
}
