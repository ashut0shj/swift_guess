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
        // Get screen dimensions
        final Size screenSize = MediaQuery.of(context).size;
        final double screenWidth = screenSize.width;
        final double screenHeight = screenSize.height;
        
        // Determine screen type
        final bool isSmallScreen = screenHeight < 600;
        final bool isWideScreen = screenWidth > 480;
        
        // Calculate responsive base dimensions
        final double baseFontSize = math.min(
          isSmallScreen ? 12.0 : 14.0,
          constraints.maxWidth / 25
        );
        
        final double baseIconSize = math.min(
          isSmallScreen ? 14.0 : 16.0,
          constraints.maxWidth / 30
        );
        
        // Apply scale factor to base dimensions
        final double fontSize = baseFontSize * scaleFactor;
        final double smallFontSize = fontSize * 0.75;
        final double tinyFontSize = fontSize * 0.55;
        final double iconSize = baseIconSize * scaleFactor;
        final double smallIconSize = iconSize * 0.8;
        
        // Calculate padding based on available space
        final double availableWidth = constraints.maxWidth;
        final double horizontalPadding = math.max(4.0, availableWidth / 60) * scaleFactor;
        final double verticalPadding = math.max(3.0, availableWidth / 80) * scaleFactor;
        final double containerBorderRadius = math.max(6.0, availableWidth / 60) * scaleFactor;
        final double itemSpacing = math.max(2.0, availableWidth / 120) * scaleFactor;
        
        // Calculate responsive element width
        final double maxElementWidth = isWideScreen ? 140.0 : 120.0;
        final double minElementWidth = isWideScreen ? 70.0 : 60.0;
        
        // Adapt element width based on available space
        double elementWidth = math.min(
          (availableWidth / 3.2),
          maxElementWidth * scaleFactor
        );
        
        // Ensure minimum and maximum bounds
        elementWidth = math.max(elementWidth, minElementWidth * scaleFactor);
        elementWidth = math.min(elementWidth, availableWidth / 3);

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Difficulty Dropdown
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
                  itemHeight: null, // Let Flutter calculate the optimal height
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize,
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
            
            // Score Display
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
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '$score',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: fontSize,
                              fontWeight: FontWeight.bold,
                            ),
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
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '$highScore',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: smallFontSize,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            // Hint Button
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
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            hintStatus,
                            style: TextStyle(
                              fontSize: tinyFontSize,
                              fontWeight: FontWeight.bold,
                            ),
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