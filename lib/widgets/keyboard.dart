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
    
    
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;
    
    
    final bool isSmallScreen = screenHeight < 600;
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        
        
        final double keyboardPaddingVertical = isSmallScreen ? 12 : 16;
        final double keyboardPaddingHorizontal = screenWidth * 0.01;
        final double keyRowSpacing = isSmallScreen ? 6 : 8;
        
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
          padding: EdgeInsets.symmetric(
            vertical: keyboardPaddingVertical,
            horizontal: keyboardPaddingHorizontal,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildKeyRow(lettersRow1, availableWidth - (keyboardPaddingHorizontal * 2)),
              SizedBox(height: keyRowSpacing),
              _buildKeyRow(lettersRow2, availableWidth - (keyboardPaddingHorizontal * 2), isMiddleRow: true),
              SizedBox(height: keyRowSpacing),
              _buildKeyRow(lettersRow3, availableWidth - (keyboardPaddingHorizontal * 2), isBottomRow: true),
            ],
          ),
        );
      }
    );
  }

  Widget _buildKeyRow(String letters, double availableWidth, 
      {bool isMiddleRow = false, bool isBottomRow = false}) {
    
    
    final Size screenSize = MediaQuery.of(context).size;
    final double screenHeight = screenSize.height;
    final double screenWidth = screenSize.width;
    
    
    final bool isSmallScreen = screenHeight < 600;
    final bool isWideScreen = screenWidth > 480;
    
    
    final double keyGap = isSmallScreen ? 4.0 : 6.0;
    
    
    final int numLettersInLongestRow = 10; 
    
    
    final double keyWidth = (availableWidth - (keyGap * (numLettersInLongestRow + 0.5))) / numLettersInLongestRow;
    
    
    final double keyHeight = isSmallScreen 
        ? screenHeight * 0.056  
        : isWideScreen 
            ? 58.0  
            : screenHeight * 0.064;  
    
    
    double sidePadding = 0.0;
    
    if (isMiddleRow) {
      
      sidePadding = (keyWidth + keyGap) / 2 -1;
    } else if (isBottomRow) {
      
      sidePadding = (keyWidth + keyGap) * 1.5 -2;
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
    
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    
    
    final double fontSize = screenWidth < 360 ? 16 : 20;
    
    
    Color baseColor = Colors.purple.shade700;
    
    
    Color buttonColor;
    if (!isGuessed) {
      buttonColor = baseColor;
    } else if (isInWord) {
      buttonColor = Colors.green.shade600;
    } else {
      buttonColor = Colors.grey.shade600;
    }

    
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
                    fontSize: fontSize,
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