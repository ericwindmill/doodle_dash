// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../doodle_dash.dart';

class Platform extends SpriteComponent
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
    sprite = await gameRef.loadSprite('game/yellow_platform.png');

    // Add collision detection logic
    await add(hitbox);
  }
}
// TODO (ep 3): Rename Platforms for correct assets

class GrassPlatform extends Platform {
  GrassPlatform({super.position});

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('game/grass_platform.png');
  }
}

class MovingPlatform extends Platform {
  MovingPlatform({super.position});

  Vector2 _velocity = Vector2.zero();
  double direction = 1;
  double speed = 35;
  Random random = Random();

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('game/sand_platform.png');

    final List<double> directions = [-1, 1];
    direction = directions[random.nextInt(2)];

    speed = random.nextInt(50) + 20;
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

class BrokenPlatform extends SpriteGroupComponent<BrokenPlatformState>
    with HasGameRef<DoodleDash>, CollisionCallbacks {
  BrokenPlatform({super.position})
      : super(
          size: Vector2.all(50),
          priority: 2, // Ensures platform is always behind Dash
        );

  final hitbox = RectangleHitbox();

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    // Load & configure sprite assets
    final cracked = await gameRef.loadSprite('game/cracked_stone_platform.png');
    final broken = await gameRef.loadSprite('game/broken_stone_platform.png');

    sprites = <BrokenPlatformState, Sprite>{
      BrokenPlatformState.cracked: cracked,
      BrokenPlatformState.broken: broken,
    };

    current = BrokenPlatformState.cracked;

    // Add collision detection logic
    await add(hitbox);
  }

  void breakPlatform() {
    current = BrokenPlatformState.broken;
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
  }
}

enum SpringState { down, up }

// Once we have other component assets, they can be built in similar manner
class SpringBoard extends SpriteGroupComponent<SpringState>
    with HasGameRef<DoodleDash>, CollisionCallbacks {
  final hitbox = RectangleHitbox();

  SpringBoard({
    super.position,
  }) : super(
          size: Vector2.all(50),
          priority: 2, // Ensures platform is always behind Dash
        );

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    // Load & configure sprite assets
    final springDown = await gameRef.loadSprite('game/springboardDown.png');
    final springUp = await gameRef.loadSprite('game/springboardUp.png');

    sprites = <SpringState, Sprite>{
      SpringState.down: springDown,
      SpringState.up: springUp,
    };

    current = SpringState.up;

    // Add collision detection logic
    await add(hitbox);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    current = SpringState.down;
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);

    current = SpringState.up;
  }
}
