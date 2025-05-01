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
        final int maxWordLength = words.fold(0, (max, word) => word.length > max ? word.length : max);
        
        // Calculate responsive sizes based on screen dimensions rather than available space
        // This makes it consistent with keyboard sizing
        double baseSize = screenWidth * 0.082; // Base size proportional to screen width
        
        // Adjust for different screen ratios while keeping proportional to keyboard
        if (isSmallScreen) {
          baseSize *= 0.85; // Smaller on small screens
        } else if (isWideScreen && screenHeight < 800) {
          baseSize *= 0.9; // Slightly smaller on wide but not tall screens
        }
        
        // Account for longer words or multiple rows
        if (maxWordLength > 8) {
          baseSize *= 0.85;
        }
        if (wordCount > 2) {
          baseSize *= 0.9;
        }
        
        // Clamp to reasonable sizes - similar to keyboard sizing approach
        final letterSize = baseSize.clamp(22.0, 42.0);
        final padding = letterSize > 30 ? 8.0 : letterSize > 24 ? 6.0 : 4.0;
        final fontSize = letterSize * 0.6;

        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: words.map((word) {
              final needsScroll = word.length > (screenWidth / letterSize * 0.6).floor(); // Dynamic assessment if scrolling needed
              
              return Padding(
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.006), // Proportional vertical padding
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
    );
  }
}