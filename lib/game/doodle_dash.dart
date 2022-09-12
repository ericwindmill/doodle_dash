import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

import 'sprites/sprites.dart';
import './world.dart';

class DoodleDash extends FlameGame with HasKeyboardHandlerComponents {
  DoodleDash({super.children});

  final World _world = World();

  Future<void> onLoad() async {
    await add(_world);

    Player dash = Player();
    dash.position = Vector2(
        (_world.size.x - dash.size.x) / 2, (_world.size.y - dash.size.y) - 100);
    await add(dash);
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  @override
  Color backgroundColor() {
    return const Color.fromARGB(255, 241, 247, 249);
  }
}
