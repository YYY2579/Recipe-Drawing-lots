import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:what_to_eat/core/database/app_database.dart';
import 'package:what_to_eat/core/draw/draw_engine.dart';

/// 当前抽签状态。
class DrawState {
  final DrawResult? result;
  final bool isDrawing;

  const DrawState({this.result, this.isDrawing = false});

  DrawState copyWith({DrawResult? result, bool? isDrawing}) => DrawState(
        result: result ?? this.result,
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
    state = const DrawState(isDrawing: true);

    final recipes = await db.recipesForPool(poolId);
    final candidates =
        recipes.map((r) => RecipeRef(r.id, r.name)).toList();
    final recent = await db.recentRecipeIds(poolId, limit: 20);

    final result = DrawEngine().draw(
      candidates: candidates,
      recentRecipeIds: recent,
      excludeRecentCount: excludeRecentCount,
      poolId: poolId,
    );

    await db.insertHistory(poolId, result.recipeId);
    state = DrawState(result: result);
    return result;
  }
}
