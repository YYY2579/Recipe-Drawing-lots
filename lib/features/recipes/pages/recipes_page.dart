import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:what_to_eat/app/theme.dart';
import 'package:what_to_eat/core/database/app_database.dart';
import 'package:what_to_eat/providers.dart';
import 'package:what_to_eat/shared/widgets/app_scaffold.dart';
import 'package:what_to_eat/shared/widgets/recipe_grid.dart';

const List<String> _kCategories = [
  '川菜',
  '家常菜',
  '下饭菜',
  '快手菜',
  '早餐',
  '汤羹',
  '甜品',
  '素菜',
  '肉菜',
];

/// 菜谱库：搜索 + 分类筛选 + 双列卡片网格。
class RecipesPage extends ConsumerStatefulWidget {
  const RecipesPage({super.key});

  @override
  ConsumerState<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends ConsumerState<RecipesPage> {
  final TextEditingController _search = TextEditingController();
  final Set<String> _selected = {};

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<RecipeData> _filter(List<RecipeData> all) {
    final q = _search.text.trim();
    return all.where((r) {
      if (q.isNotEmpty && !r.name.contains(q)) return false;
      if (_selected.isNotEmpty) {
        final cats =
            (jsonDecode(r.categoriesJson ?? '[]') as List).cast<String>();
        if (!cats.any((c) => _selected.contains(c))) return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final allAsync = ref.watch(allRecipesProvider);
    return AppScaffold(
      title: '菜谱库',
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => context.push('/recipes/new'),
        ),
      ],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: TextField(
              controller: _search,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: '搜索菜名',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppTheme.cream,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              ),
            ),
          ),
          SizedBox(
            height: 52,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                _FilterChip(
                  label: '全部',
                  selected: _selected.isEmpty,
                  onTap: () => setState(() => _selected.clear()),
                ),
                ..._kCategories.map((c) => _FilterChip(
                      label: c,
                      selected: _selected.contains(c),
                      onTap: () => setState(() {
                        if (_selected.contains(c)) {
                          _selected.remove(c);
                        } else {
                          _selected.add(c);
                        }
                      }),
                    )),
              ],
            ),
          ),
          Expanded(
            child: allAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('加载失败：$e')),
              data: (all) {
                final list = _filter(all);
                return RecipeGrid(
                  recipes: list,
                  showActions: true,
                  onDelete: _confirmDelete,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(RecipeData r) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('删除菜谱'),
        content: Text('确定删除「${r.name}」吗？该操作不可恢复。'),
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
      await ref.read(databaseProvider).deleteRecipe(r.id);
      ref.invalidate(allRecipesProvider);
      ref.invalidate(favoriteRecipesProvider);
    }
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(right: 8),
        child: ChoiceChip(
          label: Text(label),
          selected: selected,
          onSelected: (_) => onTap(),
          selectedColor: AppTheme.wood,
          labelStyle: TextStyle(
            color: selected ? Colors.white : AppTheme.darkBrown,
            fontSize: 13,
          ),
          backgroundColor: AppTheme.cream,
        ),
      );
}
