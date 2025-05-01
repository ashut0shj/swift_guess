import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math';

class WordDisplay extends StatelessWidget {
  final String answer;
  final List<String> guessed;
  final double? maxHeight;
  final double scaleFactor; // Manual scaling factor

  const WordDisplay({
    super.key,
    required this.answer,
    required this.guessed,
    this.maxHeight,
    this.scaleFactor = 1.0, // Default scale factor
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Get screen dimensions for reference
        final Size screenSize = MediaQuery.of(context).size;
        final double screenWidth = screenSize.width;
        final double screenHeight = screenSize.height;
        
        // Determine if we're on a small screen
        final bool isSmallScreen = screenHeight < 600;
        final bool isWideScreen = screenWidth > 480;
        
        List<String> words = answer.split(' ');
        final int wordCount = words.length;
        
        // Find longest word length and total characters for calculations
        final int maxWordLength = words.fold(0, (max, word) => word.length > max ? word.length : max);
        final int totalCharacters = answer.replaceAll(' ', '').length;
        
        // Available space
        double containerWidth = constraints.maxWidth;
        double availableHeight = maxHeight ?? constraints.maxHeight;
        
        // Base size calculations
        double availableWidth = containerWidth * 0.90; // Use 95% of container width
        
        // Determine optimal letter size based on complexity of the puzzle
        double optimalLetterSize;
        
        // For short answers or few words, allow larger letter size
        if (totalCharacters <= 12 && wordCount <= 2) {
          // For very simple puzzles, use larger size
          optimalLetterSize = min(
            availableWidth / (maxWordLength + 1),
            availableHeight / (wordCount * 2)
          );
          optimalLetterSize = min(optimalLetterSize, 50.0); // Cap at 50
        } else if (totalCharacters <= 20 && wordCount <= 3) {
          // For medium puzzles
          optimalLetterSize = min(
            availableWidth / (maxWordLength + 1),
            availableHeight / (wordCount * 1.8)
          );
          optimalLetterSize = min(optimalLetterSize, 44.0); // Cap at 44
        } else {
          // For complex puzzles with many letters or words
          optimalLetterSize = min(
            availableWidth / (maxWordLength + 1),
            availableHeight / (wordCount * 1.6)
          );
          
          // Additional reduction for very long puzzles
          if (totalCharacters > 30 || wordCount > 4) {
            optimalLetterSize *= 0.85;
          }
        }
        
        // Apply scale factor
        double letterSize = optimalLetterSize * scaleFactor;
        
        // Scale down for small screens
        if (isSmallScreen) {
          letterSize *= 0.9;
        }
        
        // Ensure size isn't too small or too large
        letterSize = letterSize.clamp(16.0, 46.0);
        
        // Adjust padding based on letter size
        final padding = letterSize > 36 ? 8.0 : 
                       letterSize > 30 ? 6.0 : 
                       letterSize > 24 ? 4.0 : 2.0;
                       
        final fontSize = letterSize * 0.65;
        
        // Calculate vertical spacing between words
        final double wordSpacing = wordCount > 3 ? 
                                  screenHeight * 0.005 : 
                                  screenHeight * 0.008;

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: availableHeight,
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: words.map((word) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: wordSpacing),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: word.split('').map((c) {
                        final isGuessed = guessed.contains(c.toUpperCase());
                        final letterBox = Container(
                          margin: EdgeInsets.symmetric(horizontal: padding / 2),
                          padding: EdgeInsets.symmetric(
                            vertical: padding,
                            horizontal: padding,
                          ),
                          constraints: BoxConstraints(
                            minWidth: letterSize,
                            maxWidth: letterSize,
                            minHeight: letterSize * 1.2,
                            maxHeight: letterSize * 1.2,
                          ),
                          decoration: BoxDecoration(
                            gradient: isGuessed 
                              ? LinearGradient(
                                  colors: [Colors.purple.shade300, Colors.purple.shade700],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : LinearGradient(
                                  colors: [Colors.grey.shade300, Colors.grey.shade100],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                            borderRadius: BorderRadius.circular(letterSize * 0.2),
                            boxShadow: [
                              BoxShadow(
                                color: isGuessed 
                                  ? Colors.purple.withOpacity(0.3)
                                  : Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              isGuessed ? c.toUpperCase() : '_',
                              style: TextStyle(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        );
                        
                        return isGuessed 
                          ? letterBox.animate()
                              .shimmer(duration: 800.ms, delay: 0.ms)
                              .scale(begin: const Offset(0.95, 0.95), duration: 150.ms)
                          : letterBox;
                      }).toList(),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      }
    );
  }
}