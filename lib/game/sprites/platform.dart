// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../doodle_dash.dart';

class Platform extends SpriteComponent
    with HasGameRef<DoodleDash>, CollisionCallbacks {
  final hitbox = RectangleHitbox();

  Platform({
    super.position,
  }) : super(
          size: Vector2.all(50),
          priority: 2,
        );

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('game/yellow_platform.png');
    await add(hitbox);
  }

  @override
  // ignore: unnecessary_overrides
  void update(double dt) {
    super.update(dt);
  }

  @override
  // ignore: unnecessary_overrides
  void remove(Component component) {
    super.remove(component);
  }
}
