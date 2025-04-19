import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math';
import 'package:confetti/confetti.dart';

class GameResult {
  static Future<void> showGameOverDialog({
    required BuildContext context,
    required String result,
    required String answer,
    required int score,
    required int highScore,
    required bool isNewHighScore,
    required VoidCallback onPlayAgain,
  }) async {
    final isWin = result == 'win';
    
    // Simplify asset selection with lists
    final images = isWin 
        ? List.generate(5, (i) => 'assets/images/win/win${i+1}.png')
        : List.generate(3, (i) => 'assets/images/lose/lose${i+1}.png');
    final imagePath = images[Random().nextInt(images.length)];

    // Theme colors
    final theme = _GameResultTheme(isWin);
    
    // Confetti controller
    final confettiController = ConfettiController(duration: const Duration(seconds: 4));
    if (isWin) confettiController.play();

    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.9),
      builder: (BuildContext context) {
        final dialogWidth = MediaQuery.of(context).size.width > 500
            ? 460.0
            : MediaQuery.of(context).size.width * 0.82;
            
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: dialogWidth,
                  margin: const EdgeInsets.symmetric(vertical: 40),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [theme.backgroundColor.withOpacity(0.95), theme.cardColor.withOpacity(0.95)],
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildImageHeader(imagePath, theme),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                        child: Column(
                          children: [
                            _buildResultMessage(isWin, theme),
                            if (!isWin) _buildAnswerDisplay(answer, theme),
                            const SizedBox(height: 24),
                            _buildScorePanel(score, highScore, isNewHighScore, isWin, theme),
                            const SizedBox(height: 32),
                            _buildButtonRow(context, onPlayAgain, theme),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate().slideY(begin: 0.2, end: 0, duration: 200.ms).fadeIn(duration: 300.ms),
                
              ],
            ),
          ),
        );
      },
    ).then((_) => confettiController.dispose());
  }
  
  // Split widget methods to improve readability
  static Widget _buildImageHeader(String imagePath, _GameResultTheme theme) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          height: 240,
          width: double.infinity,
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: theme.primaryColor.withOpacity(0.3),
                child: Center(
                  child: Icon(
                    theme.isWin ? Icons.celebration : Icons.music_note_outlined,
                    size: 64,
                    color: theme.accentColor,
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          height: 240,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                theme.backgroundColor.withOpacity(0.95),
              ],
              stops: const [0.6, 1.0],
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
            decoration: BoxDecoration(
              color: theme.accentColor.withOpacity(0.95),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              theme.isWin ? 'You Win!' : 'Game Over',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: theme.backgroundColor,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  static Widget _buildResultMessage(bool isWin, _GameResultTheme theme) {
    return Text(
      isWin
          ? 'Congratulations! You guessed all the letters correctly.'
          : 'Better luck next time! The song was:',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 16,
        color: theme.textColor.withOpacity(0.95),
        height: 1.4,
      ),
    );
  }
  
  static Widget _buildAnswerDisplay(String answer, _GameResultTheme theme) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: theme.accentColor.withOpacity(0.25),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: theme.accentColor),
        ),
        child: Text(
          answer,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: theme.accentColor,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }
  
  static Widget _buildScorePanel(int score, int highScore, bool isNewHighScore, bool isWin, _GameResultTheme theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.backgroundColor.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Final Score',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: theme.textColor.withOpacity(0.9),
                ),
              ),
              const SizedBox(width: 12),
              _buildScoreBadge(score, isWin, theme),
            ],
          ),
          if (isNewHighScore)
            _buildHighScoreBadge()
          else if (!isWin)
            _buildRegularHighScore(highScore, theme),
        ],
      ),
    );
  }
  
  static Widget _buildScoreBadge(int score, bool isWin, _GameResultTheme theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.accentColor.withOpacity(0.25),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.accentColor),
      ),
      child: Row(
        children: [
          Icon(Icons.star_rounded, color: isWin ? Colors.amber : theme.accentColor, size: 20),
          const SizedBox(width: 4),
          Text(
            score.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: theme.textColor,
            ),
          ),
        ],
      ),
    ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
      begin: const Offset(1.0, 1.0),
      end: const Offset(1.05, 1.05),
      duration: 1.seconds,
    );
  }
  
  static Widget _buildHighScoreBadge() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.amber.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.amber),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.emoji_events, color: Colors.amber, size: 24),
            SizedBox(width: 8),
            Text(
              'NEW HIGH SCORE!',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 500.ms).then().shimmer(duration: 1.5.seconds, delay: 500.ms);
  }
  
  static Widget _buildRegularHighScore(int highScore, _GameResultTheme theme) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'High Score: ',
            style: TextStyle(fontSize: 14, color: theme.textColor.withOpacity(0.7)),
          ),
          Text(
            highScore.toString(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: theme.textColor,
            ),
          ),
        ],
      ),
    );
  }
  
  static Widget _buildButtonRow(BuildContext context, VoidCallback onPlayAgain, _GameResultTheme theme) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: theme.accentColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Exit', style: TextStyle(fontSize: 16)),
          ),
        ),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onPlayAgain();
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: theme.backgroundColor,
              backgroundColor: theme.buttonColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Play Again', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                Icon(Icons.refresh_rounded, size: 18, color: theme.backgroundColor),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  
}

// Helper class to manage theme colors
class _GameResultTheme {
  final bool isWin;
  late final Color primaryColor;
  late final Color backgroundColor;
  late final Color cardColor;
  late final Color textColor;
  late final Color accentColor;
  late final Color buttonColor;
  
  _GameResultTheme(this.isWin) {
    primaryColor = isWin ? const Color(0xFF9C27B0) : const Color(0xFFE53935);
    backgroundColor = isWin ? const Color(0xFF3E2C94) : const Color(0xFF701818);
    cardColor = isWin ? const Color(0xFF5A4BCF) : const Color(0xFFA01A1A);
    textColor = Colors.white;
    accentColor = isWin ? const Color(0xFFF3E5F5) : const Color(0xFFFFE0B2);
    buttonColor = isWin ? const Color(0xFFAB87EA) : const Color(0xFFFF6F61);
  }
}