import 'dart:math';

/// 8 swipe directions for shuriken swiper.
enum EightDirection {
  /// Up direction (0° / 360°)
  up,

  /// Up-right diagonal (45°)
  upRight,

  /// Right direction (90°)
  right,

  /// Down-right diagonal (135°)
  downRight,

  /// Down direction (180°)
  down,

  /// Down-left diagonal (225°)
  downLeft,

  /// Left direction (270°)
  left,

  /// Up-left diagonal (315°)
  upLeft;

  /// Returns true if this is a cardinal direction (up, down, left, right).
  bool get isCardinal =>
      this == up || this == down || this == left || this == right;

  /// Returns true if this is a diagonal direction.
  bool get isDiagonal => !isCardinal;

  /// Returns true if this direction has a vertical component.
  bool get hasVerticalComponent =>
      this == up ||
      this == down ||
      this == upLeft ||
      this == upRight ||
      this == downLeft ||
      this == downRight;

  /// Returns true if this direction has a horizontal component.
  bool get hasHorizontalComponent =>
      this == left ||
      this == right ||
      this == upLeft ||
      this == upRight ||
      this == downLeft ||
      this == downRight;

  /// Returns the opposite direction.
  EightDirection get opposite {
    switch (this) {
      case up:
        return down;
      case upRight:
        return downLeft;
      case right:
        return left;
      case downRight:
        return upLeft;
      case down:
        return up;
      case downLeft:
        return upRight;
      case left:
        return right;
      case upLeft:
        return downRight;
    }
  }

  /// Returns the angle in degrees for this direction.
  /// Up = 0°, clockwise.
  double get angleDegrees {
    switch (this) {
      case up:
        return 0;
      case upRight:
        return 45;
      case right:
        return 90;
      case downRight:
        return 135;
      case down:
        return 180;
      case downLeft:
        return 225;
      case left:
        return 270;
      case upLeft:
        return 315;
    }
  }

  /// Returns the angle in radians for this direction.
  double get angleRadians => angleDegrees * pi / 180;

  /// Creates an EightDirection from an angle in degrees.
  /// Angle is measured clockwise from up (0°).
  static EightDirection fromDegrees(double degrees) {
    // Normalize to 0-360 range
    double normalized = degrees % 360;
    if (normalized < 0) normalized += 360;

    // Each direction covers 45° (±22.5° from center)
    if (normalized >= 337.5 || normalized < 22.5) return up;
    if (normalized >= 22.5 && normalized < 67.5) return upRight;
    if (normalized >= 67.5 && normalized < 112.5) return right;
    if (normalized >= 112.5 && normalized < 157.5) return downRight;
    if (normalized >= 157.5 && normalized < 202.5) return down;
    if (normalized >= 202.5 && normalized < 247.5) return downLeft;
    if (normalized >= 247.5 && normalized < 292.5) return left;
    return upLeft; // 292.5 - 337.5
  }

  /// Creates an EightDirection from an angle in radians.
  static EightDirection fromRadians(double radians) {
    return fromDegrees(radians * 180 / pi);
  }

  /// Creates an EightDirection from an offset.
  /// Uses atan2 to calculate angle from offset.
  static EightDirection fromOffset(double dx, double dy) {
    if (dx == 0 && dy == 0) return up;

    // atan2 returns angle from positive x-axis, counter-clockwise
    // We want angle from negative y-axis (up), clockwise
    // atan2(dx, -dy) gives us this directly
    final radians = atan2(dx, -dy);
    return fromRadians(radians);
  }

  /// Returns the unit offset for this direction.
  /// Useful for animations.
  ({double dx, double dy}) get unitOffset {
    final rad = angleRadians;
    return (dx: sin(rad), dy: -cos(rad));
  }
}
