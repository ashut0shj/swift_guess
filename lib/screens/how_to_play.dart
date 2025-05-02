import 'package:flutter/material.dart';

class HowToPlayScreen extends StatelessWidget {
  const HowToPlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF18122B),
      appBar: AppBar(
        backgroundColor: Colors.purple.shade800,
        title: const Text(
          'How To Play',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF18122B),
              Colors.purple.shade900,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderSection(context),
                  const SizedBox(height: 24),
                  _buildGameplaySection(),
                  const SizedBox(height: 24),
                  _buildDifficultySection(),
                  const SizedBox(height: 24),
                  _buildScoringSection(),
                  const SizedBox(height: 24),
                  _buildTipsSection(),
                  const SizedBox(height: 16),
                  _buildStartPlayingButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Column(
      children: [
        
        const SizedBox(height: 16),
        Text(
          'Swift Guess',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.pink.shade300,
          ),
        ),
        const SizedBox(height: 8),
        
      ],
    );
  }

  Widget _buildGameplaySection() {
    return _buildSection(
      'How To Play',
      [
        _buildInstructionRow(
          '1',
          'Guess Taylor Swift song titles letter by letter',
          Icons.music_note,
        ),
        _buildInstructionRow(
          '2',
          'Each wrong guess costs you a heart',
          Icons.favorite,
        ),
        _buildInstructionRow(
          '3',
          'Use hints to reveal random letters when stuck',
          Icons.lightbulb_outline,
        ),
        _buildInstructionRow(
          '4',
          'Complete the song title before running out of hearts',
          Icons.check_circle_outline,
        ),
      ],
    );
  }

  Widget _buildDifficultySection() {
    return _buildSection(
      'Difficulty Levels',
      [
        _buildDifficultyRow(
          'Easy',
          '8 hearts & 4 hints',
          'Perfect for casual fans',
          Colors.green,
        ),
        _buildDifficultyRow(
          'Medium',
          '6 hearts & 3 hints',
          'For the regular Swifties',
          Colors.orange,
        ),
        _buildDifficultyRow(
          'Hard',
          '4 hearts & 2 hints',
          'For the die-hard fans',
          Colors.red,
        ),
      ],
    );
  }

  Widget _buildScoringSection() {
    return _buildSection(
      'Scoring System',
      [
        _buildInfoRow(
          'Base Score',
          'You earn points for each completed song',
          Icons.stars,
        ),
        _buildInfoRow(
          'Heart Bonus',
          'More remaining hearts = higher score',
          Icons.favorite,
        ),
        _buildInfoRow(
          'Hint Penalty',
          'Using hints reduces your potential score',
          Icons.remove_circle_outline,
        ),
        _buildInfoRow(
          'High Score',
          'Try to beat your personal best!',
          Icons.emoji_events,
        ),
      ],
    );
  }

  Widget _buildTipsSection() {
    return _buildSection(
      'Pro Tips',
      [
        _buildInfoRow(
          'Start with vowels',
          'A, E, I, O, U are often good first guesses',
          Icons.lightbulb,
        ),
        _buildInfoRow(
          'Common letters',
          'Try T, S, R, N for Taylor Swift songs',
          Icons.psychology,
        ),
        _buildInfoRow(
          'Save your hints',
          'Use hints strategically when truly stuck',
          Icons.savings,
        ),
      ],
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.purple.shade900.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purple.shade300, width: 1),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInstructionRow(String number, String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.pink.shade400,
              shape: BoxShape.circle,
            ),
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Icon(
            icon,
            color: Colors.pink.shade200,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyRow(
      String level, String specs, String description, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.4),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.gamepad,
              color: color,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  level,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  specs,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String description, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.purple.shade800.withOpacity(0.6),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.pink.shade200,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.pink.shade200,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartPlayingButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => Navigator.of(context).pop(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink.shade400,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.play_arrow),
            SizedBox(width: 8),
            Text(
              'Start Playing',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}