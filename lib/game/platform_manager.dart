import 'dart:math';

import 'package:flame/components.dart';

import 'doodle_dash.dart';
import 'sprites/platform.dart';

class PlatformManager extends Component with HasGameRef<DoodleDash> {
  final Random random = Random();
  late final List<Platform> platforms;
  // TODO (sprint 2): This will be dependent on player jump speed and screen width
  final double maxVerticalDistanceToNextPlatform;

  // TODO (sprint 2): Adjust this value to change game difficulty
  final double minVerticalDistanceToNextPlatform = 200;

  PlatformManager({required this.maxVerticalDistanceToNextPlatform}) : super();

  @override
  void onMount() {
    // The first platform will always be in the bottom third of the initial screen
    var currentY =
        gameRef.size.y - (random.nextInt(gameRef.size.y.floor()) / 3);

    // Generate 10 Platforms at random x, y positions and add to list of platforms
    // to be populated in the game.
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

  // TODO (sprint 1): Refactor to combine generateY methods into 1.
  // Generate a random Y position that is a good distance from
  // the previous platform
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

  // TODO: Add documentation for this function
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
    final topOfLowestPlatform = platforms.first.position.y;

    final screenBottom = gameRef.dash.position.y +
        (gameRef.size.x / 2) +
        gameRef.screenBufferSpace;

    // When the lowest platform is offscreen, it can be removed and a new platform
    // should be added
    if (topOfLowestPlatform > screenBottom) {
      var newPlatY = _generateNextY();

      // TODO (sprint 2): Update to take into account the width of the platform
      // this way, the platform is not generated and cut off at the side?
      var newPlatX = random.nextInt(gameRef.size.x.floor() - 60).toDouble();
      final newPlat = Platform(position: Vector2(newPlatX, newPlatY));
      add(newPlat);

      // after rendering, add to platforms queue for management
      platforms.add(newPlat);

      // remove the lowest platform
      final lowestPlat = platforms.removeAt(0);
      // remove component from game
      lowestPlat.removeFromParent();
    }
    super.update(dt);
  }
}
