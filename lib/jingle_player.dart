import 'package:audioplayers/audioplayers.dart';
import 'dart:math';

class JinglePlayer {
  static final JinglePlayer _instance = JinglePlayer._internal();
  factory JinglePlayer() => _instance;
  
  late AudioPlayer _player;
  bool _isMuted = false;
  bool _isPlaying = false;
  bool _isInitialized = false;
  
  // List of available jingles with display names
  final Map<String, String> _jinglesMap = {
    'jingle.mp3': 'Shake It Off',
    'bad-blood.mp3': 'Bad Blood',
    'blank-space.mp3': 'Blank Space',
    'i-think-he-knows.mp3': 'I Think He Knows',
    'love_story.mp3': 'Love Story',
    'you-are-in-love.mp3': 'You Are In Love',
  };
  
  // Current jingle index
  String _currentJingle = '';
  
  // Random generator
  final Random _random = Random();
  
  String get currentJingleName {
    // Return friendly name if available, otherwise the filename without extension
    if (_currentJingle.isEmpty && _jinglesMap.isNotEmpty) {
      _currentJingle = _jinglesMap.keys.first;
    }
    return _jinglesMap[_currentJingle] ?? _currentJingle.replaceAll('.mp3', '');
  }
  
  List<String> get availableJingles {
    // Return friendly names for the dropdown
    return _jinglesMap.values.toList();
  }
  
  // Return filename for a given display name
  String _getFilenameFromDisplayName(String displayName) {
    for (var entry in _jinglesMap.entries) {
      if (entry.value == displayName) {
        return entry.key;
      }
    }
    return '';
  }
  
  JinglePlayer._internal() {
    _player = AudioPlayer();
    _player.setReleaseMode(ReleaseMode.release); // Change from loop to release
    _selectRandomJingle();
    
    // Set up completion listener to play next jingle
    _player.onPlayerComplete.listen((_) {
      _playNextJingle();
    });
  }
  
  void _playNextJingle() {
    final keys = _jinglesMap.keys.toList();
    if (keys.isEmpty) return;
    
    // Get index of current jingle
    int currentIndex = keys.indexOf(_currentJingle);
    
    // Move to next jingle or wrap around to first
    if (currentIndex >= 0 && currentIndex < keys.length - 1) {
      _currentJingle = keys[currentIndex + 1];
    } else {
      _currentJingle = keys[0]; // Back to first jingle
    }
    
    // Play the next jingle if not muted
    if (!_isMuted) {
      _playCurrentJingle();
    }
  }
  
  void _selectRandomJingle() {
    final keys = _jinglesMap.keys.toList();
    if (keys.isNotEmpty) {
      _currentJingle = keys[_random.nextInt(keys.length)];
    }
  }

  Future<void> _init() async {
    if (_isInitialized) return;
    
    try {
      await _player.setVolume(0.3);
      await _playCurrentJingle();
      _isPlaying = true;
      _isInitialized = true;
    } catch (e) {
      print('Error initializing audio player: $e');
      _isInitialized = true;
    }
  }
  
  Future<void> _playCurrentJingle() async {
    try {
      // Check if the path contains 'assets/' prefix
      final audioPath = _currentJingle.startsWith('assets/') 
          ? _currentJingle.replaceFirst('assets/', '') 
          : 'audio/$_currentJingle';
          
      await _player.play(AssetSource(audioPath));
      
      // Update current jingle name for UI display
      _currentJingle = _currentJingle;
    } catch (e) {
      print('Error playing jingle: $e');
      // If there's an error, try playing the next jingle
      _playNextJingle();
    }
  }

  Future<void> play() async {
    if (!_isInitialized) await _init();
    if (_isMuted) return;
    
    try {
      await _playCurrentJingle();
      await _player.setVolume(0.3);
      _isPlaying = true;
    } catch (e) {
      print('Error playing audio: $e');
    }
  }
  
  Future<void> playRandom() async {
    _selectRandomJingle();
    if (_isPlaying && !_isMuted) {
      await _player.stop();
      await _playCurrentJingle();
    }
    return play();
  }
  
  Future<void> setJingleByName(String displayName) async {
    final filename = _getFilenameFromDisplayName(displayName);
    if (filename.isNotEmpty) {
      _currentJingle = filename;
      if (_isPlaying && !_isMuted) {
        await _player.stop();
        await _playCurrentJingle();
      } else if (!_isInitialized) {
        await _init();
      }
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