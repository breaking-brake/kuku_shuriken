import 'package:flutter/material.dart';

import '../../domain/entities/question.dart';
import 'shuriken_clipper.dart';

/// 九九の問題を表示する手裏剣型カードWidget
class QuestionCard extends StatelessWidget {
  final Question question;
  final double size;
  final double backgroundOpacity;

  const QuestionCard({
    super.key,
    required this.question,
    this.size = 150,
    this.backgroundOpacity = 0.3, // 背景のみ半透明（文字は不透明）
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ShurikenClipper(),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.grey[300]!.withValues(alpha: backgroundOpacity),
              Colors.grey[500]!.withValues(alpha: backgroundOpacity),
              Colors.grey[400]!.withValues(alpha: backgroundOpacity),
            ],
          ),
        ),
        child: Center(
          child: Text(
            question.displayText,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
