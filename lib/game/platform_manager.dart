import 'dart:math';

import 'package:flame/components.dart';

import 'doodle_dash.dart';
import 'sprites/platform.dart';

class Difficulty {
  double minHeight;
  double maxHeight;
  double jumpSpeed;

  Difficulty(
      {required this.minHeight,
      required this.maxHeight,
      required this.jumpSpeed});
}

final Map<int, Difficulty> levels = {
  1: Difficulty(minHeight: 200, maxHeight: 400, jumpSpeed: 600),
  2: Difficulty(minHeight: 200, maxHeight: 500, jumpSpeed: 650),
  3: Difficulty(minHeight: 200, maxHeight: 600, jumpSpeed: 700),
  4: Difficulty(minHeight: 200, maxHeight: 700, jumpSpeed: 750),
  5: Difficulty(minHeight: 200, maxHeight: 800, jumpSpeed: 800),
};

class PlatformManager extends Component with HasGameRef<DoodleDash> {
  int level = 1;
  final Random random = Random();
  final List<Platform> platforms = [];
  double maxVerticalDistanceToNextPlatform;

<<<<<<< HEAD
  // TODO (sprint 2): Adjust this value to change game difficulty
  double minVerticalDistanceToNextPlatform = 0;
  double currentMaxVerticalDistance = 100;
=======
  double minVerticalDistanceToNextPlatform = 200;
>>>>>>> bcd222fe2c57b580c403d7a98d6af1f6a6daa602

  PlatformManager({required this.maxVerticalDistanceToNextPlatform}) : super();

  void setLevel(int newLevel) {
    Difficulty? difficulty = levels[newLevel];

    if (difficulty == null) return;

    level = newLevel;

    minVerticalDistanceToNextPlatform = difficulty.minHeight;
    maxVerticalDistanceToNextPlatform = difficulty.maxHeight;
    gameRef.dash.setJumpSpeed(difficulty.jumpSpeed);
  }

  Platform randomPlatform(Vector2 position) {
    switch (random.nextInt(3)) {
      case 0:
        return GrassPlatform(position: position);
      case 1:
        return SandPlatform(position: position);
      case 2:
        return StonePlatform(position: position);
      case 3:
        return Platform(position: position);
      default:
        return Platform(position: position);
    }
  }

  @override
  void onMount() {
    setLevel(1);

    var currentX = (gameRef.size.x.floor() / 2).toDouble() - 50;
    // The first platform will always be in the bottom third of the initial screen
    var currentY =
<<<<<<< HEAD
        gameRef.size.y - (random.nextInt(gameRef.size.y.floor()) / 4);
=======
        gameRef.size.y - (random.nextInt(gameRef.size.y.floor()) / 3) - 50;
>>>>>>> bcd222fe2c57b580c403d7a98d6af1f6a6daa602

    // Generate 10 Platforms at random x, y positions and add to list of platforms
    // to be populated in the game.
    for (var i = 0; i < 29; i++) {
      if (i != 0) {
        currentX = _generateNextX();
        currentY = _generateNextY();
      }
      platforms.add(
        randomPlatform(
          Vector2(
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
    print('minDistanceNextPlatform: $minVerticalDistanceToNextPlatform');
    // ensure that the next platform never overlaps with the last platform
    final currentHighestPlatformY =
        platforms.last.center.y - platforms.last.size.y;
    final distanceToNextY = minVerticalDistanceToNextPlatform.toInt() +
        random
            .nextInt(
                (currentMaxVerticalDistance - minVerticalDistanceToNextPlatform)
                    .floor())
            .toDouble();

    return currentHighestPlatformY - distanceToNextY;
  }

  @override
  void update(double dt) {
    // Increase the difficulty as the game progresses
    // Update the `minVerticalDistanceToNextPlatform` every 5 jumps
    // It should never increase higher than maxVeritclDistanceToNextPlatform
    if (gameRef.score.value % 5 == 0 &&
        minVerticalDistanceToNextPlatform + 10 <
            maxVerticalDistanceToNextPlatform) {
      minVerticalDistanceToNextPlatform += .01;
    }

    final topOfLowestPlatform = platforms.first.position.y;

    final screenBottom = gameRef.dash.position.y +
        (gameRef.size.x / 2) +
        gameRef.screenBufferSpace;

    // When the lowest platform is offscreen, it can be removed and a new platform
    // should be added
    if (topOfLowestPlatform > screenBottom) {
      var newPlatY = _generateNextY();
      var newPlatX = _generateNextX();

      final newPlat = randomPlatform(Vector2(newPlatX, newPlatY));
      add(newPlat);

      // after rendering, add to platforms queue for management
      platforms.add(newPlat);

      // remove the lowest platform
      final lowestPlat = platforms.removeAt(0);
      // remove component from game
      lowestPlat.removeFromParent();

      final springPlat =
          SpringBoard(position: Vector2(_generateNextX(), _generateNextY()));
      add(springPlat);
    }
    super.update(dt);
  }
}
