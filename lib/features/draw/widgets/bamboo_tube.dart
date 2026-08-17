import 'package:flutter/material.dart';

/// 纯 Flutter 绘制的伪 3D 竹筒（签筒），与全局「轻国风·暖木」主题协调。
///
/// 早前版本用 flutter_3d_controller（WebView + WebGL 渲染 49MB GLB），在部分设备
/// WebGL 不可用导致竹筒渲染不出。本实现改为纯 Flutter `CustomPainter`：
/// 暖木色上宽下窄梯形筒身 + 木纹 / 竹节 + 内凹椭圆开口 + 筒内悬浮的多根签条 +
/// 椭圆落地投影，任何设备稳定显示，不依赖重型 WebView。
///
/// 对外保留 [BambooTube3D] / [BambooTube3DState] / [shake()] 接口，主页无需改动。
class BambooTube3D extends StatefulWidget {
  const BambooTube3D({super.key});

  @override
  State<BambooTube3D> createState() => BambooTube3DState();
}

class BambooTube3DState extends State<BambooTube3D>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _tilt;
  bool _shaking = false;

  @override
  void initState() {
    super.initState();
    // 约 1.6s，让「摇一摇」有完整体感，与抽签音效节奏协调。
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    // 左右交替、多段逐步衰减的摇晃，最后回正，模拟真实摇签。
    _tilt = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.16), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.16, end: -0.16), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -0.16, end: 0.12), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.12, end: -0.1), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -0.1, end: 0.06), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.06, end: -0.04), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -0.04, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  /// 摇晃动画：绕底部中心左右摆动，模拟竹筒摇签。
  /// 返回 Future，动画完整播放结束后 resolve，供主页在「摇完」之后再展示结果。
  Future<void> shake() async {
    if (_shaking) return;
    if (!mounted) return;
    setState(() => _shaking = true);
    try {
      await _ctrl.forward(from: 0);
    } finally {
      if (mounted) setState(() => _shaking = false);
      if (_ctrl.value != 0) _ctrl.reset();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _tilt,
      builder: (context, child) => Transform.rotate(
        angle: _tilt.value,
        alignment: const Alignment(0, 2.2), // 绕筒底中心摆动
        child: child,
      ),
      child: const _BambooBody(),
    );
  }
}

/// 竹筒本体（CustomPainter）。
class _BambooBody extends StatelessWidget {
  const _BambooBody();

  static const double width = 172;
  static const double height = 252;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _BambooPainter(),
      ),
    );
  }
}

class _BambooPainter extends CustomPainter {
  const _BambooPainter();

  // 暖木色系（与 AppTheme.wood 协调）
  static const _woodDark = Color(0xFF6E4A26);
  static const _woodMid = Color(0xFF9C6B3A);
  static const _woodLight = Color(0xFFC08A4E);
  static const _red = Color(0xFFB84A3A);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    // 梯形尺寸：上宽 / 下宽 / 筒高
    final topW = w; // 172
    final botW = w * 0.66; // 底部收窄
    final tubeH = h - 16; // 留出底部投影
    final topR = (topW / 2) - 4;
    final botR = (botW / 2) - 4;

    // --- 底部椭圆软投影 ---
    final shadowRect = Rect.fromCenter(
      center: Offset(w / 2, h - 6),
      width: w * 0.8,
      height: 18,
    );
    canvas.save();
    _paintShadow(canvas, shadowRect);
    canvas.restore();

    // --- 筒身（梯形路径填充暖木渐变）---
    final tubePath = Path()
      ..moveTo(w / 2 - topR, 10)
      ..quadraticBezierTo(w / 2 - topR - 6, 34, w / 2 - botR, 44)
      ..lineTo(w / 2 - botR, tubeH - 6)
      ..quadraticBezierTo(w / 2 - botR, tubeH, w / 2, tubeH)
      ..quadraticBezierTo(w / 2 + botR, tubeH, w / 2 + botR, tubeH - 6)
      ..lineTo(w / 2 + botR, 44)
      ..quadraticBezierTo(w / 2 + topR + 6, 34, w / 2 + topR, 10)
      ..close();

    // 主体横向渐变（圆柱受光：左暗 - 中亮 - 右暗）
    final bodyGrad = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: const [_woodDark, _woodMid, _woodLight, _woodMid, _woodDark],
      stops: const [0.0, 0.18, 0.5, 0.82, 1.0],
    );
    canvas.save();
    canvas.clipPath(tubePath);
    canvas.drawRect(
        Offset.zero & size, Paint()..shader = bodyGrad.createShader(Offset.zero & size));

    // 高光带
    final hiPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0x66FFFFFF), Color(0x00FFFFFF)],
      ).createShader(Rect.fromLTWH(w / 2, 0, w * 0.16, h));
    canvas.drawRect(
        Rect.fromLTWH(w / 2 - w * 0.02, 8, w * 0.16, tubeH - 12), hiPaint);

    // 侧边暗部（圆柱纵深阴影叠加深绿木质暗影）
    final sideShade = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.center,
        colors: const [Color(0x60000000), Color(0x00000000)],
      ).createShader(Rect.fromLTWH(0, 0, w * 0.2, h));
    canvas.drawRect(Rect.fromLTWH(0, 8, w * 0.2, tubeH - 12), sideShade);
    canvas.restore();

    // 竹节（上凸暗线 + 下亮线），随梯形横向轻微收窄
    final nJoints = 3;
    for (var i = 0; i < nJoints; i++) {
      final t = 0.28 + i * 0.22; // 相对筒高位置
      final y = 40 + (tubeH - 8 - 40) * t;
      final r = botR + (topR - botR) * (1 - t); // 该高度处的半宽
      final left = w / 2 - r;
      final right = w / 2 + r;
      canvas
        ..drawLine(Offset(left, y), Offset(right, y),
            Paint()..color = const Color(0x404A2A12)..strokeWidth = 3)
        ..drawLine(Offset(left, y + 3.5), Offset(right, y + 3.5),
            Paint()..color = const Color(0x33FFFFFF)..strokeWidth = 2);
    }

    // 顶部开口（内凹椭圆 + 深色内壁）
    final mouthRect = Rect.fromLTWH(topR * 0.22, 6, topW - topR * 0.44, 30);
    final mouth = RRect.fromRectAndRadius(
        Rect.fromLTWH(mouthRect.left - 6, mouthRect.top - 2,
            mouthRect.width + 12, mouthRect.height + 6),
        const Radius.circular(18));
    canvas
      ..drawRRect(mouth, Paint()..color = const Color(0xFF2A241C))
      ..drawRRect(
          mouth.inflate(2),
          Paint()
            ..color = const Color(0x22FFFFFF)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5);
    // 开口内壁渐暗
    canvas.drawRRect(
        mouth.deflate(2),
        Paint()
          ..shader = const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
            Color(0xFF1D1812),
            Color(0xFF2A241C),
          ]).createShader(mouth.outerRect));

    // --- 筒内伸出的签条（红 / 金 / 红，长短高低交错）---
    _paintSticks(canvas, mouthRect);

    // 底部标字
    final tp = TextPainter(
      text: const TextSpan(
        text: '签筒',
        style: TextStyle(
          color: Color(0xB3FFFFFF),
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 4,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset((w - tp.width) / 2, tubeH - 24));
  }

  void _paintShadow(Canvas canvas, Rect rect) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: const [Color(0x408C5A33), Color(0x008C5A33)],
      ).createShader(rect);
    canvas.drawOval(rect, paint);
  }

  void _paintSticks(Canvas canvas, Rect mouth) {
    // 签条从筒口探出：红 - 金 - 红等距错落 + 随机倾斜 + 高低不一。
    const stickW = 11.0;
    final baseY = mouth.center.dy + mouth.height * 0.18;
    // 每根签：横向偏移、露出高度、倾斜角、颜色
    final specs = <(double, double, double, Color)>[
      (0.22, 60, -0.14, _red),
      (0.38, 70, -0.05, const Color(0xFFD9A878)),
      (0.50, 78, 0.02, _red),
      (0.62, 70, 0.10, const Color(0xFFE2C067)),
      (0.76, 60, 0.16, const Color(0xFFB84A3A)),
    ];
    for (final (fx, len, tilt, color) in specs) {
      final cx = mouth.left + mouth.width * fx;
      final painter = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withOpacity(0.9), color],
        ).createShader(Rect.fromCenter(
            center: Offset(cx, baseY - len / 2), width: stickW, height: len));
      canvas.save();
      canvas.translate(cx, baseY);
      canvas.rotate(tilt);
      final r = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: stickW, height: len),
        const Radius.circular(5.5),
      );
      canvas
        ..drawRRect(r, painter)
        // 签条圆头高光
        ..drawRRect(
            RRect.fromRectAndRadius(
                Rect.fromLTWH(-stickW / 2 + 2, -len / 2 + 2, stickW - 4, 4),
                const Radius.circular(2)),
            Paint()..color = Colors.white.withOpacity(0.4));
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _BambooPainter oldDelegate) => false;
}
