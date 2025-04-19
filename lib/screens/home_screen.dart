import 'package:flutter/material.dart';
import 'game_screen.dart';
import '../data/score_repository.dart';
import 'package:flutter_animate/flutter_animate.dart';
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


  @override
  void initState() {
    super.initState();
    _loadHighScore();
    _isMusicMuted = JinglePlayer().isMuted;
    _areSfxMuted = JinglePlayer().isMuted;
  }

  Future<void> _loadHighScore() async {
    final score = await ScoreRepository.getHighScore();
    setState(() {
      _highScore = score;
    });
  }

  void _showHowToPlay(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: const Color(0xFF8A2BE2),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 10,
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'How to Play',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            _buildInstructionRow('1', 'Guess Taylor Swift song titles'),
            _buildInstructionRow('2', 'Each wrong guess loses a heart'),
            _buildInstructionRow('3', 'Use hints if you get stuck!'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Got it!', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionRow(String number, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.pinkAccent,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final imageSize = screenHeight * 0.4; // 40% of screen height

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFDA70D6), Color(0xFF8A2BE2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const Spacer(flex: 1),
                // Larger App Logo/Image
                Hero(
                  tag: 'app_logo',
                  child: Image.asset(
                    'assets/images/home_image.png',
                    width: imageSize,
                    height: imageSize,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 20),
                // Title with animation
                Animate(
                  effects: [FadeEffect(), ScaleEffect()],
                  child: const Text(
                    'Swiftie Guess',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 10,
                          color: Colors.black38,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Can you guess all the songs?',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),
                const Spacer(),
                // High Score Display
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '🏆 High Score: $_highScore',
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Start Game Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const GameScreen()),
                    ).then((_) => _loadHighScore());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 8,
                    shadowColor: Colors.pinkAccent.withOpacity(0.5),
                  ),
                  child: const Text(
                    'Start Game',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                // How to Play Button
                TextButton(
                  onPressed: () => _showHowToPlay(context),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'How to Play',
                    style: TextStyle(fontSize: 18, decoration: TextDecoration.underline),
                  ),
                ),
                Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    IconButton(
      iconSize: 32,
      icon: Icon(
        _isMusicMuted ? Icons.music_off : Icons.music_note,
        color: Colors.white,
      ),
      onPressed: () {
        setState(() {
          JinglePlayer().toggleMute();
          _isMusicMuted = !_isMusicMuted;
        });
      },
    ),
    const SizedBox(width: 20),
    IconButton(
      iconSize: 32,
      icon: Icon(
        _areSfxMuted ? Icons.volume_off : Icons.volume_up,
        color: Colors.white,
      ),
      onPressed: () {
        setState(() {
          _areSfxMuted = !_areSfxMuted;
          // You can later use _areSfxMuted to conditionally play sfx
        });
      },
    ),

    
  ],
),Positioned(
      bottom: 20, // Adjust this to your preference
      left: 0,
      right: 0,
      child: Center(
        child: Text(
          '~ ashut0sh ❤️',
          style: TextStyle(
            fontSize: 10, // Very small text size
            color: Colors.white, // White color or any color of your choice
            fontWeight: FontWeight.w300, // Optional: Light font weight for subtlety
            fontStyle: FontStyle.italic, // Optional: Italic style for emphasis
          ),
        ),
      ),
    ),
const SizedBox(height: 16),

                const Spacer(flex: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}