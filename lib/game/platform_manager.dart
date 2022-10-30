import 'dart:math';

import 'package:flame/components.dart';

import '../util/range.dart';
import 'doodle_dash.dart';
import 'sprites/sprites.dart';

class Difficulty {
  double minHeight;
  double maxHeight;
  double jumpSpeed;

  Difficulty(
      {required this.minHeight,
      required this.maxHeight,
      required this.jumpSpeed});
}

// Configurations for different levels of difficulty,
//the higher level the further away Dash may need to jump. Since
// gravity is constant, jumpSpeed needs to accomodate for further distance.
final Map<int, Difficulty> levels = {
  1: Difficulty(minHeight: 200, maxHeight: 400, jumpSpeed: 600),
  2: Difficulty(minHeight: 200, maxHeight: 500, jumpSpeed: 650),
  3: Difficulty(minHeight: 200, maxHeight: 600, jumpSpeed: 700),
  4: Difficulty(minHeight: 200, maxHeight: 700, jumpSpeed: 750),
  5: Difficulty(minHeight: 200, maxHeight: 800, jumpSpeed: 800),
};

// Spawns the platforms for the game
class PlatformManager extends Component with HasGameRef<DoodleDash> {
  PlatformManager({this.level = 1});

  int level = 1;
  final Random random = Random();
  final List<Platform> platforms = [];
  double maxVerticalDistanceToNextPlatform = 1000;
  double platformHeight = 50;

  double minVerticalDistanceToNextPlatform = 200;

  void setLevel(int newLevel) {
    Difficulty? difficulty = levels[newLevel];

    if (difficulty == null) return;

    level = newLevel;

    minVerticalDistanceToNextPlatform = difficulty.minHeight;
    maxVerticalDistanceToNextPlatform = difficulty.maxHeight;
    gameRef.player.setJumpSpeed(difficulty.jumpSpeed);
  }

  Platform randomPlatform(Vector2 position) {
    switch (random.nextInt(3)) {
      case 0:
        return GrassPlatform(position: position);
      case 1:
        return MovingPlatform(position: position);
      case 2:
        return Platform(position: position);
      default:
        return Platform(position: position);
    }
  }

  @override
  void onMount() {
    super.onMount();

    // TODO (future episode): Ask user what level and set it here
    setLevel(level);

    // Position Dash in the middle
    var currentX = (gameRef.size.x.floor() / 2).toDouble() - 50;
    // The first platform will always be in the bottom third of the initial screen
    var currentY =
        gameRef.size.y - (random.nextInt(gameRef.size.y.floor()) / 3) - 50;

    // Generate 30 Platforms at random x, y positions and add to list of platforms
    // to be populated in the game.
    for (var i = 0; i < 9; i++) {
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

      // Future proofing. Make sure that the platform height is always
      // equal to the height of the tallest platform.
      if (platformHeight < platforms[i].size.y) {
        platformHeight = platforms.first.size.y;
      }

      add(platforms[i]);
    }
  }

  double _generateNextX() {
    final platformWidth = platforms.last.size.x;
    // Used to ensure that the next platform doesn't overlap
    final previousPlatformXRange = Range(
      platforms.last.position.x,
      platforms.last.position.x + platformWidth,
    );

    // -50 (width of platform) ensures the platform doesn't populate outside
    // right bound of game
    // Anchor is topLeft by default, so this X is the left most point of the platform
    // Platform width should always be 50 regardless of which platform.
    double nextPlatformAnchorX;

    // If the previous platform and next overlap, try a new random X
    do {
      nextPlatformAnchorX =
          random.nextInt(gameRef.size.x.floor() - 50).toDouble();
    } while (previousPlatformXRange.overlaps(
        Range(nextPlatformAnchorX, nextPlatformAnchorX + platformWidth)));

    return nextPlatformAnchorX;
  }

  // This method determines where the next platform should be placed
  // It calculates a random distance between the minVerticalDistanceToNextPlatform
  // and the maxVerticalDistanceToNextPlatform, and returns a Y coordiate that is
  // that distance above the current highest platform
  double _generateNextY() {
    // Adding platformHeight prevents platforms from overlapping.
    final currentHighestPlatformY = platforms.last.center.y + platformHeight;

    // TODO (Khanh): Switch to difficulty level logic,
    // increase level of difficulty every 20 or so platforms
    final distanceToNextY = minVerticalDistanceToNextPlatform.toInt() +
        random
            .nextInt((maxVerticalDistanceToNextPlatform -
                    minVerticalDistanceToNextPlatform -
                    100)
                .floor())
            .toDouble();

    return currentHighestPlatformY - distanceToNextY;
  }

  @override
  void update(double dt) {
    // Adding Platform Height will ensure that 2 platforms don't overlap.
    final topOfLowestPlatform = platforms.first.position.y + platformHeight;

    final screenBottom = gameRef.player.position.y +
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
      // increase score whenever "Dash passes a platform"
      // Really, increase score when a platform passes off the screen
      // It's the simplest way to do it
      gameRef.score.value++;

      // TODO: Configure these percentages
      // TODO (future episode): Add additional power up code here
      if (_shouldGenerateEntity()) {
        final springPlat =
            SpringBoard(position: Vector2(_generateNextX(), _generateNextY()));
        add(springPlat);
      }

      if (_shouldGenerateEntity()) {
        final brokenPlatform = BrokenPlatform(
            position: Vector2(_generateNextX(), _generateNextY()));
        add(brokenPlatform);
      }

      if (_shouldGenerateEntity()) {
        final jetpack =
            Jetpack(position: Vector2(_generateNextX(), _generateNextY()));
        add(jetpack);
      }

      // Enemies
      // Generate Trashcan
      if (_shouldGenerateEntity()) {
        final trashcan = Trashcan(
            position: Vector2(
          _generateNextX(),
          _generateNextY(),
        ));
        add(trashcan);
      }
    }
    super.update(dt);
  }

  // Returns true X % of the time, and false 100-X% of the time.
  bool _shouldGenerateEntity({int percentLikely = 30}) {
    final randNum = random.nextInt(100);

    // if randNum is greater than percent likely
    // Example:
    //  randNum = 52, percentLikely = 30
    //  return 52 > 70 (false)
    return randNum > (100 - percentLikely);
  }
}
