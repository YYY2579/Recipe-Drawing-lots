import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:what_to_eat/app/theme.dart';
import 'package:what_to_eat/core/draw/draw_engine.dart';
import 'package:what_to_eat/core/sound/sound_service.dart';
import 'package:what_to_eat/providers.dart';
import 'package:what_to_eat/shared/widgets/app_scaffold.dart';

class ResultPage extends ConsumerWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drawState = ref.watch(drawNotifierProvider);
    final result = drawState.result;
    final soundEnabled =
        ref.watch(settingsProvider).valueOrNull?.soundEnabled ?? true;

    if (result == null) {
      return AppScaffold(
        title: '今日一签',
        showBack: true,
        body: const Center(child: Text('还没有抽签结果，去首页抽一签吧')),
      );
    }

    // 特殊选项（出去吃 / 点外卖）：直接展示，不走菜谱详情。
    if (isSpecialOption(result.recipeId)) {
      return AppScaffold(
        title: '今日一签',
        showBack: true,
        body: _SpecialResult(
          name: result.recipeName,
          onReveal: soundEnabled
              ? () => ref.read(soundServiceProvider).playReveal()
              : null,
        ),
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
          final categories =
              (jsonDecode(recipe.categoriesJson ?? '[]') as List).cast<String>();
          final flavors =
              (jsonDecode(recipe.flavorsJson ?? '[]') as List).cast<String>();
          final diff = recipe.difficulty ?? 0;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Text('今日一签', style: TextStyle(color: AppTheme.gray)),
                const SizedBox(height: 12),
                // 可翻转的竹签：点击揭示菜名
                _FlipStick(
                  backText: recipe.name,
                  onReveal: soundEnabled
                      ? () => ref.read(soundServiceProvider).playReveal()
                      : null,
                ),
                const SizedBox(height: 10),
                Text(
                  [
                    if (categories.isNotEmpty) categories.join(' · '),
                    if (flavors.isNotEmpty) flavors.join(' · '),
                  ].join('   '),
                  style: const TextStyle(color: AppTheme.gray),
                  textAlign: TextAlign.center,
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
                  child: recipe.imagePath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(
                            File(recipe.imagePath!),
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Center(child: Text('🍲', style: TextStyle(fontSize: 64))),
                          ),
                        )
                      : const Center(
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

/// 真实菜谱结果的翻转竹签。
class _FlipStick extends StatefulWidget {
  final String backText;
  final VoidCallback? onReveal;
  const _FlipStick({required this.backText, this.onReveal});

  @override
  State<_FlipStick> createState() => _FlipStickState();
}

class _FlipStickState extends State<_FlipStick>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
  late final Animation<double> _angle =
      Tween<double>(begin: 0, end: pi).animate(
    CurvedAnimation(parent: _ctrl, curve: Curves.easeInOutBack),
  );
  bool _revealed = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onTap() {
    if (_revealed) return;
    _revealed = true;
    _ctrl.forward();
    widget.onReveal?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: AnimatedBuilder(
        animation: _angle,
        builder: (ctx, _) {
          final showBack = _angle.value >= pi / 2;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(_angle.value),
            child: showBack
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(pi),
                    child: _stickFace(child: Center(child: Text(widget.backText,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 24)))),
                  )
                : _stickFace(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('签', style: TextStyle(fontSize: 28, color: Color(0xFFB84A3A))),
                        SizedBox(height: 6),
                        Text('点击揭晓', style: TextStyle(fontSize: 12, color: Color(0x8892796B))),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget _stickFace({required Widget child}) => Container(
        width: 96,
        height: 200,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFE9D9A8), Color(0xFFCBB57A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(48),
          boxShadow: const [
            BoxShadow(color: Color(0x33000000), blurRadius: 8, offset: Offset(0, 4)),
          ],
          border: Border.all(color: Color(0xFFB98252), width: 2),
        ),
        child: child,
      );
}

/// 特殊选项（出去吃 / 点外卖）的结果展示。
class _SpecialResult extends StatefulWidget {
  final String name;
  final VoidCallback? onReveal;
  const _SpecialResult({required this.name, this.onReveal});

  @override
  State<_SpecialResult> createState() => _SpecialResultState();
}

class _SpecialResultState extends State<_SpecialResult>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
  late final Animation<double> _angle =
      Tween<double>(begin: 0, end: pi).animate(
    CurvedAnimation(parent: _ctrl, curve: Curves.easeInOutBack),
  );
  bool _revealed = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onTap() {
    if (_revealed) return;
    _revealed = true;
    _ctrl.forward();
    widget.onReveal?.call();
  }

  @override
  Widget build(BuildContext context) {
    final isEatOut = widget.name == kOptEatOutName;
    final tip = isEatOut ? '今天不用做饭，出去搓一顿！' : '今天躺平，点个外卖吧！';
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 24),
            GestureDetector(
              onTap: _onTap,
              child: AnimatedBuilder(
                animation: _angle,
                builder: (ctx, _) {
                  final showBack = _angle.value >= pi / 2;
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(_angle.value),
                    child: showBack
                        ? Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(pi),
                            child: _goldStick(widget.name),
                          )
                        : _goldStick('点击揭晓'),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            if (_revealed)
              Text(tip,
                  style: const TextStyle(fontSize: 16, color: AppTheme.darkBrown))
              .animate()
              .fadeIn(),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => context.pop(),
                child: const Text('再抽一签'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _goldStick(String text) => Container(
        width: 110,
        height: 200,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFF6E7B0), Color(0xFFE2C067)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(55),
          border: Border.all(color: Color(0xFFC9A23B), width: 2),
          boxShadow: const [
            BoxShadow(color: Color(0x33000000), blurRadius: 10, offset: Offset(0, 4)),
          ],
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 22, color: Color(0xFF7A5B12)),
            ),
          ),
        ),
      );
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
