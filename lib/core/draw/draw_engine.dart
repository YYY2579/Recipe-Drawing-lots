/// 抽签引擎（纯 Dart，不依赖 Flutter / drift / riverpod）
///
/// 设计原则对应规划文档：
/// - §11 抽签算法 V1：普通随机
/// - §12 候选不足处理：排除条件自动降级，保证一定有结果
/// - §13 抽签算法 V2：权重抽签（预留）
/// - §16 / §29 算法与动画分离：DrawEngine 只负责"抽什么"，不碰 UI
/// - §30 DrawResult：统一结果结构，含 animationSeed 供动画复现/调试
///
/// 该文件不引用任何 Flutter 依赖，因此可以在纯 Dart 单测中验证逻辑，
/// 也方便以后接入后端 / 单元测试。

import 'dart:math';

/// 候选菜谱引用（签池内的一个菜，含可选权重）
class RecipeRef {
  final String id;
  final String name;
  /// 权重（V2 用）。null 或 <=0 表示不参与加权，退化为普通随机
  final double? weight;

  const RecipeRef(this.id, this.name, [this.weight]);

  factory RecipeRef.fromJson(Map<String, dynamic> json) => RecipeRef(
        json['id'] as String,
        json['name'] as String,
        (json['weight'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        if (weight != null) 'weight': weight,
      };
}

/// 统一抽签结果（对应 §30）
class DrawResult {
  final String recipeId;
  final String recipeName;
  final String poolId;
  final DateTime timestamp;
  /// 由结果与时间派生，仅用于驱动签筒动画的随机扰动，不影响抽签结果本身
  final int animationSeed;

  const DrawResult({
    required this.recipeId,
    required this.recipeName,
    required this.poolId,
    required this.timestamp,
    required this.animationSeed,
  });

  Map<String, dynamic> toJson() => {
        'recipeId': recipeId,
        'recipeName': recipeName,
        'poolId': poolId,
        'timestamp': timestamp.toIso8601String(),
        'animationSeed': animationSeed,
      };
}

class DrawException implements Exception {
  final String message;
  const DrawException(this.message);
  @override
  String toString() => 'DrawException: $message';
}

class DrawEngine {
  final Random _random;

  DrawEngine([Random? random]) : _random = random ?? Random();

  /// 执行一次抽签
  ///
  /// [candidates]        当前签池内的候选菜谱（含可选权重）
  /// [recentRecipeIds]   抽签历史中最近的 recipeId，按时间倒序（最新在前）
  /// [excludeRecentCount] 最近 N 次不重复（0 表示不排除）
  /// [poolId]            当前签池 id
  DrawResult draw({
    required List<RecipeRef> candidates,
    required List<String> recentRecipeIds,
    required int excludeRecentCount,
    required String poolId,
  }) {
    if (candidates.isEmpty) {
      throw const DrawException('签池为空，无法抽签');
    }

    // §12 候选不足时自动降低排除条件，保证一定能得到结果
    Set<String> excluded = {};
    int n = excludeRecentCount.clamp(0, candidates.length - 1);
    while (n > 0) {
      final toExclude = recentRecipeIds.take(n).toSet();
      final remaining = candidates.where((c) => !toExclude.contains(c.id)).length;
      if (remaining >= 1) {
        excluded = toExclude;
        break;
      }
      n--;
    }

    final filtered = candidates.where((c) => !excluded.contains(c.id)).toList();
    final finalCandidates = filtered.isNotEmpty ? filtered : candidates;

    final RecipeRef picked = _pick(finalCandidates);

    final now = DateTime.now();
    return DrawResult(
      recipeId: picked.id,
      recipeName: picked.name,
      poolId: poolId,
      timestamp: now,
      animationSeed: _animationSeed(picked.id, now),
    );
  }

  RecipeRef _pick(List<RecipeRef> candidates) {
    final hasWeight =
        candidates.any((c) => c.weight != null && c.weight! > 0);
    if (!hasWeight) {
      // §11 普通随机（V1）
      return candidates[_random.nextInt(candidates.length)];
    }
    // §13 权重抽签（V2）：权重越高被抽中概率越大
    final total = candidates.fold<double>(
      0,
      (sum, c) => sum + (c.weight ?? 1).clamp(0, double.infinity),
    );
    if (total <= 0) {
      return candidates[_random.nextInt(candidates.length)];
    }
    var r = _random.nextDouble() * total;
    for (final c in candidates) {
      r -= (c.weight ?? 1).clamp(0, double.infinity);
      if (r <= 0) return c;
    }
    return candidates.last;
  }

  /// §30 animationSeed：由结果 id + 时间戳派生稳定的伪随机种子
  int _animationSeed(String id, DateTime t) {
    final str = '$id#${t.microsecondsSinceEpoch}';
    var h = 0;
    for (final c in str.codeUnits) {
      h = (h * 31 + c) & 0x7fffffff;
    }
    return h;
  }
}
