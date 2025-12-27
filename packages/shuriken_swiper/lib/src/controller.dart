import 'dart:ui';

import 'package:flutter/foundation.dart';

import 'activity.dart';
import 'direction.dart';
import 'position.dart';

/// Controller for programmatic control of [ShurikenSwiper].
///
/// Use this to trigger swipes programmatically, undo swipes,
/// and listen to swipe state changes.
class ShurikenSwiperController extends ChangeNotifier {
  SwiperPosition _position = const SwiperPosition(
    offset: Offset.zero,
    index: 0,
    cardCount: 0,
  );

  SwiperActivity? _activity;
  double _swipeProgress = 0;

  // Callbacks set by the widget
  void Function(EightDirection direction)? _onSwipe;
  void Function()? _onUnswipe;
  void Function(Offset offset, Duration duration, VoidCallback onComplete)?
      _onAnimateTo;

  /// The current position of the card.
  SwiperPosition get position => _position;

  /// The current swipe activity.
  SwiperActivity? get swipeActivity => _activity;

  /// The current card index.
  int get cardIndex => _position.index;

  /// The current swipe progress (0.0 to 1.0).
  double get swipeProgress => _swipeProgress;

  /// Updates the position. Called internally by the widget.
  void updatePosition(SwiperPosition position) {
    if (_position != position) {
      _position = position;
      notifyListeners();
    }
  }

  /// Updates the swipe progress. Called internally by the widget.
  void updateSwipeProgress(double progress) {
    if (_swipeProgress != progress) {
      _swipeProgress = progress;
      notifyListeners();
    }
  }

  /// Updates the swipe activity. Called internally by the widget.
  void updateActivity(SwiperActivity? activity) {
    if (_activity != activity) {
      _activity = activity;
      notifyListeners();
    }
  }

  /// Binds callbacks from the widget. Called internally.
  void bind({
    required void Function(EightDirection direction) onSwipe,
    required void Function() onUnswipe,
    required void Function(Offset offset, Duration duration, VoidCallback onComplete)
        onAnimateTo,
  }) {
    _onSwipe = onSwipe;
    _onUnswipe = onUnswipe;
    _onAnimateTo = onAnimateTo;
  }

  /// Unbinds callbacks. Called when widget is disposed.
  void unbind() {
    _onSwipe = null;
    _onUnswipe = null;
    _onAnimateTo = null;
  }

  // ============== Cardinal Direction Methods ==============

  /// Swipe the card up.
  Future<void> swipeUp() => swipe(EightDirection.up);

  /// Swipe the card down.
  Future<void> swipeDown() => swipe(EightDirection.down);

  /// Swipe the card left.
  Future<void> swipeLeft() => swipe(EightDirection.left);

  /// Swipe the card right.
  Future<void> swipeRight() => swipe(EightDirection.right);

  // ============== Diagonal Direction Methods ==============

  /// Swipe the card up-right.
  Future<void> swipeUpRight() => swipe(EightDirection.upRight);

  /// Swipe the card down-right.
  Future<void> swipeDownRight() => swipe(EightDirection.downRight);

  /// Swipe the card down-left.
  Future<void> swipeDownLeft() => swipe(EightDirection.downLeft);

  /// Swipe the card up-left.
  Future<void> swipeUpLeft() => swipe(EightDirection.upLeft);

  // ============== Generic Swipe Method ==============

  /// Swipe the card in the specified direction.
  Future<void> swipe(EightDirection direction) async {
    _onSwipe?.call(direction);
  }

  /// Undo the previous swipe.
  Future<void> unswipe() async {
    _onUnswipe?.call();
  }

  /// Animate the card to a specific offset.
  Future<void> animateTo(
    Offset offset, {
    Duration duration = const Duration(milliseconds: 300),
  }) async {
    final completer = Future<void>.value();
    _onAnimateTo?.call(offset, duration, () {});
    return completer;
  }

  /// Set the card index directly.
  void setCardIndex(int index) {
    if (index >= 0 && index < _position.cardCount) {
      _position = _position.copyWith(index: index, offset: Offset.zero);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    unbind();
    super.dispose();
  }
}
