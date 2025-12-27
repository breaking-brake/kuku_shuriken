import 'package:flutter/material.dart';

import '../../domain/entities/difficulty.dart';
import 'game_screen.dart';

/// 難易度選択画面
class DifficultyScreen extends StatelessWidget {
  const DifficultyScreen({super.key});

  void _startGame(BuildContext context, Difficulty difficulty) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(difficulty: difficulty),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // タイトル
              const Text(
                '九九手裏剣',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'むずかしさをえらんでね',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 60),

              // 難易度ボタン
              _DifficultyButton(
                difficulty: Difficulty.easy,
                color: Colors.green,
                onTap: () => _startGame(context, Difficulty.easy),
              ),
              const SizedBox(height: 20),
              _DifficultyButton(
                difficulty: Difficulty.normal,
                color: Colors.orange,
                onTap: () => _startGame(context, Difficulty.normal),
              ),
              const SizedBox(height: 20),
              _DifficultyButton(
                difficulty: Difficulty.hard,
                color: Colors.red,
                onTap: () => _startGame(context, Difficulty.hard),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 難易度選択ボタン
class _DifficultyButton extends StatelessWidget {
  final Difficulty difficulty;
  final Color color;
  final VoidCallback onTap;

  const _DifficultyButton({
    required this.difficulty,
    required this.color,
    required this.onTap,
  });

  String get _directionText {
    switch (difficulty) {
      case Difficulty.easy:
        return '2ほうこう';
      case Difficulty.normal:
        return '3ほうこう';
      case Difficulty.hard:
        return '4ほうこう';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 250,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              difficulty.label,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _directionText,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
