import 'package:flame/components.dart';
import 'package:flutter/services.dart';

import '../doodle_dash.dart';

enum DashDirection { left, right }

class Player extends SpriteGroupComponent<DashDirection>
    with HasGameRef<DoodleDash>, KeyboardHandler {
  Player({super.position}) : super(size: Vector2.all(100));

  final Vector2 _velocity = Vector2.zero();
  // used to calculate if the user is moving Dash left (-1) or right (1)
  int _hAxisInput = 0;
  // used to calculate the hosizontal movement speed
  final double _moveSpeed = 250;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
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

    return true;
  }
}
