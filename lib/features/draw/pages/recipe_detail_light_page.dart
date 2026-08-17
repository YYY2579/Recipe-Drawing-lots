import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:what_to_eat/app/theme.dart';
import 'package:what_to_eat/providers.dart';
import 'package:what_to_eat/shared/widgets/app_scaffold.dart';

/// 轻量菜谱详情（完整详情 UI 留第二批，这里先把数据展示出来）。
class RecipeDetailLightPage extends ConsumerWidget {
  final String id;
  const RecipeDetailLightPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipeAsync = ref.watch(recipeByIdProvider(id));
    final ingAsync = ref.watch(ingredientsForRecipeProvider(id));
    final seaAsync = ref.watch(seasoningsForRecipeProvider(id));
    final stepAsync = ref.watch(stepsForRecipeProvider(id));

    return AppScaffold(
      title: '菜谱详情',
      showBack: true,
      body: recipeAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('加载失败：$e')),
        data: (recipe) {
          if (recipe == null) {
            return const Center(child: Text('菜谱不存在'));
          }
          final categories =
              (jsonDecode(recipe.categoriesJson ?? '[]') as List).cast<String>();
          final flavors =
              (jsonDecode(recipe.flavorsJson ?? '[]') as List).cast<String>();
          final diff = recipe.difficulty ?? 0;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppTheme.cream,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: recipe.imagePath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(
                            File(recipe.imagePath!),
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Center(
                                child: Text('🍲', style: TextStyle(fontSize: 64))),
                          ),
                        )
                      : const Center(
                          child: Text('🍲', style: TextStyle(fontSize: 64))),
                ),
                const SizedBox(height: 16),
                Text(recipe.name,
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 6),
                Text(
                  [
                    if (categories.isNotEmpty) categories.join(' · '),
                    if (flavors.isNotEmpty) flavors.join(' · '),
                  ].join('   '),
                  style: const TextStyle(color: AppTheme.gray),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _Chip('难度 ${'★' * diff}${'☆' * (5 - diff)}'),
                    const SizedBox(width: 8),
                    _Chip('${recipe.cookingTime ?? '-'} 分钟'),
                    const SizedBox(width: 8),
                    _Chip('${recipe.servings ?? '-'} 人份'),
                  ],
                ),
                if (recipe.description != null) ...[
                  const SizedBox(height: 16),
                  Text(recipe.description!),
                ],
                const SizedBox(height: 20),
                const Text('食材',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 8),
                ingAsync.when(
                  loading: () => const Text('加载中…'),
                  error: (_, __) => const SizedBox(),
                  data: (list) => Column(
                    children: list
                        .map((i) => _RowItem(
                            name: i.name,
                            amount: _fmtAmount(i.amount, i.unit)))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('调料',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 8),
                seaAsync.when(
                  loading: () => const Text('加载中…'),
                  error: (_, __) => const SizedBox(),
                  data: (list) => Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: list
                        .map((s) => Chip(
                              label: Text(s.name),
                              backgroundColor: AppTheme.cream,
                              side: BorderSide.none,
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('烹饪步骤',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 8),
                stepAsync.when(
                  loading: () => const Text('加载中…'),
                  error: (_, __) => const SizedBox(),
                  data: (list) => Column(
                    children: list
                        .map((s) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      color: AppTheme.wood,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text('${s.stepNumber}',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 12)),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(child: Text(s.description)),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _fmtAmount(double? amount, String? unit) {
    if (amount == null) return '';
    return '${amount.toStringAsFixed(amount.truncateToDouble() == amount ? 0 : 1)}${unit ?? ''}';
  }
}

class _Chip extends StatelessWidget {
  final String label;
  const _Chip(this.label);
  @override
  Widget build(BuildContext context) => Chip(
        label: Text(label, style: const TextStyle(fontSize: 12)),
        backgroundColor: AppTheme.cream,
        side: BorderSide.none,
      );
}

class _RowItem extends StatelessWidget {
  final String name;
  final String amount;
  const _RowItem({required this.name, required this.amount});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(child: Text(name)),
            if (amount.isNotEmpty)
              Text(amount, style: const TextStyle(color: AppTheme.gray)),
          ],
        ),
      );
}
