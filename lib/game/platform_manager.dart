import 'dart:math';

import 'package:flame/components.dart';

import 'doodle_dash.dart';
import 'sprites/platform.dart';

class Difficulty {
  double minHeight;
  double jumpSpeed;

  Difficulty({required this.minHeight, required this.jumpSpeed});
}

final Map<int, Difficulty> levels = {
  1: Difficulty(minHeight: 200, jumpSpeed: 600),
  2: Difficulty(minHeight: 300, jumpSpeed: 650),
  3: Difficulty(minHeight: 400, jumpSpeed: 700),
  4: Difficulty(minHeight: 500, jumpSpeed: 750),
  5: Difficulty(minHeight: 600, jumpSpeed: 800),
};

class PlatformManager extends Component with HasGameRef<DoodleDash> {
  int level = 1;
  final Random random = Random();
  final List<Platform> platforms = [];
  double maxVerticalDistanceToNextPlatform;

  double minVerticalDistanceToNextPlatform = 200;

  PlatformManager({required this.maxVerticalDistanceToNextPlatform}) : super();

  void setLevel(int newLevel) {
    Difficulty? difficulty = levels[newLevel];

    if (difficulty == null) return;

    double minVerticalDistance = difficulty.minHeight;

    level = newLevel;
    minVerticalDistanceToNextPlatform = minVerticalDistance;
    maxVerticalDistanceToNextPlatform = 200 + minVerticalDistance;

    gameRef.dash.setJumpSpeed(difficulty.jumpSpeed);
  }

  @override
  void onMount() {
    setLevel(1);

    var currentX = (gameRef.size.x.floor() / 2).toDouble() - 50;
    // The first platform will always be in the bottom third of the initial screen
    var currentY =
        gameRef.size.y - (random.nextInt(gameRef.size.y.floor()) / 3) - 50;

    // Generate 10 Platforms at random x, y positions and add to list of platforms
    // to be populated in the game.
    for (var i = 0; i < 9; i++) {
      if (i != 0) {
        currentX = _generateNextX();
        currentY = _generateNextY();
      }
      platforms.add(
        Platform(
          position: Vector2(
            currentX,
            currentY,
          ),
        ),
      );
    }

    for (var platform in platforms) {
      add(platform);
    }

    super.onMount();
  }

  double _generateNextX() {
    // -50 (width of platform) ensures the platform doesn't populate outside
    //right bound of game
    return random.nextInt(gameRef.size.x.floor() - 50).toDouble();
  }

  // This method determines where the next platform should be placed
  // It calculates a random distance between the minVerticalDistanceToNextPlatform
  // and the maxVerticalDistanceToNextPlatform, and returns a Y coordiate that is
  // that distance above the current highest platform
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
      var newPlatX = _generateNextX();

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
