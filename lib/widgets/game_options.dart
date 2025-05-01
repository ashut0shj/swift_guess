import 'package:flutter/material.dart';
import 'dart:math' as math;

class GameOptions extends StatelessWidget {
  final String difficulty;
  final int score;
  final int highScore;
  final bool hintUsed;
  final int hintsRemaining;
  final String hintStatus;
  final bool gameOver;
  final Function(String) onDifficultyChanged;
  final VoidCallback onHintPressed;
  final double scaleFactor; 

  const GameOptions({
    super.key,
    required this.difficulty,
    required this.score,
    required this.highScore,
    required this.hintUsed,
    this.hintsRemaining = 0,
    this.hintStatus = "",
    required this.gameOver,
    required this.onDifficultyChanged,
    required this.onHintPressed,
    this.scaleFactor = 1.0, 
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        
        final Size screenSize = MediaQuery.of(context).size;
        final double screenWidth = screenSize.width;
        final double screenHeight = screenSize.height;
        
        
        final bool isSmallScreen = screenHeight < 600;
        final bool isWideScreen = screenWidth > 480;
        
        
        
        final double baseFontSize = isSmallScreen ? 12.0 : 16.0;
        final double baseSmallFontSize = isSmallScreen ? 9.0 : 11.0;
        final double baseTinyFontSize = isSmallScreen ? 6.0 : 8.0;
        final double baseIconSize = isSmallScreen ? 12.0 : 14.0;
        final double baseSmallIconSize = isSmallScreen ? 10.0 : 12.0;
        
        
        final double fontSize = baseFontSize * scaleFactor;
        final double smallFontSize = baseSmallFontSize * scaleFactor;
        final double tinyFontSize = baseTinyFontSize * scaleFactor;
        final double iconSize = baseIconSize * scaleFactor;
        final double smallIconSize = baseSmallIconSize * scaleFactor;
        
        
        final double horizontalPadding = 8.0 * scaleFactor;
        final double verticalPadding = 6.0 * scaleFactor;
        final double containerBorderRadius = 8.0 * scaleFactor;
        final double itemSpacing = 4.0 * scaleFactor;
        
        
        final double availableWidth = constraints.maxWidth;
        
        
        double elementWidth;
        if (isWideScreen) {
          
          elementWidth = math.min((availableWidth / 3.5), 120.0 * scaleFactor);
        } else {
          
          elementWidth = math.min((availableWidth / 3.2), 100.0 * scaleFactor);
        }
        
        
        elementWidth = math.max(elementWidth, 60.0 * scaleFactor);
        elementWidth = math.min(elementWidth, 160.0 * scaleFactor);
        
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            
            SizedBox(
              width: elementWidth,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(containerBorderRadius),
                  color: Colors.purple.shade800,
                ),
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: DropdownButton<String>(
                  value: difficulty,
                  dropdownColor: Colors.purple.shade900,
                  underline: Container(),
                  isExpanded: true,
                  itemHeight: kMinInteractiveDimension * (scaleFactor > 0.8 ? scaleFactor : 0.8),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize - (4 * scaleFactor),
                  ),
                  icon: Icon(
                    Icons.arrow_drop_down, 
                    color: Colors.white,
                    size: fontSize * 1.2,
                  ),
                  items: <String>['Easy', 'Medium', 'Hard']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(fontSize: fontSize),
                      ),
                    );
                  }).toList(),
                  onChanged: gameOver ? null : (String? newValue) {
                    if (newValue != null) {
                      onDifficultyChanged(newValue);
                    }
                  },
                ),
              ),
            ),
            
            
            SizedBox(
              width: elementWidth,
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: verticalPadding, 
                  horizontal: horizontalPadding,
                ),
                decoration: BoxDecoration(
                  color: Colors.purple.shade800,
                  borderRadius: BorderRadius.circular(containerBorderRadius),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star, 
                          color: Colors.amber, 
                          size: iconSize
                        ),
                        SizedBox(width: itemSpacing),
                        Text(
                          '$score',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: itemSpacing / 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.leaderboard, 
                          color: Colors.purpleAccent, 
                          size: smallIconSize
                        ),
                        SizedBox(width: itemSpacing / 2),
                        Text(
                          '$highScore',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: smallFontSize,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            
            SizedBox(
              width: elementWidth,
              child: ElevatedButton(
                onPressed: hintsRemaining <= 0 || gameOver ? null : onHintPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black87,
                  disabledBackgroundColor: Colors.grey.shade400,
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding, 
                    vertical: verticalPadding
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lightbulb_outline, size: iconSize),
                    SizedBox(width: itemSpacing),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Hint',
                          style: TextStyle(fontSize: smallFontSize),
                        ),
                        Text(
                          hintStatus,
                          style: TextStyle(
                            fontSize: tinyFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }
    );
  }
}