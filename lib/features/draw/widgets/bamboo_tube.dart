import 'dart:math';

import 'package:flutter/material.dart';

import 'package:what_to_eat/core/database/app_database.dart';

/// 木质签筒 + 竹签的自定义绘制（对应文档 §14 / §15）。
///
/// 动画时间轴（progress: 0→1，约 2800ms）：
/// 0~0.107  签筒开始轻晃
/// 0.107~0.357 签子上下运动
/// 0.357~0.536 签筒剧烈晃动
/// 0.536~0.643 目标签升起
/// 0.643~0.821 签子逐渐抽出
/// 0.821~0.893 短暂停顿
/// 0.893~1.0 签子弹出
///
/// 必须先由 DrawEngine 定出结果（targetIndex），动画只负责表现，不决定结果（§16）。
class BambooTubePainter extends CustomPainter {
  final Animation<double> progress;
  final List<RecipeData> recipes;
  final int targetIndex;
  final int seed;

  BambooTubePainter({
    required this.progress,
    required this.recipes,
    required this.targetIndex,
    required this.seed,
  }) : super(repaint: progress);

  static const Color _woodLight = Color(0xFFD9A878);
  static const Color _wood = Color(0xFFB98252);
  static const Color _woodDark = Color(0xFF8C5A33);
  static const Color _stick = Color(0xFFE9D9A8);
  static const Color _stickShade = Color(0xFFCBB57A);
  static const Color _red = Color(0xFFB84A3A);
  static const Color _knob = Color(0xFF8C5A33);

  List<double> _phases() {
    final rnd = Random(seed);
    return List.generate(recipes.length, (_) => rnd.nextDouble() * 2 * pi);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final t = progress.value;
    final phases = _phases();

    final tubeW = size.width * 0.6;
    final tubeH = size.height * 0.40;
    final cx = size.width / 2;
    final topY = size.height * 0.42; // 筒口 y

    // —— 整体晃动 ——
    double shake = 0;
    if (t >= 0.107 && t < 0.357) {
      shake = sin(t * 60) * 2 * ((t - 0.107) / 0.25);
    } else if (t >= 0.357 && t < 0.536) {
      shake = sin(t * 90) * 6;
    } else if (t >= 0.536) {
      shake = sin(t * 40) * 1.5 * (1 - (t - 0.536) / 0.464).clamp(0, 1);
    }

    // —— 签子上下抖动幅度 ——
    final jiggleAmp =
        (t >= 0.107 && t < 0.536) ? (t < 0.357 ? 4.0 : 10.0) : 0;

    // —— 目标签 升起 / 抽出 / 弹出 ——
    double targetRise = 0;
    double targetTilt = 0;
    if (targetIndex >= 0 && t >= 0.536) {
      final p = ((t - 0.536) / (1 - 0.536)).clamp(0, 1);
      if (p < 0.2) {
        targetRise = p / 0.2 * (tubeH * 0.25);
      } else if (p < 0.55) {
        targetRise = tubeH * 0.25 + (p - 0.2) / 0.35 * (tubeH * 0.5);
      } else if (p < 0.7) {
        targetRise = tubeH * 0.75;
      } else {
        targetRise = tubeH * 0.75 + (p - 0.7) / 0.3 * (tubeH * 0.3);
      }
      targetTilt = sin(p * pi) * 0.12;
    }

    // —— 绘制签子（在筒体之前，筒体前壁会遮住筒内部分）——
    final n = recipes.length;
    if (n > 0) {
      final stickW = max(2.0, tubeW / (n + 6));
      final spacing = tubeW / (n + 1);
      final showLabels = n <= 18;
      for (int i = 0; i < n; i++) {
        final baseX = cx - tubeW / 2 + spacing * (i + 1) + shake;
        final top = topY - size.height * 0.10 - (i % 4) * 4.0;
        final h = size.height * 0.12 + (i % 5) * 3.0;

        final isTarget = i == targetIndex;
        double tx = baseX;
        double ty = top;
        double th = h;
        double tilt = 0;

        if (isTarget && targetRise > 0) {
          ty = top - targetRise;
          tx = baseX + sin(targetTilt) * (size.height * 0.05);
          tilt = targetTilt;
        } else if (jiggleAmp > 0) {
          final dy = sin(t * 50 + phases[i]) * jiggleAmp;
          ty = top - dy;
          th = h + dy;
        }

        String? label;
        if (showLabels && !isTarget) {
          label = recipes[i].name.length > 2
              ? recipes[i].name.substring(0, 2)
              : recipes[i].name;
        } else if (isTarget) {
          label = '中';
        }

        _drawStick(canvas, tx, ty, th, stickW, isTarget, label);
      }
    }

    // —— 绘制筒体（前壁遮住签子下部，形成「插在筒里」的观感）——
    _drawTube(canvas, cx + shake, topY, tubeW, tubeH);
  }

  void _drawStick(Canvas canvas, double x, double top, double h, double w,
      bool isTarget, String? label) {
    canvas.save();
    canvas.translate(x, top);

    final body = RRect.fromRectAndRadius(
      Rect.fromLTWH(-w / 2, 0, w, h),
      Radius.circular(w / 2),
    );
    canvas.drawRRect(
      body,
      Paint()..color = isTarget ? const Color(0xFFF0E2B8) : _stick,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(-w / 2, 0, w * 0.35, h),
        Radius.circular(w / 2),
      ),
      Paint()..color = _stickShade.withOpacity(0.4),
    );
    // 签顶木扣
    canvas.drawCircle(
      Offset(0, 0),
      w * 0.78,
      Paint()..color = isTarget ? _red : _knob,
    );

    if (label != null) {
      final tp = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(
            color: isTarget ? _red : const Color(0x6692796B),
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      )..layout(maxWidth: 44);
      tp.paint(canvas, Offset(-tp.width / 2, -tp.height - w));
    }
    canvas.restore();
  }

  void _drawTube(
      Canvas canvas, double cx, double topY, double w, double h) {
    final body = RRect.fromRectAndRadius(
      Rect.fromLTWH(cx - w / 2, topY, w, h),
      Radius.circular(w * 0.10),
    );
    canvas.drawRRect(
      body,
      Paint()
        ..shader = const LinearGradient(
          colors: [_woodLight, _wood, _woodDark],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(body.outerRect),
    );

    // 木纹
    final grain = Paint()
      ..color = _woodDark.withOpacity(0.18)
      ..strokeWidth = 1.0;
    for (int i = 1; i < 7; i++) {
      final gx = cx - w / 2 + w * i / 7;
      canvas.drawLine(Offset(gx, topY + 8), Offset(gx, topY + h - 8), grain);
    }

    // 筒口内壁（深色椭圆）
    canvas.drawOval(
      Rect.fromLTWH(cx - w / 2, topY - 8, w, 18),
      Paint()..color = const Color(0xFF6B4423),
    );
    // 筒口边缘
    canvas.drawOval(
      Rect.fromLTWH(cx - w / 2, topY - 8, w, 18),
      Paint()
        ..color = _woodLight
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
    // 底部阴影
    canvas.drawOval(
      Rect.fromLTWH(cx - w / 2 + 6, topY + h - 4, w - 12, 14),
      Paint()..color = const Color(0x22000000),
    );
  }

  @override
  bool shouldRepaint(covariant BambooTubePainter old) =>
      old.progress != progress ||
      old.targetIndex != targetIndex ||
      old.seed != seed ||
      old.recipes != recipes;
}
