import 'package:flutter/material.dart';

import '../../domain/entities/swipe_direction.dart';
import '../../domain/entities/target.dart';

/// 的（回答選択肢）を表示するWidget
class TargetWidget extends StatelessWidget {
  final Target target;
  final bool showHit;

  const TargetWidget({
    super.key,
    required this.target,
    this.showHit = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: showHit
            ? (target.isCorrect ? Colors.green : Colors.red)
            : Colors.orange,
        border: Border.all(
          color: Colors.brown,
          width: 4,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          '${target.value}',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  /// 的の配置位置を取得
  static Alignment getAlignment(SwipeDirection direction) {
    switch (direction) {
      case SwipeDirection.up:
        return Alignment.topCenter;
      case SwipeDirection.down:
        return Alignment.bottomCenter;
      case SwipeDirection.left:
        return Alignment.centerLeft;
      case SwipeDirection.right:
        return Alignment.centerRight;
    }
  }

  /// 的の配置オフセットを取得
  static EdgeInsets getPadding(SwipeDirection direction) {
    switch (direction) {
      case SwipeDirection.up:
        return const EdgeInsets.only(top: 40);
      case SwipeDirection.down:
        return const EdgeInsets.only(bottom: 40);
      case SwipeDirection.left:
        return const EdgeInsets.only(left: 20);
      case SwipeDirection.right:
        return const EdgeInsets.only(right: 20);
    }
  }
}
