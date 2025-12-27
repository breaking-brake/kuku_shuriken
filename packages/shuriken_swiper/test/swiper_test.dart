import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shuriken_swiper/shuriken_swiper.dart';

void main() {
  group('ShurikenSwiper', () {
    testWidgets('renders card from cardBuilder', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShurikenSwiper(
              cardCount: 3,
              cardBuilder: (context, index) {
                return Container(
                  key: Key('card_$index'),
                  width: 200,
                  height: 300,
                  color: Colors.blue,
                  child: Center(child: Text('Card $index')),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Card 0'), findsOneWidget);
      expect(find.byKey(const Key('card_0')), findsOneWidget);
    });

    testWidgets('renders nothing when cardCount is 0', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShurikenSwiper(
              cardCount: 0,
              cardBuilder: (context, index) {
                return Container(
                  key: Key('card_$index'),
                );
              },
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('card_0')), findsNothing);
    });

    testWidgets('controller can trigger swipe', (tester) async {
      final controller = ShurikenSwiperController();
      int? lastPreviousIndex;
      int? lastTargetIndex;
      SwiperActivity? lastActivity;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShurikenSwiper(
              controller: controller,
              cardCount: 3,
              swipeOptions: const EightSwipeOptions.all(),
              onSwipeEnd: (previousIndex, targetIndex, activity) {
                lastPreviousIndex = previousIndex;
                lastTargetIndex = targetIndex;
                lastActivity = activity;
              },
              cardBuilder: (context, index) {
                return Container(
                  key: Key('card_$index'),
                  width: 200,
                  height: 300,
                  child: Text('Card $index'),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Card 0'), findsOneWidget);

      controller.swipeRight();
      await tester.pumpAndSettle();

      expect(lastPreviousIndex, 0);
      expect(lastTargetIndex, 1);
      expect(lastActivity, isA<Swipe>());
      expect((lastActivity as Swipe).direction, EightDirection.right);
    });

    testWidgets('respects swipeOptions', (tester) async {
      final controller = ShurikenSwiperController();
      SwiperActivity? lastActivity;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShurikenSwiper(
              controller: controller,
              cardCount: 3,
              swipeOptions: const EightSwipeOptions.only(
                left: true,
                right: true,
              ),
              onSwipeEnd: (_, __, activity) {
                lastActivity = activity;
              },
              cardBuilder: (context, index) {
                return Container(
                  width: 200,
                  height: 300,
                  child: Text('Card $index'),
                );
              },
            ),
          ),
        ),
      );

      // Up should not work
      controller.swipeUp();
      await tester.pumpAndSettle();
      expect(lastActivity, isNull);

      // Right should work
      controller.swipeRight();
      await tester.pumpAndSettle();
      expect(lastActivity, isA<Swipe>());
    });

    testWidgets('diagonal swipe works', (tester) async {
      final controller = ShurikenSwiperController();
      SwiperActivity? lastActivity;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShurikenSwiper(
              controller: controller,
              cardCount: 3,
              swipeOptions: const EightSwipeOptions.all(),
              onSwipeEnd: (_, __, activity) {
                lastActivity = activity;
              },
              cardBuilder: (context, index) {
                return Container(
                  width: 200,
                  height: 300,
                  child: Text('Card $index'),
                );
              },
            ),
          ),
        ),
      );

      controller.swipeUpRight();
      await tester.pumpAndSettle();

      expect(lastActivity, isA<Swipe>());
      expect((lastActivity as Swipe).direction, EightDirection.upRight);
    });

    testWidgets('calls onEnd when all cards swiped', (tester) async {
      final controller = ShurikenSwiperController();
      bool onEndCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShurikenSwiper(
              controller: controller,
              cardCount: 1,
              swipeOptions: const EightSwipeOptions.all(),
              onEnd: () {
                onEndCalled = true;
              },
              cardBuilder: (context, index) {
                return Container(
                  width: 200,
                  height: 300,
                  child: Text('Card $index'),
                );
              },
            ),
          ),
        ),
      );

      controller.swipeRight();
      await tester.pumpAndSettle();

      expect(onEndCalled, true);
    });
  });

  group('SwiperActivity', () {
    test('Swipe equality', () {
      const a = Swipe(EightDirection.up);
      const b = Swipe(EightDirection.up);
      const c = Swipe(EightDirection.down);

      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('Unswipe equality', () {
      const a = Unswipe();
      const b = Unswipe();

      expect(a, equals(b));
    });

    test('CancelSwipe equality', () {
      const a = CancelSwipe();
      const b = CancelSwipe();

      expect(a, equals(b));
    });
  });
}
