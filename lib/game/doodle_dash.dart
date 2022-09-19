import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

import './world.dart';
import 'platform_manager.dart';
import 'sprites/sprites.dart';

class DoodleDash extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  DoodleDash({super.children});

  final World _world = World();
  final PlatformManager platformManager = PlatformManager(
    maxVerticalDistanceToNextPlatform:
        350, // todo: refactor to use a variable called jumpSpeed so this and Dash's jump are in sync
  );
  Player dash = Player();

  double currentWorldBoundBottom = 100000;

  @override
  Future<void> onLoad() async {
    await add(_world);
    // Dash starts off screen ("below" camera)
    dash.position = Vector2(
      (_world.size.x - dash.size.x) / 2,
      ((_world.size.y + 100) + dash.size.y),
    );
    await add(dash);
    await add(platformManager);

    // Setting the World Bounds for the camera will allow the camera to "move up"
    // but stay fixed horizontally, allowing Dash to go out of camera on one side,
    // and re-appear on the other side.
    camera.worldBounds = Rect.fromLTRB(
      0,
      -10000, // todo
      camera.gameSize.x,
      10000,
    );

    // Launches Dash into the screen when the game starts
    dash.megaJump();
  }

  @override
  void update(double dt) {
    super.update(dt);

    // when dash is moving down, set the bottom bounds of the camera to the current view
    if (dash.isMovingDown) {
      camera.worldBounds = Rect.fromLTRB(
        0,
        camera.position.y - 10000, // todo
        camera.gameSize.x,
        camera.position.y + _world.size.y,
      );
    }

    var isInTopHalfOfScreen = dash.position.y <= (_world.size.y / 2);
    if (!dash.isMovingDown && isInTopHalfOfScreen) {
      camera.followComponent(dash);
      // Here, we really only care about the "T" porition of the LTRB.
      // ensure that the world is always much taller than Dash will reach
      // we will want to consider not doing this on every frame tick if it
      // becomes janky
      camera.worldBounds = Rect.fromLTRB(
        0,
        camera.position.y - 10000, // todo
        camera.gameSize.x,
        camera.position.y + _world.size.y,
      );
    }

    // What would be better is to have the camera stop following Dash if this is true
    // then, let Dash fall off screen, and when shes completely off, call onLose.
    if (dash.position.y >
        camera.position.y + _world.size.y + dash.size.y + 100) {
      onLose();
    }
  }

  @override
  Color backgroundColor() {
    return const Color.fromARGB(255, 241, 247, 249);
  }

  // Todo: Detect when Dash has fallen bellow the bottom platform
  void onLose() {
    pauseEngine();
  }
}
