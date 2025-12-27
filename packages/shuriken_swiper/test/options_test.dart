import 'package:flutter_test/flutter_test.dart';
import 'package:shuriken_swiper/shuriken_swiper.dart';

void main() {
  group('EightSwipeOptions', () {
    group('constructors', () {
      test('all() allows all directions', () {
        const options = EightSwipeOptions.all();
        expect(options.up, true);
        expect(options.upRight, true);
        expect(options.right, true);
        expect(options.downRight, true);
        expect(options.down, true);
        expect(options.downLeft, true);
        expect(options.left, true);
        expect(options.upLeft, true);
        expect(options.count, 8);
        expect(options.hasAll, true);
      });

      test('none() allows no directions', () {
        const options = EightSwipeOptions.none();
        expect(options.up, false);
        expect(options.upRight, false);
        expect(options.right, false);
        expect(options.downRight, false);
        expect(options.down, false);
        expect(options.downLeft, false);
        expect(options.left, false);
        expect(options.upLeft, false);
        expect(options.count, 0);
        expect(options.hasAny, false);
      });

      test('cardinal() allows only cardinal directions', () {
        const options = EightSwipeOptions.cardinal();
        expect(options.up, true);
        expect(options.upRight, false);
        expect(options.right, true);
        expect(options.downRight, false);
        expect(options.down, true);
        expect(options.downLeft, false);
        expect(options.left, true);
        expect(options.upLeft, false);
        expect(options.count, 4);
      });

      test('diagonal() allows only diagonal directions', () {
        const options = EightSwipeOptions.diagonal();
        expect(options.up, false);
        expect(options.upRight, true);
        expect(options.right, false);
        expect(options.downRight, true);
        expect(options.down, false);
        expect(options.downLeft, true);
        expect(options.left, false);
        expect(options.upLeft, true);
        expect(options.count, 4);
      });

      test('only() with specific directions', () {
        const options = EightSwipeOptions.only(
          up: true,
          right: true,
        );
        expect(options.up, true);
        expect(options.right, true);
        expect(options.down, false);
        expect(options.left, false);
        expect(options.count, 2);
      });

      test('symmetric() with horizontal only', () {
        const options = EightSwipeOptions.symmetric(horizontal: true);
        expect(options.left, true);
        expect(options.right, true);
        expect(options.up, false);
        expect(options.down, false);
        expect(options.count, 2);
      });

      test('symmetric() with vertical only', () {
        const options = EightSwipeOptions.symmetric(vertical: true);
        expect(options.up, true);
        expect(options.down, true);
        expect(options.left, false);
        expect(options.right, false);
        expect(options.count, 2);
      });

      test('symmetric() with both and diagonals', () {
        const options = EightSwipeOptions.symmetric(
          horizontal: true,
          vertical: true,
          includeDiagonals: true,
        );
        expect(options.count, 8);
        expect(options.hasAll, true);
      });

      test('fromSet() creates options from direction set', () {
        final options = EightSwipeOptions.fromSet({
          EightDirection.up,
          EightDirection.down,
          EightDirection.upRight,
        });
        expect(options.up, true);
        expect(options.down, true);
        expect(options.upRight, true);
        expect(options.left, false);
        expect(options.count, 3);
      });
    });

    group('isAllowed', () {
      test('returns true for allowed directions', () {
        const options = EightSwipeOptions.only(up: true, right: true);
        expect(options.isAllowed(EightDirection.up), true);
        expect(options.isAllowed(EightDirection.right), true);
      });

      test('returns false for disallowed directions', () {
        const options = EightSwipeOptions.only(up: true, right: true);
        expect(options.isAllowed(EightDirection.down), false);
        expect(options.isAllowed(EightDirection.left), false);
        expect(options.isAllowed(EightDirection.upRight), false);
      });
    });

    group('allowedDirections', () {
      test('returns set of allowed directions', () {
        const options = EightSwipeOptions.only(
          up: true,
          down: true,
          upRight: true,
        );
        final allowed = options.allowedDirections;
        expect(allowed, contains(EightDirection.up));
        expect(allowed, contains(EightDirection.down));
        expect(allowed, contains(EightDirection.upRight));
        expect(allowed.length, 3);
      });
    });

    group('copyWith', () {
      test('creates copy with modified values', () {
        const original = EightSwipeOptions.cardinal();
        final modified = original.copyWith(upRight: true, downLeft: true);

        expect(modified.up, true);
        expect(modified.right, true);
        expect(modified.down, true);
        expect(modified.left, true);
        expect(modified.upRight, true);
        expect(modified.downLeft, true);
        expect(modified.count, 6);
      });

      test('preserves unmodified values', () {
        const original = EightSwipeOptions.only(up: true);
        final modified = original.copyWith(right: true);

        expect(modified.up, true);
        expect(modified.right, true);
        expect(modified.down, false);
      });
    });

    group('equality', () {
      test('equal options are equal', () {
        const a = EightSwipeOptions.cardinal();
        const b = EightSwipeOptions.cardinal();
        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('different options are not equal', () {
        const a = EightSwipeOptions.cardinal();
        const b = EightSwipeOptions.diagonal();
        expect(a, isNot(equals(b)));
      });
    });

    test('toString returns readable representation', () {
      const options = EightSwipeOptions.only(up: true, right: true);
      expect(options.toString(), contains('up'));
      expect(options.toString(), contains('right'));
    });
  });
}
