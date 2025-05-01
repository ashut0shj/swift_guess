import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/services.dart';
import '../widgets/keyboard.dart';
import '../widgets/word_display.dart';
import '../widgets/hearts.dart';
import '../widgets/game_options.dart';
import '../widgets/game_over_dialog.dart';
import '../data/score_repository.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static const List<String> _songList = [
    'LOVER', 'BLANK SPACE', 'SHAKE IT OFF', 'CRUEL SUMMER', 'ENCHANTED',
    'LOVE STORY', 'CARDIGAN', 'WILDEST DREAMS', 'RED', 'YOU BELONG WITH ME',
    'ANTI HERO', 'KARMA', 'BEJEWELED', 'STYLE', 'DELICATE',
    'THE ARCHER', 'THE MAN', 'AUGUST', 'EXILE', 'WILLOW',
    'CHAMPAGNE PROBLEMS', 'CORNELIA STREET', 'MINE', 'OUR SONG',
    'TEARDROPS ON MY GUITAR', 'BACK TO DECEMBER', 'I KNEW YOU WERE TROUBLE',
     'FORTNIGHT', 'DOWN BAD', 'SO LONG LONDON', 'FLORIDA',
    'GUILTY AS SIN', 'LOML', 'THE ALBATROSS', 'HOW DID IT END',
    'THE PROPHECY', 'CASSANDRA', 'PETER', 'AFTERGLOW', 'ALL TOO WELL',
    'BREATHE', 'CLEAN', 'CLOSURE', 'HOAX', 'INNOCENT', 'INVISIBLE',
    'MAROON', 'MEAN', 'MIRRORBALL', 'SUBURBAN LEGENDS', 'SUPERSTAR',
    'TREACHEROUS', 'UNTILTED', 'VIGILANTE SHIT', 'DEATH BY A THOUSAND CUTS',
    'EVERMORE', 'THE ONE', 'SEVEN', 'HAPPINESS', 'PEACE',
    'GOLD RUSH', 'ITS TIME TO GO', 'TOLERATE IT', 'THIS LOVE',
    'BEGIN AGAIN', 'STAY STAY STAY', 'NEW ROMANTICS',
    'DAYLIGHT', 'CALL IT WHAT YOU WANT', 'GETAWAY CAR',
    'DOROTHEA', 'BETTY', 'MISS AMERICANA', 'LONG LIVE', 'THE STORY OF US',
    'WHITE HORSE', 'SPARKS FLY', 'DEAR JOHN', 'HAUNTED',
    'OURS', 'CHANGE', 'JUMP THEN FALL', 'FEARLESS', 'HOLY GROUND',
    'THE LAST TIME', 'KING OF MY HEART', 'I WISH YOU WOULD',
    'OUT OF THE WOODS', 'BAD BLOOD'
  ];

  
  // Game state
  late String _answer;
  List<String> _guessed = [];
  int _lives = 6;
  bool _gameOver = false;
  bool _dialogShown = false;
  int _score = 0;
  int _hintsUsed = 0;      // Changed from bool to int to track multiple hints
  int _maxHints = 3;       // Maximum hints allowed per round
  String _difficulty = 'Medium';
  int _highScore = 0;
  bool _isNewHighScore = false;
  
  // Animation states
  bool _showCelebration = false;
  bool _isRevealingLetters = false;
  late ConfettiController _confettiController;
  
  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: 3.seconds);
    _loadHighScore();
    _startNewRound();
  }
  
  Future<void> _loadHighScore() async {
    _highScore = await ScoreRepository.getHighScore();
    if (mounted) setState(() {});
  }
  
  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }
  
  void _startNewRound() {
    setState(() {
      _answer = _songList[Random().nextInt(_songList.length)].toUpperCase();
      _guessed.clear();
      _hintsUsed = 0;     // Reset hints used
      _showCelebration = false;
      _isRevealingLetters = false;
      _gameOver = false;
      _dialogShown = false;
      
      // Set max hints based on difficulty
      _maxHints = _difficulty == 'Easy' ? 4 : _difficulty == 'Hard' ? 2 : 3;
    });
  }
  
  void _guessLetter(String letter) {
    if (_gameOver || _isRevealingLetters) return;
    letter = letter.toUpperCase();
    
    setState(() {
      if (!_answer.contains(letter)) {
        _lives--;
      }
      
      if (!_guessed.contains(letter)) {
        _guessed.add(letter);
      }
      _checkWinCondition();
      _checkLoseCondition();
    });
  }
  
  void _checkWinCondition() {
    final allLettersGuessed = _answer.split('').every((c) => 
      c == ' ' || _guessed.contains(c));
    
    if (allLettersGuessed && !_gameOver) {
      setState(() {
        _gameOver = true;
        // Calculate score with penalty for hints used
        _score += _lives * (10 - (_hintsUsed * 2));
        // Ensure minimum score per round
        _score = max(_score, _lives);
      });
      _startWinAnimation();
    }
  }
  
  void _checkLoseCondition() {
    if (_lives <= 0 && !_gameOver) {
      setState(() => _gameOver = true);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startLoseAnimation();
      });
    }
  }
  
  void _startWinAnimation() async {
    setState(() => _showCelebration = true);
    _confettiController.play();
    await Future.delayed(2.seconds);
    if (mounted) _showGameOverDialog('win');
  }
  
  void _startLoseAnimation() async {
    // Vibrate on loss
    await SystemChannels.platform.invokeMethod<void>('HapticFeedback.vibrate');
    
    setState(() => _isRevealingLetters = true);
    
    final unguessedLetters = _answer.split('')
        .where((c) => c != ' ' && !_guessed.contains(c))
        .toList();

    // Reveal letters one by one with animation
    for (final letter in unguessedLetters) {
      await Future.delayed(300.milliseconds);
      if (mounted) {
        setState(() => _guessed.add(letter));
      }
    }
    
    // Show overlay with song name
    
    // Check high score
    if (_score > _highScore) {
      await ScoreRepository.saveHighScore(_score);
      if (mounted) {
        setState(() {
          _highScore = _score;
          _isNewHighScore = true;
        });
      }
    }
    
    // Important: Add a delay after animations complete
    await Future.delayed(1.seconds);
    
    if (mounted) {
      setState(() => _isRevealingLetters = false);
      _showGameOverDialog('lose');
    }
  }
  
  void _useHint() {
    if (_hintsUsed >= _maxHints || _gameOver || _isRevealingLetters) return;
    
    List<String> unguessedLetters = _answer.split('')
        .where((c) => c != ' ' && !_guessed.contains(c))
        .toSet()
        .toList();
    
    if (unguessedLetters.isNotEmpty) {
      setState(() {
        _hintsUsed++;
        _guessLetter(unguessedLetters[Random().nextInt(unguessedLetters.length)]);
      });
    }
  }
  
  void _changeDifficulty(String newDifficulty) {
    setState(() {
      _difficulty = newDifficulty;
      _lives = newDifficulty == 'Easy' ? 8 : newDifficulty == 'Hard' ? 4 : 6;
      _restartGame();
    });
  }
  
  Future<void> _showGameOverDialog(String result) async {
    if (_dialogShown) return;
    setState(() => _dialogShown = true);
    
    await GameResult.showGameOverDialog(
      context: context,
      result: result,
      answer: _answer,
      score: _score,
      highScore: _highScore,
      isNewHighScore: _isNewHighScore,
      onPlayAgain: _restartGame,
    );
    
    if (mounted) {
      setState(() {
        _dialogShown = false;
        _showCelebration = false;
        _isNewHighScore = false;
      });
    }
    
    // Reset score after dialog dismissal for lose case
    if (result == 'lose' && mounted) {
      setState(() {
        _score = 0;
      });
    }
  }
  
  void _restartGame() {
    setState(() {
      _lives = _difficulty == 'Easy' ? 8 : _difficulty == 'Hard' ? 4 : 6;
      _startNewRound();
    });
  }
  
  // Helper method to get hint status text
  String get _hintStatusText {
    return '$_hintsUsed/$_maxHints';
  }
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xFF18122B),
          appBar: AppBar(
            backgroundColor: Colors.purple.shade800,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/home_image.png',
                  width: MediaQuery.of(context).size.width * 0.07,
                  height: MediaQuery.of(context).size.width * 0.07,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.music_note),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                const Text('Swift Guess', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white,)),
              ],
            ),
            centerTitle: true,
          ),
          body: Container(
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
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final double horizontalPadding = constraints.maxWidth * 0.04;
                  
                  return Column(
                    children: [
                      // Game options section - at the top
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                          vertical: constraints.maxHeight * 0.02,
                        ),
                        child: GameOptions(
                          difficulty: _difficulty,
                          score: _score,
                          highScore: _highScore,
                          hintUsed: _hintsUsed > 0,
                          hintsRemaining: _maxHints - _hintsUsed,
                          hintStatus: _hintStatusText,
                          gameOver: _gameOver,
                          onDifficultyChanged: _changeDifficulty,
                          onHintPressed: _useHint,
                        ),
                      ),
                      
                      // Hearts display - below game options
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                        ),
                        child: HeartsDisplay(lives: _lives, difficulty: _difficulty),
                      ),
                      
                      // This expander pushes content down from the top
                      Expanded(
                        flex: 1,
                        child: SizedBox(),
                      ),
                      
                      // Word display container - now centered vertically in available space
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: constraints.maxHeight * 0.03,
                            horizontal: horizontalPadding,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                          ),
                          child: WordDisplay(answer: _answer, guessed: _guessed),
                        ),
                      ),
                      
                      // This expander pushes content up from the bottom
                      Expanded(
                        flex: 1,
                        child: SizedBox(),
                      ),
                      
                      // Keyboard always at bottom
                      Padding(
                        padding: EdgeInsets.only(
                          left: horizontalPadding * 0.5,
                          right: horizontalPadding * 0.5,
                          bottom: constraints.maxHeight * 0.01,
                        ),
                        child: KeyboardWidget(
                          onKeyPressed: _guessLetter,
                          answer: _answer,
                          guessed: _guessed,
                          gameOver: _gameOver || _isRevealingLetters,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        
        // Confetti overlay for wins
        if (_showCelebration)
          IgnorePointer(
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              colors: const [
                Colors.pink,
                Colors.purple,
                Colors.white,  
                Colors.yellow,
              ],
            ),
          ),
      ],
    );
  }
}