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
    int totalHearts = difficulty == 'Easy' ? 8 : difficulty == 'Hard' ? 4 : 6;
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.purple.shade900.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Lives: ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: List.generate(
              totalHearts,
              (i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: Icon(
                    Icons.favorite,
                    color: i < lives ? Colors.red : Colors.grey.shade700,
                    size: 22,
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
}
