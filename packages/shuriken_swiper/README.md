# shuriken_swiper

A 360-degree swiper widget supporting up to 8 directions. Fork of [appinio_swiper](https://pub.dev/packages/appinio_swiper).

## Features

- Support for 8 swipe directions (up, upRight, right, downRight, down, downLeft, left, upLeft)
- Backward compatible with 4-direction swiping
- Customizable swipe options per direction
- Smooth animations and gesture handling

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  shuriken_swiper:
    path: packages/shuriken_swiper
```

## Usage

```dart
import 'package:shuriken_swiper/shuriken_swiper.dart';

ShurikenSwiper(
  controller: _controller,
  cardCount: items.length,
  swipeOptions: EightSwipeOptions.only(
    up: true,
    down: true,
    left: true,
    right: true,
  ),
  onSwipeEnd: (previousIndex, targetIndex, activity) {
    if (activity is Swipe) {
      print('Swiped ${activity.direction}');
    }
  },
  cardBuilder: (context, index) {
    return YourCard(item: items[index]);
  },
)
```

## Direction Mapping

| Direction | Angle Range |
|-----------|-------------|
| up | 337.5° - 22.5° |
| upRight | 22.5° - 67.5° |
| right | 67.5° - 112.5° |
| downRight | 112.5° - 157.5° |
| down | 157.5° - 202.5° |
| downLeft | 202.5° - 247.5° |
| left | 247.5° - 292.5° |
| upLeft | 292.5° - 337.5° |

## License

MIT License - see [LICENSE](LICENSE) for details.

Based on appinio_swiper, Copyright (c) 2021 APPINIO GmbH.
