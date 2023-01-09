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
          priority: 1,
        );

  final Vector2 _velocity = Vector2.zero();

  // used to calculate if the user is moving Dash left (-1) or right (1)
  int _hAxisInput = 0;

  // used to calculate the horizontal movement speed
  final double _moveSpeed = 400; // horizontal travel speed
  final double _gravity = 7; // acceleration pulling Dash down
  final double _jumpSpeed = 600; // vertical travel speed

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Add collision detection on Dash
    await add(CircleHitbox());

    // Load & configure sprite assets
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
    _velocity.x = _hAxisInput * _moveSpeed; // Dash's horizontal velocity
    _velocity.y +=
        _gravity; // Gravity is always acting on Dash's vertical veloctiy

    // infinite side boundaries if Dash's body is off the screen (position is from center)
    if (position.x < size.x / 2) {
      position.x = gameRef.size.x + size.x + 10;
    }
    if (position.x > gameRef.size.x + size.x + 10) {
      position.x = size.x / 2;
    }

    // Calculate Dash's current position based on her velocity over elapsed time
    // since last update cycle
    position += _velocity * dt;
    super.update(dt);
  }

  // When arrow keys are pressed, change Dash's travel direction + sprite
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

  // Callback for Dash colliding with another component in the game
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Platform) {
      // Check if Dash is moving down and collides with a platform from the top
      // this allows Dash to move up _through_ platforms without collision
      bool isMovingDown = _velocity.y > 0;
      bool isCollidingVertically =
          (intersectionPoints.first.y - intersectionPoints.last.y).abs() < 5;

      // Only want Dash to  “jump” when she is falling + collides with the top of a platform
      if (isMovingDown && isCollidingVertically) {
        jump();
      }

      // TODO (sprint 3): Add collision behavior for power-ups
    }

    super.onCollision(intersectionPoints, other);
  }

  void jump() {
    // Top left is 0,0 so going "up" is negative
    _velocity.y = -_jumpSpeed;
  }

  void megaJump() {
    _velocity.y = -_jumpSpeed * 1.5;
  }
}
