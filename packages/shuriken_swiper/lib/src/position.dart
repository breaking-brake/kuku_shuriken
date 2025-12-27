import 'dart:math';
import 'dart:ui';

import 'direction.dart';

/// Represents the current position and state of a swiped card.
class SwiperPosition {
  /// The current offset from the card's original position.
  final Offset offset;

  /// The current card index.
  final int index;

  /// The total number of cards.
  final int cardCount;

  /// Whether the swiper loops.
  final bool loop;

  /// Creates a [SwiperPosition].
  const SwiperPosition({
    required this.offset,
    required this.index,
    required this.cardCount,
    this.loop = false,
  });

  /// The distance from the original position.
  double get distance => offset.distance;

  /// The angle in radians based on the offset.
  /// Uses atan2 to calculate angle from offset.
  double get angleRadians {
    if (offset.dx == 0 && offset.dy == 0) return 0;
    return atan2(offset.dx, -offset.dy);
  }

  /// The angle in degrees based on the offset.
  double get angleDegrees => angleRadians * 180 / pi;

  /// The direction based on the current offset.
  EightDirection get direction => EightDirection.fromOffset(offset.dx, offset.dy);

  /// The swipe progress as a value between 0 and 1.
  /// Based on distance relative to a reference threshold.
  double progressRelativeTo(double threshold) {
    if (threshold <= 0) return 0;
    return (distance / threshold).clamp(0.0, 1.0);
  }

  /// The card rotation angle based on horizontal offset.
  /// Returns a value suitable for Transform.rotate.
  double rotationAngle(double maxAngle) {
    // Convert maxAngle from degrees to radians
    final maxRadians = maxAngle * pi / 180;
    // Scale rotation based on horizontal offset, clamped to max
    final horizontalFactor = offset.dx / 200; // normalize to screen width
    return (horizontalFactor * maxRadians).clamp(-maxRadians, maxRadians);
  }

  /// Creates a copy with modified values.
  SwiperPosition copyWith({
    Offset? offset,
    int? index,
    int? cardCount,
    bool? loop,
  }) {
    return SwiperPosition(
      offset: offset ?? this.offset,
      index: index ?? this.index,
      cardCount: cardCount ?? this.cardCount,
      loop: loop ?? this.loop,
    );
  }

  /// Returns the next index, respecting loop setting.
  int get nextIndex {
    if (index >= cardCount - 1) {
      return loop ? 0 : index;
    }
    return index + 1;
  }

  /// Returns the previous index, respecting loop setting.
  int get previousIndex {
    if (index <= 0) {
      return loop ? cardCount - 1 : 0;
    }
    return index - 1;
  }

  /// Returns true if there are more cards after the current one.
  bool get hasNext => loop || index < cardCount - 1;

  /// Returns true if there are cards before the current one.
  bool get hasPrevious => loop || index > 0;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SwiperPosition &&
        other.offset == offset &&
        other.index == index &&
        other.cardCount == cardCount &&
        other.loop == loop;
  }

  @override
  int get hashCode => Object.hash(offset, index, cardCount, loop);

  @override
  String toString() =>
      'SwiperPosition(offset: $offset, index: $index/$cardCount, loop: $loop)';
}
