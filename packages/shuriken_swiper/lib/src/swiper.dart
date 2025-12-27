import 'dart:math';

import 'package:flutter/material.dart';

import 'activity.dart';
import 'controller.dart';
import 'direction.dart';
import 'options.dart';
import 'position.dart';

/// Callback type for swipe events.
typedef OnSwipe = void Function(
  int previousIndex,
  int targetIndex,
  SwiperActivity activity,
);

/// A swipeable card widget supporting 8 directions.
///
/// Based on appinio_swiper with extended direction support.
class ShurikenSwiper extends StatefulWidget {
  /// Builder for creating card widgets.
  final Widget Function(BuildContext context, int index) cardBuilder;

  /// Total number of cards.
  final int cardCount;

  /// Controller for programmatic swipe control.
  final ShurikenSwiperController? controller;

  /// Allowed swipe directions.
  final EightSwipeOptions swipeOptions;

  /// Minimum distance to trigger a swipe.
  final double threshold;

  /// Maximum rotation angle in degrees during swipe.
  final double maxAngle;

  /// Duration of swipe animation.
  final Duration duration;

  /// Whether to allow unswipe (undo).
  final bool allowUnswipe;

  /// Whether to allow unlimited unswipes.
  final bool allowUnlimitedUnswipe;

  /// Whether to loop back to the first card after the last.
  final bool loop;

  /// Default swipe direction for [controller.swipeDefault()].
  final EightDirection defaultDirection;

  /// Callback when a swipe is completed.
  final OnSwipe? onSwipeEnd;

  /// Callback when swiping is in progress.
  final void Function(int index, SwiperPosition position)? onSwiping;

  /// Callback when all cards have been swiped.
  final VoidCallback? onEnd;

  /// Creates a [ShurikenSwiper].
  const ShurikenSwiper({
    super.key,
    required this.cardBuilder,
    required this.cardCount,
    this.controller,
    this.swipeOptions = const EightSwipeOptions.cardinal(),
    this.threshold = 50,
    this.maxAngle = 15,
    this.duration = const Duration(milliseconds: 300),
    this.allowUnswipe = false,
    this.allowUnlimitedUnswipe = false,
    this.loop = false,
    this.defaultDirection = EightDirection.right,
    this.onSwipeEnd,
    this.onSwiping,
    this.onEnd,
  });

  @override
  State<ShurikenSwiper> createState() => _ShurikenSwiperState();
}

class _ShurikenSwiperState extends State<ShurikenSwiper>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  Offset _offset = Offset.zero;
  int _currentIndex = 0;
  final List<int> _swipeHistory = [];
  bool _isAnimating = false;

  ShurikenSwiperController? _internalController;

  ShurikenSwiperController get _controller =>
      widget.controller ?? (_internalController ??= ShurikenSwiperController());

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _bindController();
    _updateControllerPosition();
  }

  @override
  void didUpdateWidget(covariant ShurikenSwiper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.unbind();
      _bindController();
    }
    if (widget.duration != oldWidget.duration) {
      _animationController.duration = widget.duration;
    }
  }

  void _bindController() {
    _controller.bind(
      onSwipe: _triggerSwipe,
      onUnswipe: _triggerUnswipe,
      onAnimateTo: _animateTo,
    );
  }

  void _updateControllerPosition() {
    _controller.updatePosition(SwiperPosition(
      offset: _offset,
      index: _currentIndex,
      cardCount: widget.cardCount,
      loop: widget.loop,
    ));
  }

  @override
  void dispose() {
    _controller.unbind();
    _internalController?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // ============== Gesture Handlers ==============

  void _onPanStart(DragStartDetails details) {
    if (_isAnimating) return;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_isAnimating) return;

    final delta = details.delta;
    final newOffset = _offset + delta;

    // Determine direction from current offset
    final direction = EightDirection.fromOffset(newOffset.dx, newOffset.dy);

    // Check if this direction is allowed
    if (!widget.swipeOptions.isAllowed(direction)) {
      // If current direction not allowed, constrain movement
      // Allow movement only in allowed directions
      final allowedOffset = _constrainToAllowedDirections(newOffset);
      setState(() {
        _offset = allowedOffset;
      });
    } else {
      setState(() {
        _offset = newOffset;
      });
    }

    _updateControllerPosition();
    _controller.updateSwipeProgress(_offset.distance / widget.threshold);

    widget.onSwiping?.call(_currentIndex, _controller.position);
  }

  Offset _constrainToAllowedDirections(Offset offset) {
    // If no direction is allowed, return zero
    if (!widget.swipeOptions.hasAny) return Offset.zero;

    double dx = offset.dx;
    double dy = offset.dy;

    // Check horizontal movement
    final canMoveRight = widget.swipeOptions.right ||
        widget.swipeOptions.upRight ||
        widget.swipeOptions.downRight;
    final canMoveLeft = widget.swipeOptions.left ||
        widget.swipeOptions.upLeft ||
        widget.swipeOptions.downLeft;

    if (dx > 0 && !canMoveRight) dx = 0;
    if (dx < 0 && !canMoveLeft) dx = 0;

    // Check vertical movement
    final canMoveUp = widget.swipeOptions.up ||
        widget.swipeOptions.upLeft ||
        widget.swipeOptions.upRight;
    final canMoveDown = widget.swipeOptions.down ||
        widget.swipeOptions.downLeft ||
        widget.swipeOptions.downRight;

    if (dy < 0 && !canMoveUp) dy = 0;
    if (dy > 0 && !canMoveDown) dy = 0;

    return Offset(dx, dy);
  }

  void _onPanEnd(DragEndDetails details) {
    if (_isAnimating) return;

    final distance = _offset.distance;
    final direction = EightDirection.fromOffset(_offset.dx, _offset.dy);

    if (distance >= widget.threshold && widget.swipeOptions.isAllowed(direction)) {
      // Swipe succeeded
      _animateSwipe(direction);
    } else {
      // Swipe cancelled - animate back to center
      _animateBack();
    }
  }

  // ============== Animation Methods ==============

  void _animateSwipe(EightDirection direction) {
    _isAnimating = true;

    // Calculate end position (move card off screen)
    final unit = direction.unitOffset;
    final screenSize = MediaQuery.of(context).size;
    final distance = max(screenSize.width, screenSize.height) * 1.5;
    final endOffset = Offset(unit.dx * distance, unit.dy * distance);

    _animation = Tween<Offset>(
      begin: _offset,
      end: endOffset,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward(from: 0).then((_) {
      _completeSwipe(direction);
    });
  }

  void _completeSwipe(EightDirection direction) {
    final previousIndex = _currentIndex;

    if (widget.allowUnswipe || widget.allowUnlimitedUnswipe) {
      _swipeHistory.add(_currentIndex);
      if (!widget.allowUnlimitedUnswipe && _swipeHistory.length > 1) {
        _swipeHistory.removeAt(0);
      }
    }

    setState(() {
      _offset = Offset.zero;
      _isAnimating = false;

      if (widget.loop) {
        _currentIndex = (_currentIndex + 1) % widget.cardCount;
      } else {
        _currentIndex = min(_currentIndex + 1, widget.cardCount);
      }
    });

    _updateControllerPosition();
    _controller.updateActivity(Swipe(direction));
    _controller.updateSwipeProgress(0);

    widget.onSwipeEnd?.call(previousIndex, _currentIndex, Swipe(direction));

    if (!widget.loop && _currentIndex >= widget.cardCount) {
      widget.onEnd?.call();
    }
  }

  void _animateBack() {
    _isAnimating = true;

    _animation = Tween<Offset>(
      begin: _offset,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward(from: 0).then((_) {
      setState(() {
        _offset = Offset.zero;
        _isAnimating = false;
      });
      _updateControllerPosition();
      _controller.updateActivity(const CancelSwipe());
      _controller.updateSwipeProgress(0);
    });
  }

  void _animateTo(Offset offset, Duration duration, VoidCallback onComplete) {
    _isAnimating = true;

    _animation = Tween<Offset>(
      begin: _offset,
      end: offset,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.duration = duration;
    _animationController.forward(from: 0).then((_) {
      setState(() {
        _offset = offset;
        _isAnimating = false;
      });
      _animationController.duration = widget.duration;
      _updateControllerPosition();
      onComplete();
    });
  }

  // ============== Controller Trigger Methods ==============

  void _triggerSwipe(EightDirection direction) {
    if (_isAnimating || _currentIndex >= widget.cardCount) return;
    if (!widget.swipeOptions.isAllowed(direction)) return;

    // Set initial offset in the swipe direction
    final unit = direction.unitOffset;
    _offset = Offset(unit.dx * widget.threshold, unit.dy * widget.threshold);
    _animateSwipe(direction);
  }

  void _triggerUnswipe() {
    if (_isAnimating || _swipeHistory.isEmpty) return;

    final previousIndex = _swipeHistory.removeLast();
    _isAnimating = true;

    // Animate card back from off-screen
    final screenSize = MediaQuery.of(context).size;
    final startOffset = Offset(0, -screenSize.height);

    _animation = Tween<Offset>(
      begin: startOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    setState(() {
      _currentIndex = previousIndex;
    });

    _animationController.forward(from: 0).then((_) {
      setState(() {
        _offset = Offset.zero;
        _isAnimating = false;
      });
      _updateControllerPosition();
      _controller.updateActivity(const Unswipe());

      widget.onSwipeEnd?.call(_currentIndex, previousIndex, const Unswipe());
    });
  }

  // ============== Build ==============

  @override
  Widget build(BuildContext context) {
    if (widget.cardCount == 0 || (!widget.loop && _currentIndex >= widget.cardCount)) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          final currentOffset = _isAnimating ? _animation.value : _offset;
          final rotation = _calculateRotation(currentOffset);

          return Transform.translate(
            offset: currentOffset,
            child: Transform.rotate(
              angle: rotation,
              child: widget.cardBuilder(context, _currentIndex),
            ),
          );
        },
      ),
    );
  }

  double _calculateRotation(Offset offset) {
    final maxRadians = widget.maxAngle * pi / 180;
    final factor = (offset.dx / 200).clamp(-1.0, 1.0);
    return factor * maxRadians;
  }
}
