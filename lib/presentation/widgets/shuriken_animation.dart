import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../domain/entities/swipe_direction.dart';

/// 手裏剣アニメーションを表示するWidget
class ShurikenAnimation extends StatefulWidget {
  final SwipeDirection direction;
  final bool isCorrect;
  final VoidCallback onComplete;

  const ShurikenAnimation({
    super.key,
    required this.direction,
    required this.isCorrect,
    required this.onComplete,
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

  @override
  void initState() {
    super.initState();

    // 移動アニメーション
    _moveController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // 回転アニメーション
    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    final endOffset = _getEndOffset();

    _moveAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: endOffset,
    ).animate(CurvedAnimation(
      parent: _moveController,
      curve: Curves.easeOut,
    ));

    _rotateAnimation = Tween<double>(
      begin: 0,
      end: 4 * math.pi, // 2回転
    ).animate(CurvedAnimation(
      parent: _rotateController,
      curve: Curves.linear,
    ));

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
    const distance = 150.0;
    final missOffset = widget.isCorrect ? 0.0 : 30.0;

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
          child: Transform.rotate(
            angle: _rotateAnimation.value,
            child: child,
          ),
        );
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          shape: BoxShape.circle,
        ),
        child: CustomPaint(
          painter: _ShurikenPainter(),
        ),
      ),
    );
  }
}

/// 手裏剣を描画するCustomPainter
class _ShurikenPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[700]!
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 4つの刃を描画
    for (int i = 0; i < 4; i++) {
      final angle = i * math.pi / 2;
      final path = Path();

      final tipX = center.dx + radius * 0.9 * math.cos(angle);
      final tipY = center.dy + radius * 0.9 * math.sin(angle);

      final side1X = center.dx + radius * 0.3 * math.cos(angle + 0.5);
      final side1Y = center.dy + radius * 0.3 * math.sin(angle + 0.5);

      final side2X = center.dx + radius * 0.3 * math.cos(angle - 0.5);
      final side2Y = center.dy + radius * 0.3 * math.sin(angle - 0.5);

      path.moveTo(center.dx, center.dy);
      path.lineTo(side1X, side1Y);
      path.lineTo(tipX, tipY);
      path.lineTo(side2X, side2Y);
      path.close();

      canvas.drawPath(path, paint);
    }

    // 中心の円
    final centerPaint = Paint()
      ..color = Colors.grey[600]!
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * 0.2, centerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
