import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../domain/entities/question.dart';
import '../../domain/entities/swipe_direction.dart';
import 'shuriken_clipper.dart';

/// 手裏剣アニメーションを表示するWidget
/// QuestionCardと同じデザインで、回転しながら飛んでいく
class ShurikenAnimation extends StatefulWidget {
  final SwipeDirection direction;
  final bool isCorrect;
  final VoidCallback onComplete;
  final Question question;

  const ShurikenAnimation({
    super.key,
    required this.direction,
    required this.isCorrect,
    required this.onComplete,
    required this.question,
  });

  @override
  State<ShurikenAnimation> createState() => _ShurikenAnimationState();
}

class _ShurikenAnimationState extends State<ShurikenAnimation>
    with TickerProviderStateMixin {
  late AnimationController _moveController;
  late AnimationController _rotateController;
  late Animation<Offset> _moveAnimation;
  late Animation<double> _rotateAnimation;

  /// 方向に応じたアニメーション時間を取得
  /// 画面外に消えるまでの見た目の速さを揃えるため、左右は遅くする
  Duration _getAnimationDuration() {
    switch (widget.direction) {
      case SwipeDirection.up:
      case SwipeDirection.down:
        return const Duration(milliseconds: 600);
      case SwipeDirection.left:
      case SwipeDirection.right:
        return const Duration(milliseconds: 900); // 左右は遅め
    }
  }

  @override
  void initState() {
    super.initState();

    final duration = _getAnimationDuration();

    // 移動アニメーション
    _moveController = AnimationController(duration: duration, vsync: this);

    // 回転アニメーション
    _rotateController = AnimationController(duration: duration, vsync: this);

    final endOffset = _getEndOffset();

    _moveAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: endOffset,
    ).animate(CurvedAnimation(parent: _moveController, curve: Curves.easeOut));

    _rotateAnimation = Tween<double>(
      begin: 0,
      end: 3 * math.pi, // 1.5回転
    ).animate(CurvedAnimation(parent: _rotateController, curve: Curves.linear));

    _moveController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete();
      }
    });

    // アニメーション開始
    _moveController.forward();
    _rotateController.forward();
  }

  Offset _getEndOffset() {
    const distance = 500.0; // 画面外まで飛んでいく
    final missOffset = widget.isCorrect ? 0.0 : 60.0;

    switch (widget.direction) {
      case SwipeDirection.up:
        return Offset(widget.isCorrect ? 0 : missOffset, -distance);
      case SwipeDirection.down:
        return Offset(widget.isCorrect ? 0 : -missOffset, distance);
      case SwipeDirection.left:
        return Offset(-distance, widget.isCorrect ? 0 : missOffset);
      case SwipeDirection.right:
        return Offset(distance, widget.isCorrect ? 0 : -missOffset);
    }
  }

  @override
  void dispose() {
    _moveController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_moveAnimation, _rotateAnimation]),
      builder: (context, child) {
        return Transform.translate(
          offset: _moveAnimation.value,
          child: Transform.rotate(angle: _rotateAnimation.value, child: child),
        );
      },
      // QuestionCardと同じデザイン
      child: ClipPath(
        clipper: ShurikenClipper(),
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.grey[300]!, Colors.grey[500]!, Colors.grey[400]!],
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
    );
  }
}
