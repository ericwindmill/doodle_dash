import 'dart:math';

import 'package:flame/components.dart';

import 'doodle_dash.dart';
import 'sprites/sprites.dart';
import 'util/util.dart';

final Random _rand = Random();

class ObjectManager extends Component with HasGameRef<DoodleDash> {
  ObjectManager({
    this.minVerticalDistanceToNextPlatform = 200,
    this.maxVerticalDistanceToNextPlatform = 400,
    this.difficultyMultiplier = 1,
  });

  double minVerticalDistanceToNextPlatform;
  double maxVerticalDistanceToNextPlatform;
  int difficultyMultiplier;
  final List<Platform> _platforms = [];
  final List<PowerUp> _powerups = [];
  final List<Enemy> _enemies = [];
  final double _tallestPlatformHeight = 50;

  @override
  void onMount() {
    super.onMount();
    increaseDifficulty(1);

    // The X that will be used for the next platform.
    // The initial X is the middle of the screen.
    var currentX = (gameRef.size.x.floor() / 2).toDouble() - 50;

    // The first platform will always be in the bottom third of the initial screen
    var currentY =
        gameRef.size.y - (_rand.nextInt(gameRef.size.y.floor()) / 3) - 50;

    // Generate 10 Platforms at random x, y positions and add to list of platforms
    // to be populated in the game.
    for (var i = 0; i < 9; i++) {
      if (i != 0) {
        currentX = _generateNextX();
        currentY = _generateNextY();
      }
      _platforms.add(
        _semiRandomPlatform(
          Vector2(
            currentX,
            currentY,
          ),
        ),
      );

      // Add Component to Flame tree
      add(_platforms[i]);
    }
  }

  @override
  void update(double dt) {
    // Adding Platform Height will ensure that 2 platforms don't overlap.
    final topOfLowestPlatform =
        _platforms.first.position.y + _tallestPlatformHeight;

    final screenBottom = gameRef.player.position.y +
        (gameRef.size.x / 2) +
        gameRef.screenBufferSpace;

    // When the lowest platform is offscreen, it can be removed and a new platform
    // should be added
    if (topOfLowestPlatform > screenBottom) {
      // Generate and add the next platform to the game
      var newPlatY = _generateNextY();
      var newPlatX = _generateNextX();
      final nextPlat = _semiRandomPlatform(Vector2(newPlatX, newPlatY));
      add(nextPlat);

      _platforms.add(nextPlat);
      // remove the lowest platform

      // Remove platforms that have gone out of view
      final lowestPlat = _platforms.removeAt(0);
      // remove component from game
      lowestPlat.removeFromParent();
      // increase score whenever "Dash passes a platform"
      // Really, increase score when a platform passes off the screen
      // It's the simplest way to do it
      gameRef.score.value++;

      int? nextLevel = scoreToLevel[gameRef.score.value];

      if (nextLevel != null && difficultyMultiplier < nextLevel) {
        increaseDifficulty(nextLevel);
      }

      _maybeAddPowerup();
      _maybeAddEnemy();
    }

    super.update(dt);
  }

  // Exposes a way for the DoodleDash component to increase difficulty mid-game
  void increaseDifficulty(int nextLevel) {
    difficultyMultiplier = nextLevel;
    minVerticalDistanceToNextPlatform = levels[nextLevel]!.minDistance;
    maxVerticalDistanceToNextPlatform = levels[nextLevel]!.maxDistance;
  }

  double _generateNextX() {
    final platformWidth = _platforms.last.size.x;
    // Used to ensure that the next platform doesn't overlap
    final previousPlatformXRange = Range(
      _platforms.last.position.x,
      _platforms.last.position.x + platformWidth,
    );

    // -50 (width of platform) ensures the platform doesn't populate outside
    // right bound of game
    // Anchor is topLeft by default, so this X is the left most point of the platform
    // Platform width should always be 50 regardless of which platform.
    double nextPlatformAnchorX;

    // If the previous platform and next overlap, try a new random X
    do {
      nextPlatformAnchorX =
          _rand.nextInt(gameRef.size.x.floor() - 50).toDouble();
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
    final currentHighestPlatformY =
        _platforms.last.center.y + _tallestPlatformHeight;

    final distanceToNextY = minVerticalDistanceToNextPlatform.toInt() +
        _rand
            .nextInt((maxVerticalDistanceToNextPlatform -
                    minVerticalDistanceToNextPlatform)
                .floor())
            .toDouble();

    return currentHighestPlatformY - distanceToNextY;
  }

  // Return a platform.
  // The percent chance of any given platform is NOT equal
  Platform _semiRandomPlatform(Vector2 position) {
    // Get a number from 1 to 100 (incl)
    var nextInt = _rand.nextInt(100) + 1;

    if (nextInt.between(1, 25)) {
      return NormalPlatform(position: position);
    }

    if (nextInt.between(25, 50)) {
      return NormalPlatform(position: position);
    }

    if (nextInt.between(50, 70)) {
      return BrokenPlatform(position: position);
    }

    if (nextInt.between(70, 85)) {
      return MovingPlatform(position: position);
    }

    if (nextInt.between(85, 100)) {
      return SpringBoard(position: position);
    }

    return NormalPlatform(position: position);
  }

  void _maybeAddPowerup() {
    var nextInt = _rand.nextInt(100);

    // there is a 15% chance to add a Noogler Hat
    if (nextInt.between(70, 85)) {
      // generate powerup
      var nooglerHat = NooglerHat(
        position: Vector2(_generateNextX(), _generateNextY()),
      );
      add(nooglerHat);
      _powerups.add(nooglerHat);
    }

    // There is a 15% chance to add a jetpack
    if (nextInt.between(, 100)) {
      var jetpack = Jetpack(
        position: Vector2(_generateNextX(), _generateNextY()),
      );
      add(jetpack);
      _powerups.add(jetpack);
    }
  }

  void _maybeAddEnemy() {
    // There will be 5 - 25% added to the probabilibity based on the current
    // difficulty. i.e. level 1 adds 5% and level 5 adds 25%
    var basePercentageAddedFromDifficulty = difficultyMultiplier * 5;
    var nextInt = _rand.nextInt(100) + basePercentageAddedFromDifficulty;
    if (nextInt > 95) {
      var trashcan = Enemy(
        position: Vector2(_generateNextX(), _generateNextY()),
      );
      add(trashcan);
      _enemies.add(trashcan);
      _cleanup();
    }
  }

  // Because powerups and enemies rely on probability to be generated
  // There is no exact best moment to remove them from the game
  // So, we periodically check if there are any that can be removed.
  void _cleanup() {
    final screenBottom = gameRef.player.position.y +
        (gameRef.size.x / 2) +
        gameRef.screenBufferSpace;

    while (_enemies.isNotEmpty && _enemies.first.position.y > screenBottom) {
      remove(_enemies.first);
      _enemies.removeAt(0);
    }

    while (_powerups.isNotEmpty && _powerups.first.position.y > screenBottom) {
      remove(_powerups.first);
      _powerups.removeAt(0);
    }
  }
}
