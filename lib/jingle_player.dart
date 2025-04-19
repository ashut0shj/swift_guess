import 'package:audioplayers/audioplayers.dart';

class JinglePlayer {
  static final JinglePlayer _instance = JinglePlayer._internal();
  factory JinglePlayer() => _instance;

  late AudioPlayer _player;
  bool _isMuted = false;
  bool _isPlaying = false;

  JinglePlayer._internal() {
    _player = AudioPlayer();
    _player.setReleaseMode(ReleaseMode.loop);
    _init();
  }

  Future<void> _init() async {
    await _player.setVolume(0.3); // Set volume before play
    await _player.play(AssetSource('audio/jingle.mp3'));
    _isPlaying = true;
  }

  Future<void> play() async {
    if (_isMuted) return;
    await _player.play(AssetSource('audio/jingle.mp3'));
    await _player.setVolume(0.1);

    _isPlaying = true;
  }

  Future<void> stop() async {
    await _player.stop();
    _isPlaying = false;
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    if (_isMuted) {
      _player.pause();
      _isPlaying = false;
    } else {
      _player.resume(); // resumes from paused point with set volume
      _isPlaying = true;
    }
  }

  bool get isMuted => _isMuted;
  bool get isPlaying => _isPlaying;
}
