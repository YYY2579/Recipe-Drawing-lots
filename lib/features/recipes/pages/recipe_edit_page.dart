import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:drift/drift.dart' hide Column;

import 'package:what_to_eat/app/theme.dart';
import 'package:what_to_eat/core/database/app_database.dart';
import 'package:what_to_eat/providers.dart';
import 'package:what_to_eat/shared/widgets/app_scaffold.dart';

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

const List<String> _kFlavors = [
  '五香', '卤香', '咖喱', '咸甜', '咸辣', '咸香', '咸鲜', '嫩', '孜然',
  '干香', '微辣', '清润', '清淡', '清爽', '清甜', '清鲜', '烟香', '甜',
  '甜咸', '糊辣', '糊辣荔枝口', '红油', '荔枝口', '葱香', '蒜香', '蜜汁',
  '酥脆', '酱香', '酸甜', '酸甜微辣', '酸辣', '香辣', '鲜', '鲜香', '麻辣',
];

/// 新建 / 编辑菜谱入口。id 为 'new' 表示新建，否则为菜谱 id。
class RecipeEditPage extends ConsumerWidget {
  final String id;
  const RecipeEditPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (id == 'new') {
      return const RecipeForm(
        initial: null,
        initialIngredients: [],
        initialSeasonings: [],
        initialSteps: [],
      );
    }

    final recipeAsync = ref.watch(recipeByIdProvider(id));
    final ingAsync = ref.watch(ingredientsForRecipeProvider(id));
    final seaAsync = ref.watch(seasoningsForRecipeProvider(id));
    final stepAsync = ref.watch(stepsForRecipeProvider(id));

    return recipeAsync.when(
      loading: () => const AppScaffold(
        title: '编辑菜谱',
        showBack: true,
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => AppScaffold(
        title: '编辑菜谱',
        showBack: true,
        body: Center(child: Text('加载失败：$e')),
      ),
      data: (recipe) {
        if (recipe == null) {
          return const AppScaffold(
            title: '编辑菜谱',
            showBack: true,
            body: Center(child: Text('菜谱不存在')),
          );
        }
        return ingAsync.when(
          loading: () => const AppScaffold(
            title: '编辑菜谱',
            showBack: true,
            body: Center(child: CircularProgressIndicator()),
          ),
          error: (_, __) => const SizedBox(),
          data: (ings) => seaAsync.when(
            loading: () => const AppScaffold(
              title: '编辑菜谱',
              showBack: true,
              body: Center(child: CircularProgressIndicator()),
            ),
            error: (_, __) => const SizedBox(),
            data: (seas) => stepAsync.when(
              loading: () => const AppScaffold(
                title: '编辑菜谱',
                showBack: true,
                body: Center(child: CircularProgressIndicator()),
              ),
              error: (_, __) => const SizedBox(),
              data: (steps) => RecipeForm(
                initial: recipe,
                initialIngredients: ings,
                initialSeasonings: seas,
                initialSteps: steps,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _IngredientField {
  final TextEditingController name = TextEditingController();
  final TextEditingController amount = TextEditingController();
  final TextEditingController unit = TextEditingController();
  void dispose() {
    name.dispose();
    amount.dispose();
    unit.dispose();
  }
}

/// 菜谱表单（新增 / 编辑共用）。
class RecipeForm extends ConsumerStatefulWidget {
  final RecipeData? initial;
  final List<IngredientData> initialIngredients;
  final List<SeasoningData> initialSeasonings;
  final List<RecipeStepData> initialSteps;

  const RecipeForm({
    super.key,
    required this.initial,
    required this.initialIngredients,
    required this.initialSeasonings,
    required this.initialSteps,
  });

  @override
  ConsumerState<RecipeForm> createState() => _RecipeFormState();
}

class _RecipeFormState extends ConsumerState<RecipeForm> {
  final _name = TextEditingController();
  final _time = TextEditingController();
  final _servings = TextEditingController();
  final _description = TextEditingController();
  int _difficulty = 2;
  late final Set<String> _selectedCategories;
  late final Set<String> _selectedFlavors;
  final List<_IngredientField> _ingredients = [];
  final List<TextEditingController> _seasonings = [];
  final List<TextEditingController> _steps = [];

  @override
  void initState() {
    super.initState();
    final r = widget.initial;
    _name.text = r?.name ?? '';
    _time.text = r?.cookingTime?.toString() ?? '';
    _servings.text = r?.servings?.toString() ?? '';
    _description.text = r?.description ?? '';
    _difficulty = r?.difficulty ?? 2;
    _selectedCategories = {
      ...(r == null
          ? <String>[]
          : (jsonDecode(r.categoriesJson ?? '[]') as List).cast<String>())
    };
    _selectedFlavors = {
      ...(r == null
          ? <String>[]
          : (jsonDecode(r.flavorsJson ?? '[]') as List).cast<String>())
    };
    for (final ing in widget.initialIngredients) {
      final f = _IngredientField()
        ..name.text = ing.name
        ..amount.text = ing.amount?.toString() ?? ''
        ..unit.text = ing.unit ?? '';
      _ingredients.add(f);
    }
    for (final s in widget.initialSeasonings) {
      _seasonings.add(TextEditingController(text: s.name));
    }
    for (final s in widget.initialSteps) {
      _steps.add(TextEditingController(text: s.description));
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _time.dispose();
    _servings.dispose();
    _description.dispose();
    for (final f in _ingredients) f.dispose();
    for (final c in _seasonings) c.dispose();
    for (final c in _steps) c.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请填写菜名')),
      );
      return;
    }
    final db = ref.read(databaseProvider);
    final now = DateTime.now();
    final categories = _selectedCategories.toList();
    final flavors = _selectedFlavors.toList();

    if (widget.initial == null) {
      final newId = 'r${now.microsecondsSinceEpoch}';
      await db.insertRecipe(RecipesCompanion(
        id: Value(newId),
        name: Value(name),
        difficulty: Value(_difficulty),
        cookingTime: Value(int.tryParse(_time.text.trim())),
        servings: Value(int.tryParse(_servings.text.trim())),
        description: Value(_description.text.trim().isEmpty
            ? null
            : _description.text.trim()),
        categoriesJson: Value(jsonEncode(categories)),
        flavorsJson: Value(jsonEncode(flavors)),
        createdAt: Value(now),
        updatedAt: Value(now),
      ));
      await _writeComponents(db, newId);
      ref.invalidate(allRecipesProvider);
    } else {
      final id = widget.initial!.id;
      final updated = widget.initial!.copyWith(
        name: name,
        difficulty: Value(_difficulty),
        cookingTime: Value(int.tryParse(_time.text.trim())),
        servings: Value(int.tryParse(_servings.text.trim())),
        description: Value(_description.text.trim().isEmpty
            ? null
            : _description.text.trim()),
        categoriesJson: Value(jsonEncode(categories)),
        flavorsJson: Value(jsonEncode(flavors)),
        updatedAt: Value(now),
      );
      await db.deleteRecipeComponents(id);
      await db.updateRecipe(updated);
      await _writeComponents(db, id);
      ref.invalidate(recipeByIdProvider(id));
      ref.invalidate(allRecipesProvider);
    }
    if (mounted) context.pop();
  }

  Future<void> _writeComponents(AppDatabase db, String id) async {
    for (final f in _ingredients) {
      final n = f.name.text.trim();
      if (n.isEmpty) continue;
      await db.insertIngredient(IngredientsCompanion(
        recipeId: Value(id),
        name: Value(n),
        amount: Value(double.tryParse(f.amount.text.trim())),
        unit: Value(f.unit.text.trim().isEmpty ? null : f.unit.text.trim()),
      ));
    }
    for (final c in _seasonings) {
      final n = c.text.trim();
      if (n.isEmpty) continue;
      await db.insertSeasoning(SeasoningsCompanion(
        recipeId: Value(id),
        name: Value(n),
      ));
    }
    for (var i = 0; i < _steps.length; i++) {
      final d = _steps[i].text.trim();
      if (d.isEmpty) continue;
      await db.insertStep(RecipeStepsCompanion(
        recipeId: Value(id),
        stepNumber: Value(i + 1),
        description: Value(d),
      ));
    }
  }

  void _addIngredient() => setState(() => _ingredients.add(_IngredientField()));
  void _removeIngredient(int i) => setState(() {
        _ingredients[i].dispose();
        _ingredients.removeAt(i);
      });
  void _addSeasoning() =>
      setState(() => _seasonings.add(TextEditingController()));
  void _removeSeasoning(int i) => setState(() {
        _seasonings[i].dispose();
        _seasonings.removeAt(i);
      });
  void _addStep() => setState(() => _steps.add(TextEditingController()));
  void _removeStep(int i) => setState(() {
        _steps[i].dispose();
        _steps.removeAt(i);
      });

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: widget.initial == null ? '新建菜谱' : '编辑菜谱',
      showBack: true,
      actions: [
        TextButton(onPressed: _save, child: const Text('保存')),
      ],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('基本信息'),
            TextField(
              controller: _name,
              decoration: const InputDecoration(labelText: '菜名'),
            ),
            const SizedBox(height: 12),
            const Text('难度', style: TextStyle(color: AppTheme.gray)),
            Wrap(
              spacing: 8,
              children: List.generate(5, (i) {
                final v = i + 1;
                return ChoiceChip(
                  label: Text('★' * v),
                  selected: _difficulty == v,
                  onSelected: (_) => setState(() => _difficulty = v),
                  selectedColor: AppTheme.wood,
                  labelStyle: TextStyle(
                    color: _difficulty == v ? Colors.white : AppTheme.darkBrown,
                  ),
                  backgroundColor: AppTheme.cream,
                );
              }),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _time,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: '时长（分钟）'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _servings,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: '份量（人）'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _description,
              maxLines: 3,
              decoration: const InputDecoration(labelText: '简介（可选）'),
            ),
            const SizedBox(height: 16),
            _sectionTitle('分类'),
            _chips(
              {..._kCategories, ..._selectedCategories}.toList(),
              _selectedCategories,
              (c) => setState(() {
                if (_selectedCategories.contains(c)) {
                  _selectedCategories.remove(c);
                } else {
                  _selectedCategories.add(c);
                }
              }),
            ),
            const SizedBox(height: 16),
            _sectionTitle('口味'),
            _chips(
              {..._kFlavors, ..._selectedFlavors}.toList(),
              _selectedFlavors,
              (c) => setState(() {
                if (_selectedFlavors.contains(c)) {
                  _selectedFlavors.remove(c);
                } else {
                  _selectedFlavors.add(c);
                }
              }),
            ),
            const SizedBox(height: 16),
            _sectionTitle('食材'),
            ..._ingredients.asMap().entries.map((e) {
              final i = e.key;
              final f = e.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: f.name,
                        decoration: const InputDecoration(hintText: '名称'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: f.amount,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(hintText: '量'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: f.unit,
                        decoration: const InputDecoration(hintText: '单位'),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline,
                          color: AppTheme.red),
                      onPressed: () => _removeIngredient(i),
                    ),
                  ],
                ),
              );
            }),
            TextButton.icon(
              onPressed: _addIngredient,
              icon: const Icon(Icons.add),
              label: const Text('添加食材'),
            ),
            const SizedBox(height: 16),
            _sectionTitle('调料'),
            ..._seasonings.asMap().entries.map((e) {
              final i = e.key;
              final c = e.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: c,
                        decoration: const InputDecoration(hintText: '名称'),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline,
                          color: AppTheme.red),
                      onPressed: () => _removeSeasoning(i),
                    ),
                  ],
                ),
              );
            }),
            TextButton.icon(
              onPressed: _addSeasoning,
              icon: const Icon(Icons.add),
              label: const Text('添加调料'),
            ),
            const SizedBox(height: 16),
            _sectionTitle('步骤'),
            ..._steps.asMap().entries.map((e) {
              final i = e.key;
              final c = e.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      margin: const EdgeInsets.only(top: 12),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: AppTheme.wood,
                        shape: BoxShape.circle,
                      ),
                      child: Text('${i + 1}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: c,
                        maxLines: 2,
                        decoration: const InputDecoration(hintText: '步骤说明'),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline,
                          color: AppTheme.red),
                      onPressed: () => _removeStep(i),
                    ),
                  ],
                ),
              );
            }),
            TextButton.icon(
              onPressed: _addStep,
              icon: const Icon(Icons.add),
              label: const Text('添加步骤'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(t,
            style: const TextStyle(
                fontWeight: FontWeight.w700, fontSize: 16, color: AppTheme.darkBrown)),
      );

  Widget _chips(List<String> items, Set<String> selected, void Function(String) onToggle) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((c) {
        final isSel = selected.contains(c);
        return ChoiceChip(
          label: Text(c),
          selected: isSel,
          onSelected: (_) => onToggle(c),
          selectedColor: AppTheme.wood,
          labelStyle: TextStyle(
            color: isSel ? Colors.white : AppTheme.darkBrown,
            fontSize: 13,
          ),
          backgroundColor: AppTheme.cream,
        );
      }).toList(),
    );
  }
}
