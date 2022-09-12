import 'package:flame/components.dart';
import 'package:flutter/services.dart';

import '../doodle_dash.dart';

enum DashDirection { left, right }

class Player extends SpriteGroupComponent<DashDirection>
    with HasGameRef<DoodleDash>, KeyboardHandler {
  Player() : super(size: Vector2.all(100));
  int count = 0;

  @override
  Future<void> onLoad() async {
    print('Player.onLoad');
    super.onLoad();
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
  void update(double dt) {}

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    print('Player.onKeyPressed');
    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      print('KEY LEFT!');
      current = DashDirection.left;
    }

    if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      print('KEY LEFT!');
      current = DashDirection.right;
    }

    return true;
  }
}
