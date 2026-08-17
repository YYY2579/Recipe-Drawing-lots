import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:what_to_eat/core/database/app_database.dart';
import 'package:what_to_eat/core/draw/draw_engine.dart';

/// 当前抽签状态。
class DrawState {
  final DrawResult? result;
  final DrawResult? previousResult;
  final bool isDrawing;

  const DrawState({this.result, this.previousResult, this.isDrawing = false});

  DrawState copyWith({
    DrawResult? result,
    DrawResult? previousResult,
    bool? isDrawing,
  }) =>
      DrawState(
        result: result ?? this.result,
        previousResult: previousResult ?? this.previousResult,
        isDrawing: isDrawing ?? this.isDrawing,
      );
}

/// 抽签状态机：调用 DrawEngine 得出结果（先定结果），写入历史，更新 state。
/// 动画由页面负责（见 §16 算法与动画分离）。
class DrawNotifier extends StateNotifier<DrawState> {
  final AppDatabase db;
  final String poolId;
  final int excludeRecentCount;

  DrawNotifier({
    required this.db,
    required this.poolId,
    required this.excludeRecentCount,
  }) : super(const DrawState());

  Future<DrawResult> draw() async {
    final prev = state.result;
    state = const DrawState(isDrawing: true);

    // 每次抽签实时读取设置，使「幸运星」与「最近不重复」立即生效。
    final settings = await db.getSettings();
    final exclude = settings?.excludeRecentCount ?? excludeRecentCount;
    final luckyStar = settings?.luckyStarEnabled ?? false;
    // 幸运星模式：出去吃 / 点外卖 概率由 10% 提升至 40%。
    final eatOutProb = luckyStar ? 0.4 : 0.1;
    final takeoutProb = luckyStar ? 0.4 : 0.1;

    final recipes = await db.recipesForPool(poolId);
    final candidates =
        recipes.map((r) => RecipeRef(r.id, r.name)).toList();
    final recent = await db.recentRecipeIds(poolId, limit: 20);

    final result = DrawEngine().draw(
      candidates: candidates,
      recentRecipeIds: recent,
      excludeRecentCount: exclude,
      poolId: poolId,
      eatOutProbability: eatOutProb,
      takeoutProbability: takeoutProb,
    );

    await db.insertHistory(poolId, result.recipeId);
    // previousResult 保留「上一次」的结果，供主页「最近抽过」展示，
    // 避免把本次刚抽到的直接显示出来。
    state = DrawState(result: result, previousResult: prev);
    return result;
  }
}
