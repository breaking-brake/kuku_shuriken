import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../domain/entities/question.dart';
import 'shuriken_clipper.dart';

/// 九九の問題を表示する手裏剣型カードWidget
/// タップ中は回転アニメーションを表示
class QuestionCard extends StatefulWidget {
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
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi, // 1回転
    ).animate(_rotationController);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  void _startRotation() {
    _rotationController.repeat();
  }

  void _stopRotation() {
    _rotationController.stop();
    _rotationController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _startRotation(),
      onPointerUp: (_) => _stopRotation(),
      onPointerCancel: (_) => _stopRotation(),
      child: AnimatedBuilder(
        animation: _rotationAnimation,
        builder: (context, child) {
          return Transform.rotate(
            angle: _rotationAnimation.value,
            child: child,
          );
        },
        child: ClipPath(
          clipper: ShurikenClipper(),
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.grey[300]!.withValues(alpha: widget.backgroundOpacity),
                  Colors.grey[500]!.withValues(alpha: widget.backgroundOpacity),
                  Colors.grey[400]!.withValues(alpha: widget.backgroundOpacity),
                ],
              ),
            ),
            child: Center(
              child: Text(
                widget.question.displayText,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
