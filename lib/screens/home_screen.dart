import 'package:flutter/material.dart';
import 'game_screen.dart';
import 'how_to_play.dart';
import '../data/score_repository.dart';
import '../jingle_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _highScore = 0;
  bool _isMusicMuted = false;
  bool _areSfxMuted = false;
  bool _imageLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadHighScore();
    
    try {
      _isMusicMuted = JinglePlayer().isMuted;
      _areSfxMuted = JinglePlayer().isMuted;
    } catch (e) {
      print('Error getting jingle player state: $e');
      _isMusicMuted = false;
      _areSfxMuted = false;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_imageLoaded) {
      _preloadAssets();
    }
  }

  void _preloadAssets() {
    precacheImage(const AssetImage('assets/images/home_image.png'), context)
      .then((_) {
        if (mounted) {
          setState(() {
            _imageLoaded = true;
          });
        }
      })
      .catchError((error) {
        print('Error loading image: $error');
        if (mounted) {
          setState(() {
            _imageLoaded = true;
          });
        }
      });
  }

  Future<void> _loadHighScore() async {
    try {
      final score = await ScoreRepository.getHighScore();
      if (mounted) {
        setState(() {
          _highScore = score;
        });
      }
    } catch (e) {
      print('Error loading high score: $e');
    }
  }

  void _openHowToPlayScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HowToPlayScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // If image is not loaded yet, show loading screen
    if (!_imageLoaded) {
      return Scaffold(
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF18122B), Color(0xFF8A2BE2)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF18122B),
              Colors.purple.shade900,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 40),
                _buildHeaderSection(),
                const SizedBox(height: 30),
                _buildHighScoreSection(),
                const SizedBox(height: 30),
                _buildButtonsSection(),
                const Spacer(),
                _buildAudioControlsSection(),
                const SizedBox(height: 20),
                _buildFooterSection(),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    final screenHeight = MediaQuery.of(context).size.height;
    final imageSize = screenHeight * 0.25;

    return Column(
      children: [
        // Game logo/icon
        Container(
          decoration: BoxDecoration(
            color: Colors.purple.shade900.withOpacity(0.6),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 10,
              ),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: Hero(
            tag: 'app_logo',
            child: Image.asset(
              'assets/images/home_image.png',
              width: imageSize,
              height: imageSize,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                print('Error rendering image: $error');
                return Icon(
                  Icons.music_note,
                  size: imageSize,
                  color: Colors.pink.shade300,
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Swift Guess',
          style: TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.bold,
            color: Colors.pink.shade300,
            shadows: const [
              Shadow(
                blurRadius: 10,
                color: Colors.black38,
                offset: Offset(2, 2),
              ),
            ],
          ),
        ),
        
      ],
    );
  }

  Widget _buildHighScoreSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.purple.shade900.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purple.shade300, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.emoji_events,
            color: Colors.pink.shade200,
            size: 30,
          ),
          const SizedBox(width: 12),
          Text(
            'High Score: $_highScore',
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonsSection() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const GameScreen()),
            ).then((_) => _loadHighScore());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink.shade400,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 8,
            shadowColor: Colors.pinkAccent.withOpacity(0.5),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.play_arrow),
              SizedBox(width: 12),
              Text(
                'Start Game',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        TextButton.icon(
          onPressed: _openHowToPlayScreen,
          icon: Icon(
            Icons.help_outline,
            color: Colors.pink.shade200,
          ),
          label: Text(
            'How to Play',
            style: TextStyle(
              fontSize: 18,
              color: Colors.pink.shade200,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAudioControlsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.purple.shade900.withOpacity(0.3),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildAudioButton(
            _isMusicMuted ? Icons.music_off : Icons.music_note,
            'Music',
            () {
              try {
                JinglePlayer().toggleMute();
                setState(() {
                  _isMusicMuted = !_isMusicMuted;
                });
              } catch (e) {
                print('Error toggling mute: $e');
              }
            },
          ),
          const SizedBox(width: 24),
          _buildAudioButton(
            _areSfxMuted ? Icons.volume_off : Icons.volume_up,
            'Sound FX',
            () {
              setState(() {
                _areSfxMuted = !_areSfxMuted;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAudioButton(IconData icon, String label, VoidCallback onPressed) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          iconSize: 30,
          icon: Icon(
            icon,
            color: Colors.pink.shade200,
          ),
          onPressed: onPressed,
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildFooterSection() {
    return Text(
      '~ ashut0sh ❤️',
      style: TextStyle(
        fontSize: 12,
        color: Colors.white.withOpacity(0.5),
        fontStyle: FontStyle.italic,
      ),
    );
  }
}