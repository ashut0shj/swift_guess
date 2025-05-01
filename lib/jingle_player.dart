import 'package:audioplayers/audioplayers.dart';

class JinglePlayer {
  static final JinglePlayer _instance = JinglePlayer._internal();
  factory JinglePlayer() => _instance;

  late AudioPlayer _player;
  bool _isMuted = false;
  bool _isPlaying = false;
  bool _isInitialized = false;

  JinglePlayer._internal() {
    _player = AudioPlayer();
    _player.setReleaseMode(ReleaseMode.loop);
    // Don't call _init() here - we'll call it lazily when needed
  }

  Future<void> _init() async {
    if (_isInitialized) return;
    
    try {
      await _player.setVolume(0.3);
      await _player.play(AssetSource('audio/jingle.mp3'));
      _isPlaying = true;
      _isInitialized = true;
    } catch (e) {
      print('Error initializing audio player: $e');
      // Set initialized to true anyway to prevent repeated init attempts
      _isInitialized = true;
    }
  }

  Future<void> play() async {
    if (!_isInitialized) await _init();
    if (_isMuted) return;
    
    try {
      await _player.play(AssetSource('audio/jingle.mp3'));
      await _player.setVolume(0.1);
      _isPlaying = true;
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  Future<void> stop() async {
    if (!_isInitialized) return;
    
    try {
      await _player.stop();
      _isPlaying = false;
    } catch (e) {
      print('Error stopping audio: $e');
    }
  }

  void toggleMute() {
    if (!_isInitialized) {
      _init();
      return;
    }
    
    try {
      _isMuted = !_isMuted;
      if (_isMuted) {
        _player.pause();
        _isPlaying = false;
      } else {
        _player.resume();
        _isPlaying = true;
      }
    } catch (e) {
      print('Error toggling mute: $e');
    }
  }

  bool get isMuted => _isMuted;
  bool get isPlaying => _isPlaying;
}