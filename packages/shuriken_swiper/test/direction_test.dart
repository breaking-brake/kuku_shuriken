import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:shuriken_swiper/shuriken_swiper.dart';

void main() {
  group('EightDirection', () {
    group('fromDegrees', () {
      test('0 degrees is up', () {
        expect(EightDirection.fromDegrees(0), EightDirection.up);
      });

      test('360 degrees is up', () {
        expect(EightDirection.fromDegrees(360), EightDirection.up);
      });

      test('45 degrees is upRight', () {
        expect(EightDirection.fromDegrees(45), EightDirection.upRight);
      });

      test('90 degrees is right', () {
        expect(EightDirection.fromDegrees(90), EightDirection.right);
      });

      test('135 degrees is downRight', () {
        expect(EightDirection.fromDegrees(135), EightDirection.downRight);
      });

      test('180 degrees is down', () {
        expect(EightDirection.fromDegrees(180), EightDirection.down);
      });

      test('225 degrees is downLeft', () {
        expect(EightDirection.fromDegrees(225), EightDirection.downLeft);
      });

      test('270 degrees is left', () {
        expect(EightDirection.fromDegrees(270), EightDirection.left);
      });

      test('315 degrees is upLeft', () {
        expect(EightDirection.fromDegrees(315), EightDirection.upLeft);
      });

      group('boundary tests', () {
        test('22.4 degrees is up', () {
          expect(EightDirection.fromDegrees(22.4), EightDirection.up);
        });

        test('22.5 degrees is upRight', () {
          expect(EightDirection.fromDegrees(22.5), EightDirection.upRight);
        });

        test('67.4 degrees is upRight', () {
          expect(EightDirection.fromDegrees(67.4), EightDirection.upRight);
        });

        test('67.5 degrees is right', () {
          expect(EightDirection.fromDegrees(67.5), EightDirection.right);
        });

        test('337.4 degrees is upLeft', () {
          expect(EightDirection.fromDegrees(337.4), EightDirection.upLeft);
        });

        test('337.5 degrees is up', () {
          expect(EightDirection.fromDegrees(337.5), EightDirection.up);
        });
      });

      test('negative angles are normalized', () {
        expect(EightDirection.fromDegrees(-45), EightDirection.upLeft);
        expect(EightDirection.fromDegrees(-90), EightDirection.left);
        expect(EightDirection.fromDegrees(-180), EightDirection.down);
      });

      test('angles > 360 are normalized', () {
        expect(EightDirection.fromDegrees(405), EightDirection.upRight);
        expect(EightDirection.fromDegrees(720), EightDirection.up);
      });
    });

    group('fromOffset', () {
      test('up offset (0, -1)', () {
        expect(EightDirection.fromOffset(0, -1), EightDirection.up);
      });

      test('down offset (0, 1)', () {
        expect(EightDirection.fromOffset(0, 1), EightDirection.down);
      });

      test('left offset (-1, 0)', () {
        expect(EightDirection.fromOffset(-1, 0), EightDirection.left);
      });

      test('right offset (1, 0)', () {
        expect(EightDirection.fromOffset(1, 0), EightDirection.right);
      });

      test('upRight offset (1, -1)', () {
        expect(EightDirection.fromOffset(1, -1), EightDirection.upRight);
      });

      test('downRight offset (1, 1)', () {
        expect(EightDirection.fromOffset(1, 1), EightDirection.downRight);
      });

      test('downLeft offset (-1, 1)', () {
        expect(EightDirection.fromOffset(-1, 1), EightDirection.downLeft);
      });

      test('upLeft offset (-1, -1)', () {
        expect(EightDirection.fromOffset(-1, -1), EightDirection.upLeft);
      });

      test('zero offset defaults to up', () {
        expect(EightDirection.fromOffset(0, 0), EightDirection.up);
      });
    });

    group('properties', () {
      test('isCardinal', () {
        expect(EightDirection.up.isCardinal, true);
        expect(EightDirection.down.isCardinal, true);
        expect(EightDirection.left.isCardinal, true);
        expect(EightDirection.right.isCardinal, true);
        expect(EightDirection.upRight.isCardinal, false);
        expect(EightDirection.downRight.isCardinal, false);
        expect(EightDirection.downLeft.isCardinal, false);
        expect(EightDirection.upLeft.isCardinal, false);
      });

      test('isDiagonal', () {
        expect(EightDirection.up.isDiagonal, false);
        expect(EightDirection.upRight.isDiagonal, true);
        expect(EightDirection.downLeft.isDiagonal, true);
      });

      test('opposite', () {
        expect(EightDirection.up.opposite, EightDirection.down);
        expect(EightDirection.upRight.opposite, EightDirection.downLeft);
        expect(EightDirection.right.opposite, EightDirection.left);
        expect(EightDirection.downRight.opposite, EightDirection.upLeft);
        expect(EightDirection.down.opposite, EightDirection.up);
        expect(EightDirection.downLeft.opposite, EightDirection.upRight);
        expect(EightDirection.left.opposite, EightDirection.right);
        expect(EightDirection.upLeft.opposite, EightDirection.downRight);
      });

      test('angleDegrees', () {
        expect(EightDirection.up.angleDegrees, 0);
        expect(EightDirection.upRight.angleDegrees, 45);
        expect(EightDirection.right.angleDegrees, 90);
        expect(EightDirection.downRight.angleDegrees, 135);
        expect(EightDirection.down.angleDegrees, 180);
        expect(EightDirection.downLeft.angleDegrees, 225);
        expect(EightDirection.left.angleDegrees, 270);
        expect(EightDirection.upLeft.angleDegrees, 315);
      });

      test('angleRadians', () {
        expect(EightDirection.up.angleRadians, 0);
        expect(EightDirection.right.angleRadians, closeTo(pi / 2, 0.001));
        expect(EightDirection.down.angleRadians, closeTo(pi, 0.001));
        expect(EightDirection.left.angleRadians, closeTo(3 * pi / 2, 0.001));
      });
    });

    group('unitOffset', () {
      test('up unit offset', () {
        final unit = EightDirection.up.unitOffset;
        expect(unit.dx, closeTo(0, 0.001));
        expect(unit.dy, closeTo(-1, 0.001));
      });

      test('right unit offset', () {
        final unit = EightDirection.right.unitOffset;
        expect(unit.dx, closeTo(1, 0.001));
        expect(unit.dy, closeTo(0, 0.001));
      });

      test('down unit offset', () {
        final unit = EightDirection.down.unitOffset;
        expect(unit.dx, closeTo(0, 0.001));
        expect(unit.dy, closeTo(1, 0.001));
      });

      test('left unit offset', () {
        final unit = EightDirection.left.unitOffset;
        expect(unit.dx, closeTo(-1, 0.001));
        expect(unit.dy, closeTo(0, 0.001));
      });

      test('diagonal unit offsets have magnitude ~0.707', () {
        for (final dir in [
          EightDirection.upRight,
          EightDirection.downRight,
          EightDirection.downLeft,
          EightDirection.upLeft,
        ]) {
          final unit = dir.unitOffset;
          final magnitude = sqrt(unit.dx * unit.dx + unit.dy * unit.dy);
          expect(magnitude, closeTo(1, 0.001));
        }
      });
    });
  });
}
