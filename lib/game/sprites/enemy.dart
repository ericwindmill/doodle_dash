import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../doodle_dash.dart';
import 'player.dart';

const Set<int> _movmentSpeeds = {0, 50, 100};

enum Direction {
  left,
  right,
}

class Enemy extends SpriteComponent
    with CollisionCallbacks, HasGameRef<DoodleDash> {
  Enemy({super.position}) : super(size: Vector2.all(50), priority: 2) {
    final randMovementSpeed = Random().nextInt(_movmentSpeeds.length - 1);
    movementSpeed = _movmentSpeeds.elementAt(randMovementSpeed).toDouble();
  }

  late double movementSpeed;
  Direction _direction = Direction.right;

  @override
  Future<void>? onLoad() async {
    sprite = await gameRef.loadSprite('game/trash_can.png');
    await add(RectangleHitbox());

    return super.onLoad();
  }

  @override
  void update(double dt) {
    var screenEdgeBuffer = 50;
    var screenRightEdge = gameRef.size.x;
    var screenLeftEdge = 0;

    // If Dash is heading left and
    // within 50px of the left edge of the screen
    // change directions
    if (_direction == Direction.left &&
        position.x - screenEdgeBuffer < screenLeftEdge) {
      _direction = Direction.right;
      return;
    }

    // If Dash is heading right and
    // within 50px of the right edge of the screen
    // change directions
    if (_direction == Direction.right &&
        position.x + screenEdgeBuffer > screenRightEdge) {
      _direction = Direction.left;
      return;
    }

    if (_direction == Direction.right) {
      position.x += movementSpeed * dt;
    }

    if (_direction == Direction.left) {
      position.x -= movementSpeed * dt;
    }

    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is Player) {
      if (!other.isInvincible) {
        gameRef.onLose();
      }
    }
  }
}
