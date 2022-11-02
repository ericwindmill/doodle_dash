// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../doodle_dash.dart';

abstract class Platform<T> extends SpriteGroupComponent<T>
    with HasGameRef<DoodleDash>, CollisionCallbacks {
  final hitbox = RectangleHitbox();

  Platform({
    super.position,
  }) : super(
          size: Vector2.all(50),
          priority: 2, // Ensures platform is always behind Dash
        );

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    // Add collision detection logic
    await add(hitbox);
  }
}

enum NormalPlatformState { only }

class NormalPlatform extends Platform<NormalPlatformState> {
  NormalPlatform({super.position});

  @override
  Future<void>? onLoad() async {
    sprites = {
      NormalPlatformState.only:
          await gameRef.loadSprite('game/grass_platform.png')
    };

    current = NormalPlatformState.only;
    await super.onLoad();
  }
}

enum MovingPlatformState { only }

class MovingPlatform extends Platform<MovingPlatformState> {
  MovingPlatform({super.position});

  final Vector2 _velocity = Vector2.zero();
  double direction = 1;
  double speed = 35;
  Random random = Random();

  @override
  Future<void>? onLoad() async {
    sprites = {
      MovingPlatformState.only:
          await gameRef.loadSprite('game/sand_platform.png')
    };

    current = MovingPlatformState.only;

    final List<double> directions = [-1, 1];
    direction = directions[random.nextInt(2)];

    speed = random.nextInt(50) + 20;
    await super.onLoad();
  }

  @override
  void update(double dt) {
    final double gameWidth = gameRef.size.x;

    if (position.x <= 0) {
      direction = 1;
    } else if (position.x >= gameWidth - size.x) {
      direction = -1;
    }

    _velocity.x = direction * speed;

    position += _velocity * dt;
  }
}

enum BrokenPlatformState { cracked, broken }

class BrokenPlatform extends Platform<BrokenPlatformState> {
  BrokenPlatform({super.position});

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    sprites = <BrokenPlatformState, Sprite>{
      BrokenPlatformState.cracked:
          await gameRef.loadSprite('game/cracked_stone_platform.png'),
      BrokenPlatformState.broken:
          await gameRef.loadSprite('game/broken_stone_platform.png'),
    };

    current = BrokenPlatformState.cracked;
  }

  void breakPlatform() {
    current = BrokenPlatformState.broken;
  }
}

enum SpringState { down, up }

// Once we have other component assets, they can be built in similar manner
class SpringBoard extends Platform<SpringState> {
  SpringBoard({
    super.position,
  });

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    sprites = <SpringState, Sprite>{
      SpringState.down: await gameRef.loadSprite('game/springboardDown.png'),
      SpringState.up: await gameRef.loadSprite('game/springboardUp.png'),
    };

    current = SpringState.up;
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    bool isCollidingVertically =
        (intersectionPoints.first.y - intersectionPoints.last.y).abs() < 5;

    if (isCollidingVertically) {
      current = SpringState.down;
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);

    current = SpringState.up;
  }
}
