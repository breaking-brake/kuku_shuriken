import 'swipe_direction.dart';

/// 的（回答選択肢）を表すエンティティ
class Target {
  /// 的に表示する数値
  final int value;

  /// 的の配置方向
  final SwipeDirection direction;

  /// この的が正解かどうか
  final bool isCorrect;

  const Target({
    required this.value,
    required this.direction,
    required this.isCorrect,
  });
}
