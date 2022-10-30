import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../doodle_dash.dart';

class Jetpack extends SpriteComponent
    with HasGameRef<DoodleDash>, CollisionCallbacks {
  final hitbox = RectangleHitbox();

  Jetpack({
    super.position,
  }) : super(
          size: Vector2.all(50),
          priority: 2, // Ensures platform is always behind Dash
        );

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('game/torchLit.png');

    // Add collision detection logic
    await add(hitbox);
  }
}
