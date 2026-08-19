import 'package:flutter/material.dart';

/// 简洁的「竹筒抽签」组件。
///
/// 设计极简，避免冲突：
/// - 一个不透明的暖木色直立竹筒，顶部开口，看起来就是个真实的竹筒。
/// - 筒口插着几根签，只高出筒口一点点，错落自然。
/// - 点击抽签：竹筒轻微左右摇两下 → 其中一根签从筒口向上冒出一截 → 停住。
///   翻面/菜名展示交给结果页（主页流程不变）。
///
/// 不做拟物过度设计、不做烙印、不做几十根大签堆。清爽、自然、不别扭。
///
/// 对外接口（`BambooTube3D` / `BambooTube3DState` / `shake()`）保持不变，
/// 主页无需改动。
class BambooTube3D extends StatefulWidget {
  const BambooTube3D({super.key});
  @override
  State<BambooTube3D> createState() => BambooTube3DState();
}

class BambooTube3DState extends State<BambooTube3D>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shakeCtrl; // 摇晃
  late final AnimationController _liftCtrl; // 抽签冒起
  late final Animation<double> _tilt;
  bool _shaking = false;

  @override
  void initState() {
    super.initState();
    _shakeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _liftCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    // 轻微左右摇两下（衰减）再回正
    _tilt = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.11), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.11, end: -0.11), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -0.11, end: 0.05), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.05, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _shakeCtrl, curve: Curves.easeInOut));
  }

  /// 触发抽签动画：摇两下 → 一根签冒出 → 停住。完成后 resolve。
  Future<void> shake() async {
    if (_shaking) return;
    if (!mounted) return;
    _liftCtrl.reset();
    setState(() => _shaking = true);
    try {
      await _shakeCtrl.forward(from: 0);
      if (!mounted) return;
      await _liftCtrl.forward();
      await Future<void>.delayed(const Duration(milliseconds: 400));
    } finally {
      if (mounted) setState(() => _shaking = false);
    }
  }

  @override
  void dispose() {
    _shakeCtrl.dispose();
    _liftCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _s.tubeWidth,
      height: _s.tubeHeight + _s.liftUp,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // 竹筒（摇晃时整体轻微摆动）
          AnimatedBuilder(
            animation: _tilt,
            builder: (ctx, child) => Transform.rotate(
              angle: _tilt.value,
              alignment: Alignment.bottomCenter,
              child: child,
            ),
            child: const _TubeWithSticks(),
          ),
          // 被抽出的那根签（冒起 + 略微倾斜）
          AnimatedBuilder(
            animation: _liftCtrl,
            builder: (ctx, _) {
              final t =
                  Curves.easeOutCubic.transform(_liftCtrl.value.clamp(0.0, 1.0));
              final up = t * _s.liftUp;
              return Positioned(
                bottom: _s.tubeHeight - _s.stickIn + up,
                child: Transform.rotate(
                  angle: t > 0 ? -0.04 : 0.0,
                  child:
                      _Stick(width: _s.stickWidth, length: _s.stickLen),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// 尺寸常量。
class _s {
  static const double tubeWidth = 150;
  static const double tubeHeight = 220; // 高约为宽的 1.47
  static const double stickWidth = 11;
  static const double stickLen = 150; // 签长
  static const double stickIn = 100; // 签插入筒内的深度
  static const double liftUp = 85; // 抽出后上移
}

// 暖木 / 竹签配色（与主题 AppTheme.wood 协调）
const _woodDark = Color(0xFF8C5A33);
const _woodMid = Color(0xFFB98252);
const _woodLight = Color(0xFFE2BC7E);
const _stickLight = Color(0xFFEDCCA0);
const _stickDark = Color(0xFFC29A63);

/// 一根竹签（简洁圆角细长条，顶部圆润）。
class _Stick extends StatelessWidget {
  final double width;
  final double length;
  const _Stick({required this.width, required this.length});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: length,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(width / 2),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_stickLight, _stickDark],
        ),
      ),
    );
  }
}

/// 竹筒本体 + 筒口插着的一小撮签（静态露出的部分）。
class _TubeWithSticks extends StatelessWidget {
  const _TubeWithSticks();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _s.tubeWidth,
      height: _s.tubeHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 筒口插着的几根静态签（略高出筒口，错落一点）
          ..._staticSticks(),
          // 不透明筒身（盖住签下半部分，看起来"签在筒里"）
          Positioned.fill(child: CustomPaint(painter: _TubePainter())),
        ],
      ),
    );
  }

  List<Widget> _staticSticks() {
    // 筒口露出的静态签：居中偏左/偏右各几根，高低略有不同。
    const specs = <(double, double, double)>[
      (0.38, 0.86, -0.05),
      (0.46, 0.95, 0.02),
      (0.54, 0.90, 0.04),
      (0.62, 0.84, -0.03),
      (0.50, 1.0, 0.0),
    ];
    return specs.map((s) {
      final (fx, expose, tilt) = s;
      final len = _s.stickLen * expose;
      final left = _s.tubeWidth * fx - _s.stickWidth / 2;
      return Positioned(
        left: left,
        bottom: _s.tubeHeight - _s.stickIn,
        child: Transform.rotate(
          angle: tilt,
          child: _Stick(width: _s.stickWidth, length: len),
        ),
      );
    }).toList();
  }
}

class _TubePainter extends CustomPainter {
  const _TubePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final topR = w / 2 - 2;
    final bottom = h - 10;

    // —— 底部落地软阴影 ——
    final proj = Rect.fromCenter(
        center: Offset(w / 2, h - 2), width: w * 0.84, height: 10);
    canvas.drawOval(
      proj,
      Paint()
        ..shader = RadialGradient(colors: const [
          Color(0x40000000),
          Color(0x00000000),
        ]).createShader(proj),
    );

    // —— 筒身（圆柱体渐变，不透明）——
    final path = Path()
      ..moveTo(w / 2 - topR, 12)
      ..lineTo(w / 2 - topR, bottom - 4)
      ..quadraticBezierTo(w / 2 - topR, bottom, w / 2, bottom)
      ..quadraticBezierTo(w / 2 + topR, bottom, w / 2 + topR, bottom - 4)
      ..lineTo(w / 2 + topR, 12)
      ..close();

    canvas.drawPath(
      path,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [_woodDark, _woodMid, _woodLight, _woodMid, _woodDark],
          stops: [0.0, 0.2, 0.5, 0.8, 1.0],
        ).createShader(Offset.zero & size),
    );

    // —— 顶部开口（深色内壁，体现"签插在筒里"）——
    canvas.drawOval(
      Rect.fromLTWH(topR * 0.42, 6, w - topR * 0.84, 20),
      Paint()..color = _woodDark.withValues(alpha: 0.9),
    );

    // —— 一道竹节（增加一点竹质感，保持简洁）——
    canvas.drawLine(
      Offset(w / 2 - topR + 6, h * 0.55),
      Offset(w / 2 + topR - 6, h * 0.55),
      Paint()
        ..color = _woodDark.withValues(alpha: 0.5)
        ..strokeWidth = 3,
    );
    canvas.drawLine(
      Offset(w / 2 - topR + 6, h * 0.55 + 3.5),
      Offset(w / 2 + topR - 6, h * 0.55 + 3.5),
      Paint()
        ..color = const Color(0x33FFFFFF)
        ..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(covariant _TubePainter old) => false;
}
