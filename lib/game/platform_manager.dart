import 'dart:math';

import 'package:flame/components.dart';

import 'doodle_dash.dart';
import 'sprites/platform.dart';

class PlatformManager extends Component with HasGameRef<DoodleDash> {
  final Random random = Random();
  late final List<Platform> platforms;

  // This will be passed in as player jump speed minus (some number TBD)
  final double maxVerticalDistanceToNextPlatform;

  // Eventually, this can be used to make adjust game difficulty
  final double minVerticalDistanceToNextPlatform = 200;

  PlatformManager({required this.maxVerticalDistanceToNextPlatform}) : super();

  @override
  void onMount() {
    // The first platform will always be in the bottom third of the initial screen
    var currentY =
        gameRef.size.y - (random.nextInt(gameRef.size.y.floor()) / 3);

    platforms = List.generate(10, (idx) {
      if (idx != 0) {
        currentY = _generateInitialYPositions(currentY);
      }
      return Platform(
          position: Vector2(
        random.nextInt(gameRef.size.x.floor()).toDouble(),
        currentY,
      ));
    }, growable: false);

    for (var platform in platforms) {
      add(platform);
    }

    super.onMount();
  }

  double _generateInitialYPositions(double prevY) {
    var distanceFromPrevY = minVerticalDistanceToNextPlatform.toInt() +
        random
            .nextInt((maxVerticalDistanceToNextPlatform -
                    minVerticalDistanceToNextPlatform)
                .floor())
            .toDouble();

    // subtract because moving vertically is going down
    return prevY - distanceFromPrevY;
  }

  @override
  void update(double dt) {
    final topOfPlatform = platforms.first.position.y;
    final screenBottom = gameRef.dash.position.y + (gameRef.size.x / 2);

    if (topOfPlatform > screenBottom) {
      print('OFFSCREEN');
    } else {
      print('ONSCREEN');
    }
    super.update(dt);
  }
}
