import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';

import '../doodle_dash.dart';
import 'platform.dart';

enum DashDirection { left, right }

class Player extends SpriteGroupComponent<DashDirection>
    with HasGameRef<DoodleDash>, KeyboardHandler, CollisionCallbacks {
  Player({super.position})
      : super(
          size: Vector2.all(100),
          anchor: Anchor.center,
        );

  final Vector2 _velocity = Vector2.zero();
  // used to calculate if the user is moving Dash left (-1) or right (1)
  int _hAxisInput = 0;
  // used to calculate the hosizontal movement speed
  final double _moveSpeed = 250;
  final double _gravity = 4;
  final double _jumpSpeed = 400;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await add(CircleHitbox());

    final leftDash = await gameRef.loadSprite('game/left_dash.png');
    final rightDash = await gameRef.loadSprite('game/right_dash.png');

    sprites = <DashDirection, Sprite>{
      DashDirection.left: leftDash,
      DashDirection.right: rightDash,
    };

    // arbitrarily start with Dash facing right
    current = DashDirection.right;
  }

  @override
  void update(double dt) {
    _velocity.x = _hAxisInput * _moveSpeed;
    _velocity.y += _gravity;

    // infinite side boundaries
    // TODO: tweak numbers to make smooth.
    if (position.x < -50) {
      position.x = gameRef.size.x + size.x + 10;
    }
    if (position.x > gameRef.size.x + size.x + 10) {
      position.x = -50;
    }

    position += _velocity * dt;
    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _hAxisInput = 0;

    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      current = DashDirection.left;
      _hAxisInput += -1;
    }

    if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      current = DashDirection.right;
      _hAxisInput += 1;
    }

    // should be taken out after development, because its cheating
    if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      jump();
    }

    return true;
  }

  bool get isMovingDown => _velocity.y > 0;

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Platform) {
      // if Dash is moving down and collides with a platform
      // this _should_ allow dash to move up through platforms, but collide on the way down
      bool isMovingDown = _velocity.y > 0;
      bool isCollidingVertically =
          (intersectionPoints.first.y - intersectionPoints.last.y).abs() < 5;
      if (isMovingDown && isCollidingVertically) {
        jump();
      }
    }

    super.onCollision(intersectionPoints, other);
  }

  void jump() {
    _velocity.y = -_jumpSpeed;
  }

  void megaJump() {
    _velocity.y = -_jumpSpeed * 1.5;
  }
}
