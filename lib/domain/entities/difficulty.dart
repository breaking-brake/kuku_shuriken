import 'swipe_direction.dart';

/// 難易度を表すEnum
enum Difficulty {
  /// かんたん: 2方向（上下）
  easy(
    label: 'かんたん',
    targetCount: 2,
    directions: [SwipeDirection.up, SwipeDirection.down],
  ),

  /// ふつう: 3方向（上左右）
  normal(
    label: 'ふつう',
    targetCount: 3,
    directions: [SwipeDirection.up, SwipeDirection.left, SwipeDirection.right],
  ),

  /// むずかしい: 4方向（上下左右）
  hard(label: 'むずかしい', targetCount: 4, directions: SwipeDirection.values);

  final String label;
  final int targetCount;
  final List<SwipeDirection> directions;

  const Difficulty({
    required this.label,
    required this.targetCount,
    required this.directions,
  });
}
