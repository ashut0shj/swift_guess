import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class WordDisplay extends StatelessWidget {
  final String answer;
  final List<String> guessed;

  const WordDisplay({
    super.key,
    required this.answer,
    required this.guessed,
  });

  @override
  Widget build(BuildContext context) {
    List<String> words = answer.split(' ');
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Calculate dynamic sizes based on word count and longest word
    final int wordCount = words.length;
    final int maxWordLength = words.fold(0, (max, word) => word.length > max ? word.length : max);
    
    // Adjust base letter size based on both rows and max word length
    double baseSizeByWidth = (screenWidth * 0.85) / maxWordLength;
    double baseSizeByHeight = (screenHeight * 0.3) / wordCount;
    double baseLetterSize = baseSizeByWidth < baseSizeByHeight ? baseSizeByWidth : baseSizeByHeight;
    
    // Additional adjustment for very long words or many rows
    if (wordCount > 3) {
      baseLetterSize *= 0.8;
    }
    if (maxWordLength > 8) {
      baseLetterSize *= 0.85;
    }
    
    // Clamp size to reasonable bounds
    final letterSize = baseLetterSize.clamp(18.0, 40.0);
    final padding = letterSize > 30 ? 8.0 : letterSize > 24 ? 6.0 : 4.0;
    final fontSize = letterSize * 0.6;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: words.map((word) {
          final needsScroll = word.length > 10;
          
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: needsScroll ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
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
                        ),
                        decoration: BoxDecoration(
                          gradient: isGuessed 
                            ? LinearGradient(
                                colors: [Colors.purple.shade300, Colors.purple.shade700],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : LinearGradient(
                                colors: [Colors.grey.shade200, Colors.white],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                          borderRadius: BorderRadius.circular(letterSize * 0.2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purple.withOpacity(0.3),
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
                              color: isGuessed ? Colors.white : Colors.black54,
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
                ),
                
                // Scroll indicator (only shows when needed)
                if (needsScroll) ...[
                  Positioned(
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.chevron_left,
                        color: Colors.white.withOpacity(0.8),
                        size: 24,
                      ).animate(
                        onPlay: (controller) => controller.repeat(),
                      ).fadeIn(duration: 500.ms).then().fadeOut(duration: 500.ms),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.chevron_right,
                        color: Colors.white.withOpacity(0.8),
                        size: 24,
                      ).animate(
                        onPlay: (controller) => controller.repeat(),
                      ).fadeIn(duration: 500.ms).then().fadeOut(duration: 500.ms),
                    ),
                  ),
                ],
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}