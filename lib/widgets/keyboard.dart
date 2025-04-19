import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class KeyboardWidget extends StatefulWidget {
  final Function(String) onKeyPressed;
  final String answer;
  final List<String> guessed;
  final bool gameOver;

  const KeyboardWidget({
    super.key,
    required this.onKeyPressed,
    required this.answer,
    required this.guessed,
    required this.gameOver,
  });

  @override
  State<KeyboardWidget> createState() => _KeyboardWidgetState();
}

class _KeyboardWidgetState extends State<KeyboardWidget> {
  String? lastPressedKey;

  void _handleKeyPress(String letter) {
    setState(() {
      lastPressedKey = letter;
    });
    
    widget.onKeyPressed(letter);
    
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          lastPressedKey = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const lettersRow1 = 'QWERTYUIOP';
    const lettersRow2 = 'ASDFGHJKL';
    const lettersRow3 = 'ZXCVBNM';
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        
        return Container(
          width: availableWidth,
          decoration: BoxDecoration(
            color: Colors.purple.shade900.withOpacity(0.4),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: 1,
              ),
            ],
          ),
          // Reduced padding to use more screen space
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 3),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildKeyRow(lettersRow1, availableWidth - 16), // Account for container padding
              const SizedBox(height: 8),
              _buildKeyRow(lettersRow2, availableWidth -16, isMiddleRow: true),
              const SizedBox(height: 8),
              _buildKeyRow(lettersRow3, availableWidth -16, isBottomRow: true),
            ],
          ),
        );
      }
    );
  }

  Widget _buildKeyRow(String letters, double availableWidth, 
      {bool isMiddleRow = false, bool isBottomRow = false}) {
    
    const keyGap = 6.0;  // Reduced gap between keys
    final numLettersInLongestRow = 10; // QWERTYUIOP has 10 letters
    
    // Calculate key width based on longest row, accounting for gaps
    final keyWidth = (availableWidth - (keyGap * (numLettersInLongestRow - 1))) / numLettersInLongestRow;
    final keyHeight = 58.0; // Fixed height for keys - taller for better feel
    
    // Calculate padding for centered rows
    double sidePadding = 0.0;
    
    if (isMiddleRow) {
      // ASDFGHJKL has 9 letters (1 less than first row)
      sidePadding = (keyWidth + keyGap) / 2;
    } else if (isBottomRow) {
      // ZXCVBNM has 7 letters (3 less than first row)
      sidePadding = (keyWidth + keyGap) * 1.5;
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: sidePadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: letters.split('').map((letter) {
          final isGuessed = widget.guessed.contains(letter);
          final isInWord = widget.answer.contains(letter);
          final isPressed = lastPressedKey == letter;
          
          return _buildKeyboardButton(
            letter, 
            isGuessed, 
            isInWord, 
            isPressed, 
            keyWidth,
            keyHeight,
            keyGap,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildKeyboardButton(
    String letter, 
    bool isGuessed, 
    bool isInWord, 
    bool isPressed,
    double keyWidth,
    double keyHeight,
    double keyGap,
  ) {
    // Base color
    Color baseColor = Colors.purple.shade700;
    
    // Determine button color based on state
    Color buttonColor;
    if (!isGuessed) {
      buttonColor = baseColor;
    } else if (isInWord) {
      buttonColor = Colors.green.shade600;
    } else {
      buttonColor = Colors.grey.shade600;
    }

    // Create a gradient for a more natural 3D touch effect
    LinearGradient buttonGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        buttonColor.withOpacity(0.9),
        buttonColor,
      ],
    );

    Widget keyButton = Padding(
      padding: EdgeInsets.all(keyGap / 2),
      child: Container(
        width: keyWidth,
        height: keyHeight,
        decoration: BoxDecoration(
          gradient: buttonGradient,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isGuessed ? [] : [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isGuessed || widget.gameOver ? null : () => _handleKeyPress(letter),
            borderRadius: BorderRadius.circular(8),
            splashColor: Colors.white.withOpacity(0.1),
            highlightColor: Colors.white.withOpacity(0.1),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  letter,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 1.0,
                        color: Colors.black.withOpacity(0.5),
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    // Apply animation only to the pressed key
    if (isPressed) {
      return keyButton.animate()
        .scale(
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInOut,
          begin: const Offset(1.0, 1.0),
          end: const Offset(0.95, 0.95),
        )
        .then()
        .scale(
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInOut,
          begin: const Offset(0.95, 0.95),
          end: const Offset(1.0, 1.0),
        );
    }

    return keyButton;
  }
}