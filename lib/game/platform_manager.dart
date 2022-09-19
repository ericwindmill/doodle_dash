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
    });

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

  double _generateNextY() {
    final currentHighestPlatformY = platforms.last.center.y;
    final distanceToNextY = minVerticalDistanceToNextPlatform.toInt() +
        random
            .nextInt((maxVerticalDistanceToNextPlatform -
                    minVerticalDistanceToNextPlatform)
                .floor())
            .toDouble();

    return currentHighestPlatformY - distanceToNextY;
  }

  @override
  void update(double dt) {
    final topOfLowestPlatform =
        platforms.first.position.y; // 100 is a slight buffer
    final screenBottom = gameRef.dash.position.y + (gameRef.size.x / 2) + 100;

    // When the lowest platform is offscreen, it can be
    if (topOfLowestPlatform > screenBottom) {
      var newPlatY = _generateNextY();
      var newPlatX = random.nextInt(gameRef.size.x.floor()).toDouble();
      final newPlat = Platform(position: Vector2(newPlatX, newPlatY));
      add(newPlat);

      // after renderin, add to platforms queue for management
      platforms.add(newPlat);
      final lowestPlat = platforms.removeAt(0);

      // remove component from game
      lowestPlat.removeFromParent();
    }
    super.update(dt);
  }
}
