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
        
        
        final double baseFontSize = isSmallScreen ? 14.0 : 16.0;
        final double baseHeartSize = isSmallScreen ? 14.0 : 16.0;
        
        
        final double fontSize = baseFontSize * scaleFactor;
        double heartSize = baseHeartSize * scaleFactor;
        
        
        final double verticalPadding = 6.0 * scaleFactor;
        final double horizontalPadding = 12.0 * scaleFactor;
        final double heartSpacing = 3.0 * scaleFactor;
        final double borderRadius = 16.0 * scaleFactor;
        
        
        int totalHearts = difficulty == 'Easy' ? 8 : difficulty == 'Hard' ? 4 : 6;
        
        
        if (totalHearts > 6) {
          
          double availableWidth = constraints.maxWidth - (horizontalPadding * 2) - (fontSize * 4); 
          double maxHeartWidth = availableWidth / totalHearts;
          
          
          if (heartSize > maxHeartWidth) {
            double adjustmentRatio = maxHeartWidth / heartSize;
            heartSize *= math.min(adjustmentRatio, 1.0);
          }
        }
        
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
              width: 1.0 * scaleFactor,
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
              SizedBox(width: 4.0 * scaleFactor),
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


