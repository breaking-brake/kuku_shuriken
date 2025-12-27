import 'direction.dart';

/// Configuration for allowed swipe directions.
///
/// Use factory constructors to create common configurations:
/// - [EightSwipeOptions.all] - Allow all 8 directions
/// - [EightSwipeOptions.cardinal] - Allow only cardinal directions (up, down, left, right)
/// - [EightSwipeOptions.only] - Specify individual directions
/// - [EightSwipeOptions.symmetric] - Symmetric configuration
class EightSwipeOptions {
  /// Allow swiping up.
  final bool up;

  /// Allow swiping up-right.
  final bool upRight;

  /// Allow swiping right.
  final bool right;

  /// Allow swiping down-right.
  final bool downRight;

  /// Allow swiping down.
  final bool down;

  /// Allow swiping down-left.
  final bool downLeft;

  /// Allow swiping left.
  final bool left;

  /// Allow swiping up-left.
  final bool upLeft;

  /// Creates [EightSwipeOptions] with explicit direction settings.
  const EightSwipeOptions.only({
    this.up = false,
    this.upRight = false,
    this.right = false,
    this.downRight = false,
    this.down = false,
    this.downLeft = false,
    this.left = false,
    this.upLeft = false,
  });

  /// Creates [EightSwipeOptions] allowing all 8 directions.
  const EightSwipeOptions.all()
      : up = true,
        upRight = true,
        right = true,
        downRight = true,
        down = true,
        downLeft = true,
        left = true,
        upLeft = true;

  /// Creates [EightSwipeOptions] allowing no directions.
  const EightSwipeOptions.none()
      : up = false,
        upRight = false,
        right = false,
        downRight = false,
        down = false,
        downLeft = false,
        left = false,
        upLeft = false;

  /// Creates [EightSwipeOptions] allowing only cardinal directions.
  const EightSwipeOptions.cardinal()
      : up = true,
        upRight = false,
        right = true,
        downRight = false,
        down = true,
        downLeft = false,
        left = true,
        upLeft = false;

  /// Creates [EightSwipeOptions] allowing only diagonal directions.
  const EightSwipeOptions.diagonal()
      : up = false,
        upRight = true,
        right = false,
        downRight = true,
        down = false,
        downLeft = true,
        left = false,
        upLeft = true;

  /// Creates [EightSwipeOptions] with symmetric horizontal/vertical settings.
  ///
  /// If [horizontal] is true, allows left and right.
  /// If [vertical] is true, allows up and down.
  /// If [includeDiagonals] is true, also allows diagonal directions
  /// that share components with enabled axes.
  const EightSwipeOptions.symmetric({
    bool horizontal = false,
    bool vertical = false,
    bool includeDiagonals = false,
  })  : up = vertical,
        down = vertical,
        left = horizontal,
        right = horizontal,
        upRight = includeDiagonals && horizontal && vertical,
        downRight = includeDiagonals && horizontal && vertical,
        downLeft = includeDiagonals && horizontal && vertical,
        upLeft = includeDiagonals && horizontal && vertical;

  /// Creates [EightSwipeOptions] from a set of allowed directions.
  factory EightSwipeOptions.fromSet(Set<EightDirection> directions) {
    return EightSwipeOptions.only(
      up: directions.contains(EightDirection.up),
      upRight: directions.contains(EightDirection.upRight),
      right: directions.contains(EightDirection.right),
      downRight: directions.contains(EightDirection.downRight),
      down: directions.contains(EightDirection.down),
      downLeft: directions.contains(EightDirection.downLeft),
      left: directions.contains(EightDirection.left),
      upLeft: directions.contains(EightDirection.upLeft),
    );
  }

  /// Returns true if the given [direction] is allowed.
  bool isAllowed(EightDirection direction) {
    switch (direction) {
      case EightDirection.up:
        return up;
      case EightDirection.upRight:
        return upRight;
      case EightDirection.right:
        return right;
      case EightDirection.downRight:
        return downRight;
      case EightDirection.down:
        return down;
      case EightDirection.downLeft:
        return downLeft;
      case EightDirection.left:
        return left;
      case EightDirection.upLeft:
        return upLeft;
    }
  }

  /// Returns a set of all allowed directions.
  Set<EightDirection> get allowedDirections {
    final result = <EightDirection>{};
    if (up) result.add(EightDirection.up);
    if (upRight) result.add(EightDirection.upRight);
    if (right) result.add(EightDirection.right);
    if (downRight) result.add(EightDirection.downRight);
    if (down) result.add(EightDirection.down);
    if (downLeft) result.add(EightDirection.downLeft);
    if (left) result.add(EightDirection.left);
    if (upLeft) result.add(EightDirection.upLeft);
    return result;
  }

  /// Returns the number of allowed directions.
  int get count => allowedDirections.length;

  /// Returns true if any direction is allowed.
  bool get hasAny => count > 0;

  /// Returns true if all 8 directions are allowed.
  bool get hasAll => count == 8;

  /// Creates a copy with modified values.
  EightSwipeOptions copyWith({
    bool? up,
    bool? upRight,
    bool? right,
    bool? downRight,
    bool? down,
    bool? downLeft,
    bool? left,
    bool? upLeft,
  }) {
    return EightSwipeOptions.only(
      up: up ?? this.up,
      upRight: upRight ?? this.upRight,
      right: right ?? this.right,
      downRight: downRight ?? this.downRight,
      down: down ?? this.down,
      downLeft: downLeft ?? this.downLeft,
      left: left ?? this.left,
      upLeft: upLeft ?? this.upLeft,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EightSwipeOptions &&
        other.up == up &&
        other.upRight == upRight &&
        other.right == right &&
        other.downRight == downRight &&
        other.down == down &&
        other.downLeft == downLeft &&
        other.left == left &&
        other.upLeft == upLeft;
  }

  @override
  int get hashCode => Object.hash(
        up,
        upRight,
        right,
        downRight,
        down,
        downLeft,
        left,
        upLeft,
      );

  @override
  String toString() {
    return 'EightSwipeOptions(${allowedDirections.map((d) => d.name).join(', ')})';
  }
}
