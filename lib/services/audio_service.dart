import 'package:audioplayers/audioplayers.dart';

/// Simple audio service to play/stop a looping background music asset.
///
/// Usage: call [AudioService.playBackground()] when the player starts, and
/// [AudioService.stop()] when the player completes the puzzle.
class AudioService {
  static final AudioPlayer _player = AudioPlayer();
  static bool _playing = false;

  /// Play the bundled background music located at `assets/audio/background.mp3`.
  ///
  /// Make sure you add your music file at `assets/audio/background.mp3` and
  /// that `pubspec.yaml` includes `assets/audio/` under `flutter.assets`.
  static Future<void> playBackground({String assetPath = 'audio/background.mp3'}) async {
    try {
      if (_playing) return;
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.setSource(AssetSource(assetPath));
      await _player.resume();
      _playing = true;
    } catch (e) {
      // ignore errors silently for now, but you can log if needed
    }
  }

  /// Stop playback.
  static Future<void> stop() async {
    try {
      if (!_playing) return;
      await _player.stop();
      _playing = false;
    } catch (e) {
      // ignore
    }
  }

  /// Play a short one-shot effect (for example when the puzzle is completed).
  ///
  /// Place your asset in `assets/audio/completed.mp3` (or pass a different
  /// `assetPath` relative to the `assets/` directory).
  static Future<void> playEffect({String assetPath = 'audio/completed.mp3'}) async {
    try {
      final effectPlayer = AudioPlayer();
      await effectPlayer.setSource(AssetSource(assetPath));
      // Play once
      await effectPlayer.resume();
      // Wait until the sound completes, then dispose the player to free resources.
      await effectPlayer.onPlayerComplete.first;
      await effectPlayer.dispose();
    } catch (e) {
      // ignore errors for now
    }
  }
}
