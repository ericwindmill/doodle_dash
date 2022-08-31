import 'package:flame/components.dart';

import '../doodle_dash.dart';

class Player extends SpriteComponent with HasGameRef<DoodleDash> {
  Player() : super(size: Vector2.all(100));
  int count = 0;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('game/right_dash.png');
  }

  @override
  void update(double dt) {}
}
