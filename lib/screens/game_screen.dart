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
import '../data/words.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static const List<String> _songList = SongData.taylorSwiftSongs;
  

  
  
  late String _answer;
  List<String> _guessed = [];
  int _lives = 6;
  bool _gameOver = false;
  bool _dialogShown = false;
  int _score = 0;
  int _hintsUsed = 0;      
  int _maxHints = 3;       
  String _difficulty = 'Medium';
  int _highScore = 0;
  bool _isNewHighScore = false;
  
  
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
      _hintsUsed = 0;     
      _showCelebration = false;
      _isRevealingLetters = false;
      _gameOver = false;
      _dialogShown = false;
      
      
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
        
        _score += _lives * (10 - (_hintsUsed * 2));
        
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
    
    await SystemChannels.platform.invokeMethod<void>('HapticFeedback.vibrate');
    
    setState(() => _isRevealingLetters = true);
    
    final unguessedLetters = _answer.split('')
        .where((c) => c != ' ' && !_guessed.contains(c))
        .toList();

    
    for (final letter in unguessedLetters) {
      await Future.delayed(300.milliseconds);
      if (mounted) {
        setState(() => _guessed.add(letter));
      }
    }
    
    
    
    
    if (_score > _highScore) {
      await ScoreRepository.saveHighScore(_score);
      if (mounted) {
        setState(() {
          _highScore = _score;
          _isNewHighScore = true;
        });
      }
    }
    
    
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
                      
                      
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                        ),
                        child: HeartsDisplay(lives: _lives, difficulty: _difficulty),
                      ),
                      
                      
                      Expanded(
                        flex: 1,
                        child: SizedBox(),
                      ),
                      
                      
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
                      
                      
                      Expanded(
                        flex: 1,
                        child: SizedBox(),
                      ),
                      
                      
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