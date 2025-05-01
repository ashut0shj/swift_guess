import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HeartsDisplay extends StatelessWidget {
  final int lives;
  final String difficulty;

  const HeartsDisplay({
    super.key,
    required this.lives,
    required this.difficulty,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Get screen dimensions for responsive sizing
        final Size screenSize = MediaQuery.of(context).size;
        final double screenWidth = screenSize.width;
        final double screenHeight = screenSize.height;
        
        // Check for different screen sizes
        final bool isSmallScreen = screenHeight < 600;
        final bool isWideScreen = screenWidth > 480;
        
        // Calculate padding based on screen size
        final double verticalPadding = screenHeight * 0.015;
        final double horizontalPadding = screenWidth * 0.04;
        
        // Calculate font and icon sizes based on screen dimensions
        final double fontSize = isSmallScreen ? 14 : isWideScreen ? 16 : screenWidth * 0.04;
        double heartSize = isSmallScreen ? 14 : isWideScreen ? 16 : screenWidth * 0.04;
        
        // Determine total hearts based on difficulty
        int totalHearts = difficulty == 'Easy' ? 8 : difficulty == 'Hard' ? 4 : 6;
        
        // For very small screens with many hearts, we might need to adjust further
        if (totalHearts > 6) {
          // Make hearts even smaller when there are many of them
          final double screenAdjustment = screenWidth < 360 ? 0.65 : 0.8;
          heartSize *= screenAdjustment;
        }
        
        return Container(
          padding: EdgeInsets.symmetric(
            vertical: verticalPadding, 
            horizontal: horizontalPadding
          ),
          decoration: BoxDecoration(
            color: Colors.purple.shade900.withOpacity(0.3),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Lives: ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: List.generate(
                  totalHearts,
                  (i) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.003
                      ),
                      child: Icon(
                        Icons.favorite,
                        color: i < lives ? Colors.red : Colors.grey.shade700,
                        size: heartSize,
                      ).animate(target: i < lives ? 1 : 0)
                        .scale(
                          begin: const Offset(1, 1),
                          end: const Offset(1.3, 1.3),
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        )
                        .then()
                        .scale(
                          begin: const Offset(1.3, 1.3),
                          end: const Offset(1, 1),
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}