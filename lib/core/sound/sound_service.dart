import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 音效服务：封装竹筒摇晃声 / 签条揭示声的播放。
/// 资源位于 assets/sounds/，由 scripts/gen_sounds.py 合成（无需外部素材）。
class SoundService {
  final AudioPlayer _shakePlayer = AudioPlayer();
  final AudioPlayer _revealPlayer = AudioPlayer();
  bool _enabled = true;

  SoundService() {
    _shakePlayer.setReleaseMode(ReleaseMode.stop);
    _revealPlayer.setReleaseMode(ReleaseMode.stop);
  }

  /// 是否播放音效（由设置中的「抽签音效」控制）。
  void setEnabled(bool v) => _enabled = v;

  /// 竹筒摇晃声（抽签开始时）。
  Future<void> playShake() async {
    if (!_enabled) return;
    try {
      await _shakePlayer.stop();
      await _shakePlayer.play(AssetSource('sounds/shake.wav'));
    } catch (_) {
      // 资源缺失或播放失败不阻塞抽签流程
    }
  }

  /// 签条揭示声（点击签条翻转显示菜名时）。
  Future<void> playReveal() async {
    if (!_enabled) return;
    try {
      await _revealPlayer.stop();
      await _revealPlayer.play(AssetSource('sounds/reveal.wav'));
    } catch (_) {
      // 同上
    }
  }

  void dispose() {
    _shakePlayer.dispose();
    _revealPlayer.dispose();
  }
}

/// 全局单例。
final soundServiceProvider = Provider<SoundService>((ref) {
  final s = SoundService();
  ref.onDispose(s.dispose);
  return s;
});
