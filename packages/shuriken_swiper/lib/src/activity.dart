import 'direction.dart';

/// Represents a swiper activity that occurred.
sealed class SwiperActivity {
  const SwiperActivity();
}

/// A swipe was completed in a specific direction.
class Swipe extends SwiperActivity {
  /// The direction of the swipe.
  final EightDirection direction;

  const Swipe(this.direction);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Swipe && other.direction == direction;
  }

  @override
  int get hashCode => direction.hashCode;

  @override
  String toString() => 'Swipe($direction)';
}

/// A previous swipe was undone.
class Unswipe extends SwiperActivity {
  const Unswipe();

  @override
  bool operator ==(Object other) => other is Unswipe;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'Unswipe()';
}

/// A swipe was cancelled (did not meet threshold).
class CancelSwipe extends SwiperActivity {
  const CancelSwipe();

  @override
  bool operator ==(Object other) => other is CancelSwipe;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'CancelSwipe()';
}
