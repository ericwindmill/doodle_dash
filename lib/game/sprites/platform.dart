// ignore_for_file: public_member_api_docs, sort_constructors_first
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

class GrassPlatform extends Platform {
  GrassPlatform({super.position});

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('game/grass_platform.png');
  }
}

class SandPlatform extends Platform {
  SandPlatform({super.position});

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('game/sand_platform.png');
  }
}

class StonePlatform extends Platform {
  StonePlatform({super.position});

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('game/stone_platform.png');
  }
}

enum SpringState { down, up }

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
    // TODO: implement onCollisionEnd
    super.onCollisionEnd(other);

    current = SpringState.up;
  }
}
