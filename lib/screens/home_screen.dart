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
    bool _imageLoaded = false;
    String _currentJingle = '';
    List<String> _availableJingles = [];

    @override
    void initState() {
      super.initState();
      _loadHighScore();
      _loadJingleInfo();
    }

    void _loadJingleInfo() {
      try {
        _isMusicMuted = JinglePlayer().isMuted;
        _availableJingles = JinglePlayer().availableJingles;
        _currentJingle = JinglePlayer().currentJingleName;
        setState(() {}); 
      } catch (e) {
        print('Error getting jingle player state: $e');
        _isMusicMuted = false;
        _currentJingle = '';
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

    void _changeJingle(String jingleName) {
      try {
        JinglePlayer().setJingleByName(jingleName);
        setState(() {
          _currentJingle = jingleName;
        });
      } catch (e) {
        print('Error changing jingle: $e');
      }
    }

    void _playRandomJingle() {
      try {
        JinglePlayer().playRandom().then((_) {
          
          setState(() {
            _currentJingle = JinglePlayer().currentJingleName;
          });
        });
      } catch (e) {
        print('Error playing random jingle: $e');
      }
    }

    @override
    Widget build(BuildContext context) {
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
                  const SizedBox(height: 30),
                  _buildHeaderSection(),
                  const SizedBox(height:15),
                  _buildHighScoreSection(),
                  const SizedBox(height: 20),
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
              size: 26,
            ),
            const SizedBox(width: 12),
            Text(
              'High Score: $_highScore',
              style: const TextStyle(
                fontSize: 20,
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
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
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
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: _openHowToPlayScreen,
            icon: Icon(
              Icons.help_outline,
              color: Colors.pink.shade200,
            ),
            label: Text(
              'How to Play',
              style: TextStyle(
                fontSize: 14,
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
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.purple.shade900.withOpacity(0.3),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildMusicButton(),
                const SizedBox(width: 20),
                _buildRandomJingleButton(),
              ],
            ),
            const SizedBox(height: 16),
            _buildJingleSelector(),
          ],
        ),
      );
    }

    Widget _buildMusicButton() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            iconSize: 22,
            icon: Icon(
              _isMusicMuted ? Icons.music_off : Icons.music_note,
              color: Colors.pink.shade200,
            ),
            onPressed: () {
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
          const Text(
            'Music',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
        ],
      );
    }

    Widget _buildRandomJingleButton() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            iconSize: 22,
            icon: Icon(
              Icons.shuffle,
              color: Colors.pink.shade200,
            ),
            onPressed: _playRandomJingle,
          ),
          const Text(
            'Random',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
        ],
      );
    }

    Widget _buildJingleSelector() {
      if (_availableJingles.isEmpty) {
        return const SizedBox();
      }
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Select Jingle:',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.purple.shade800.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.pink.shade200, width: 1),
            ),
            child: DropdownButton<String>(
              value: _currentJingle.isNotEmpty ? _currentJingle : _availableJingles.first,
              isExpanded: true,
              dropdownColor: Colors.purple.shade800,
              underline: const SizedBox(),
              style: TextStyle(
                color: Colors.pink.shade200,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              icon: Icon(
                Icons.music_note,
                color: Colors.pink.shade200,
              ),
              items: _availableJingles.map((String jingle) {
                return DropdownMenuItem<String>(
                  value: jingle,
                  child: Text(
                    jingle,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  _changeJingle(newValue);
                }
              },
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