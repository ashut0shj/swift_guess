import 'package:flutter/material.dart';

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
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Difficulty dropdown
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.purple.shade800,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: DropdownButton<String>(
            value: difficulty,
            dropdownColor: Colors.purple.shade900,
            underline: Container(),
            style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
            icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
            items: <String>['Easy', 'Medium', 'Hard']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: gameOver ? null : (String? newValue) {
              if (newValue != null) {
                onDifficultyChanged(newValue);
              }
            },
          ),
        ),
        
        // Score display
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.purple.shade800,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '$score',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(Icons.leaderboard, color: Colors.purpleAccent, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    '$highScore',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // Hint button with counter
        ElevatedButton(
          onPressed: hintsRemaining <= 0 || gameOver ? null : onHintPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            foregroundColor: Colors.black87,
            disabledBackgroundColor: Colors.grey.shade400,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lightbulb_outline, size: 18),
              const SizedBox(width: 4),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Hint'),
                  Text(
                    hintStatus,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}