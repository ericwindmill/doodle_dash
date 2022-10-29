import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';

import '../doodle_dash.dart';
import 'platform.dart';

enum PlayerDirection { left, right, center }

class Player extends SpriteGroupComponent<PlayerDirection>
    with HasGameRef<DoodleDash>, KeyboardHandler, CollisionCallbacks {
  Player({super.position, required this.character})
      : super(
          size: Vector2.all(100),
          anchor: Anchor.center,
          priority: 1,
        );

  Vector2 _velocity = Vector2.zero();

  // used to calculate if the user is moving Dash left (-1) or right (1)
  int _hAxisInput = 0;

  Character character;

  // used to calculate the horizontal movement speed
  final double _moveSpeed = 400; // horizontal travel speed
  final double _gravity = 9; // acceleration pulling Dash down
  double _jumpSpeed = 600; // vertical travel speed

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Add collision detection on Dash
    await add(CircleHitbox());

    await _loadCharacterSprites();

    // arbitrarily start with Dash facing right
    current = PlayerDirection.center;
  }

  @override
  void update(double dt) {
    if (gameRef.isIntro || gameRef.isGameOver) return;

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

  void reset() {
    _velocity = Vector2.zero();
  }

  // When arrow keys are pressed, change Dash's travel direction + sprite
  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _hAxisInput = 0;

    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      current = PlayerDirection.left;
      _hAxisInput += -1;
    }

    if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      current = PlayerDirection.right;
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
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
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
    } else if (other is SpringBoard) {
      jump(specialJumpSpeed: _jumpSpeed * 2);
    } else if (other is BrokenPlatform &&
        other.current == BrokenPlatformState.cracked) {
      jump();
    }

    super.onCollision(intersectionPoints, other);
  }

  void jump({double? specialJumpSpeed}) {
    // Top left is 0,0 so going "up" is negative
    _velocity.y = specialJumpSpeed != null ? -specialJumpSpeed : -_jumpSpeed;
  }

  void megaJump() {
    _velocity.y = -_jumpSpeed * 1.5;
  }

  void setJumpSpeed(double jumpSpeed) {
    _jumpSpeed = jumpSpeed;
  }

  Future<void> _loadCharacterSprites() async {
    print(character.name);
    // Load & configure sprite assets
    final left = await gameRef.loadSprite('game/left_${character.name}.png');
    final right = await gameRef.loadSprite('game/right_${character.name}.png');
    final center = await gameRef.loadSprite('game/left_${character.name}.png');
    sprites = <PlayerDirection, Sprite>{
      PlayerDirection.left: left,
      PlayerDirection.right: right,
      PlayerDirection.center: center,
    };
  }
}
