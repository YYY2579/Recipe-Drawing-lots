import 'package:flutter/material.dart';

/// 纯 Flutter 绘制的伪 3D 竹筒（签筒），与全局「轻国风·暖木」主题协调。
///
/// 早期版本用 flutter_3d_controller（WebView + WebGL 渲染 49MB GLB），在鸿蒙 / 部分设备
/// WebGL 不可用，竹筒永远渲染不出。现改为纯 Flutter 绘制：横向渐变模拟圆柱光照 +
/// 暖白金高光 + 精致竹节 + 顶部签条 + 暖棕落地投影，配合 Transform 摇晃动画，
/// 任何设备稳定显示，且不依赖重型 WebView。
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
    // 延长到约 1.6s，让「摇一摇」有完整的体感，与抽签音效节奏协调。
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
  /// 返回 Future，动画完整播放结束后 resolve，供主页在「摇完」之后再展示结果，
  /// 从而让摇签音效与动画节奏协调、用户获得完整的摇签体验。
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
        alignment: Alignment.bottomCenter,
        child: child,
      ),
      child: const _BambooBody(),
    );
  }
}

/// 竹筒本体：自然竹色（橄榄青绿），与主题 wood / red 协调，稳重不刺眼。
class _BambooBody extends StatelessWidget {
  const _BambooBody();

  static const double width = 150;
  static const double height = 236;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 暖棕落地投影（模糊，让竹筒「落地」）
          Positioned(
            bottom: 0,
            child: Container(
              width: width * 0.82,
              height: 22,
              decoration: BoxDecoration(
                color: const Color(0x338C5A33),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x338C5A33),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),
          // 顶部伸出的签条
          const Positioned(top: -8, child: _FortuneSticks()),
          // 竹筒主体
          Container(
            width: width,
            height: height - 18,
            decoration: BoxDecoration(
              // 横向渐变模拟圆柱受光：左暗 → 中亮 → 右暗（自然竹青绿，柔和稳重）
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: [0.0, 0.16, 0.5, 0.84, 1.0],
                colors: [
                  Color(0xFF5C7A3A),
                  Color(0xFF8FB05A),
                  Color(0xFFCFE39A),
                  Color(0xFF8FB05A),
                  Color(0xFF5C7A3A),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x3A4A2A12),
                  blurRadius: 14,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              children: [
                // 暖白金高光带（圆柱反光）
                Positioned(
                  left: width * 0.4,
                  top: 0,
                  bottom: 0,
                  width: width * 0.18,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFFF4E7B8).withOpacity(0.6),
                          const Color(0xFFF4E7B8).withOpacity(0.12),
                          const Color(0xFFF4E7B8).withOpacity(0.0),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                // 精致竹节：上暗线 + 下亮线，模拟竹节隆起
                ...List.generate(3, (i) {
                  final top = 50.0 + i * 54;
                  return Positioned(
                    top: top,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        Container(height: 3, color: const Color(0x55384E27)),
                        Container(
                          height: 2,
                          color: Colors.white.withOpacity(0.28),
                        ),
                      ],
                    ),
                  );
                }),
                // 顶部开口（立体椭圆：暗底 + 内圈亮边）
                Positioned(
                  top: 5,
                  left: 14,
                  right: 14,
                  height: 22,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A3F1C),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.12),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                // 底部标字
                const Positioned(
                  bottom: 18,
                  child: Text(
                    '签筒',
                    style: TextStyle(
                      color: Color(0xCCFFFFFF),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 顶部伸出的签条（红 / 金 / 红），圆头 + 渐变 + 高光。
class _FortuneSticks extends StatelessWidget {
  const _FortuneSticks();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      height: 62,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          _stick(left: 6, color: const Color(0xFFB84A3A), tilt: -0.16, h: 54),
          _stick(left: 30, color: const Color(0xFFD9A878), tilt: 0.0, h: 60),
          _stick(left: 54, color: const Color(0xFFB84A3A), tilt: 0.16, h: 52),
        ],
      ),
    );
  }

  Widget _stick({
    required double left,
    required Color color,
    required double tilt,
    required double h,
  }) {
    return Positioned(
      left: left,
      bottom: 0,
      child: Transform.rotate(
        angle: tilt,
        alignment: Alignment.bottomCenter,
        child: Container(
          width: 10,
          height: h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [color.withOpacity(0.85), color],
            ),
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 3,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Container(
            margin: const EdgeInsets.only(top: 2),
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.45),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }
}
