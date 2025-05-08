import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;

class HeartsDisplay extends StatelessWidget {
  final int lives;
  final String difficulty;
  final double scaleFactor;

  const HeartsDisplay({
    super.key,
    required this.lives,
    required this.difficulty,
    this.scaleFactor = 1,
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
        
        
        int totalHearts = difficulty == 'Easy' ? 8 : difficulty == 'Hard' ? 4 : 6;
        
        
        final double availableWidth = constraints.maxWidth;
        
        
        final double baseFontSize = math.min(
          isSmallScreen ? 14.0 : 16.0, 
          availableWidth / 22
        );
        
        
        final double fontSize = baseFontSize * scaleFactor;
        
        
        
        double baseHeartSize = math.min(
          isSmallScreen ? 14.0 : 16.0,
          availableWidth / 24
        );
        
        
        double heartSize = baseHeartSize * scaleFactor;
        
        
        final double horizontalPadding = math.max(8.0, availableWidth / 40) * scaleFactor;
        final double verticalPadding = math.max(4.0, availableWidth / 80) * scaleFactor;
        final double heartSpacing = math.max(2.0, availableWidth / 160) * scaleFactor;
        final double borderRadius = math.max(12.0, availableWidth / 40) * scaleFactor;
        
        
        final double estimatedTextWidth = fontSize * 5; 
        
        
        final double availableHeartSpace = availableWidth - (horizontalPadding * 2) - estimatedTextWidth;
        final double maxHeartWidth = availableHeartSpace / totalHearts - heartSpacing;
        
        
        if (heartSize > maxHeartWidth && maxHeartWidth > 0) {
            heartSize = maxHeartWidth;
        }
        
        
        heartSize = math.max(heartSize, 10.0 * scaleFactor);
        
        return Container(
          padding: EdgeInsets.symmetric(
            vertical: verticalPadding,
            horizontal: horizontalPadding
          ),
          decoration: BoxDecoration(
            color: Colors.purple.shade900.withOpacity(0.3),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: Colors.purple.shade800.withOpacity(0.4),
              width: math.max(1.0, availableWidth / 480) * scaleFactor,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Lives: ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: heartSpacing * 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  totalHearts,
                  (i) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: heartSpacing / 2,
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