import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../doodle_dash.dart';

class PowerUp extends SpriteComponent
    with HasGameRef<DoodleDash>, CollisionCallbacks {
  final hitbox = RectangleHitbox();

  PowerUp({
    super.position,
  }) : super(
          size: Vector2.all(50),
          priority: 2, // Ensures platform is always behind Dash
        );

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    // collision detection logic
    await add(hitbox);
  }
}

class Jetpack extends PowerUp {
  Jetpack({
    super.position,
  });

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('game/torchLit.png');
  }
}

class NooglerHat extends PowerUp {
  NooglerHat({
    super.position,
  });

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('game/noogler_hat.png');
    size = Vector2(50, 30);
  }
}
