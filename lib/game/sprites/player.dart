import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';

import '../doodle_dash.dart';
import 'sprites.dart';

enum PlayerState { left, right, center, jetpack, noogler }

class Player extends SpriteGroupComponent<PlayerState>
    with HasGameRef<DoodleDash>, KeyboardHandler, CollisionCallbacks {
  Player({super.position, required this.character, this.jumpSpeed = 600})
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
  final double _gravity = 9; // acceleration pulling Dash down
  double jumpSpeed; // vertical travel speed

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Add collision detection on Dash
    await add(CircleHitbox());

    await _loadCharacterSprites();
    current = PlayerState.center;
  }

  @override
  void update(double dt) {
    if (gameRef.isIntro || gameRef.isGameOver) return;

    _velocity.x = _hAxisInput * jumpSpeed; // Dash's horizontal velocity
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
    current = PlayerState.center;
  }

  // When arrow keys are pressed, change Dash's travel direction + sprite
  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _hAxisInput = 0;

    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      if (current != PlayerState.jetpack) {
        current = PlayerState.left;
      }
      _hAxisInput += -1;
    }

    if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      if (current != PlayerState.jetpack) {
        current = PlayerState.right;
      }
      _hAxisInput += 1;
    }

    // should be taken out after development, because its cheating
    if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      jump();
    }

    return true;
  }

  bool get isMovingDown => _velocity.y > 0;

  bool get hasPowerup =>
      current == PlayerState.jetpack || current == PlayerState.noogler;

  bool get isInvincible => current == PlayerState.jetpack;

  // Callback for Dash colliding with another component in the game
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    // Check if Dash is moving down and collides with a platform from the top
    // this allows Dash to move up _through_ platforms without collision
    bool isMovingDown = _velocity.y > 0;
    bool isCollidingVertically =
        (intersectionPoints.first.y - intersectionPoints.last.y).abs() < 8;

    if (isMovingDown && hasPowerup) {
      current = PlayerState.center;
    }

    // Only want Dash to  “jump” when she is falling + collides with the top of a platform
    if (isMovingDown && isCollidingVertically) {
      // remove power up once falls down on platform
      if (other is EnemyPlatform && !isInvincible) {
        gameRef.onLose();
      } else if (other is NormalPlatform) {
        jump();
      } else if (other is SpringBoard) {
        jump(specialJumpSpeed: jumpSpeed * 2);
      } else if (other is BrokenPlatform &&
          other.current == BrokenPlatformState.cracked) {
        jump();
        other.breakPlatform();
      }
    }

    if (!hasPowerup) {
      if (other is Jetpack) {
        current = PlayerState.jetpack;
        jump(specialJumpSpeed: jumpSpeed * other.jumpSpeedMultiplier);
      } else if (other is NooglerHat) {
        current = PlayerState.noogler;
        _removePowerupAfterTime(other.activeLengthInMS);
        jump(specialJumpSpeed: jumpSpeed * other.jumpSpeedMultiplier);
      }
    }

    super.onCollision(intersectionPoints, other);
  }

  void _removePowerupAfterTime(int ms) {
    Future.delayed(Duration(milliseconds: ms), () {
      current = PlayerState.center;
    });
  }

  void jump({double? specialJumpSpeed}) {
    // Top left is 0,0 so going "up" is negative
    _velocity.y = specialJumpSpeed != null ? -specialJumpSpeed : -jumpSpeed;
  }

  void setJumpSpeed(double jumpSpeed) {
    jumpSpeed = jumpSpeed;
  }

  Future<void> _loadCharacterSprites() async {
    // Load & configure sprite assets
    final left = await gameRef.loadSprite('game/left_${character.name}.png');
    final right = await gameRef.loadSprite('game/right_${character.name}.png');
    final center = await gameRef.loadSprite('game/left_${character.name}.png');
    final jetpack =
        await gameRef.loadSprite('game/jetpack_${character.name}.png');
    final noogler =
        await gameRef.loadSprite('game/noogler_${character.name}.png');

    sprites = <PlayerState, Sprite>{
      PlayerState.left: left,
      PlayerState.right: right,
      PlayerState.center: center,
      PlayerState.jetpack: jetpack,
      PlayerState.noogler: noogler,
    };
  }
}
