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
        350, // TODO: (sprint 2) refactor to use a variable called jumpSpeed so this and Dash's jump are in sync, make responsive
  );
  Player dash = Player();

  int screenBufferSpace = 100;

  @override
  Future<void> onLoad() async {
    await add(_world);
    // Set Dash's position, starting off screen ("below" camera)
    dash.position = Vector2(
      (_world.size.x - dash.size.x) / 2,
      ((_world.size.y + screenBufferSpace) + dash.size.y),
    );

    // Add Dash component to the game
    await add(dash);

    // Add the platform manager component to the game
    await add(platformManager);

    // Add the Pause Button
    overlays.add('gameOverlay');

    // Setting the World Bounds for the camera will allow the camera to "move up"
    // but stay fixed horizontally, allowing Dash to go out of camera on one side,
    // and re-appear on the other side.
    camera.worldBounds = Rect.fromLTRB(
      0,
      -_world.size.y, // top of screen is 0, so negative is already off screen
      camera.gameSize.x,
      _world.size.y +
          screenBufferSpace, // makes sure bottom bound of game is below bottom of screen
    );

    // Launches Dash from below the screen into frame when the game starts
    dash.megaJump();
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Camera should only follow Dash when she's moving up, if she's following down
    // the camera should stay where it is and NOT follow her down.
    if (dash.isMovingDown) {
      camera.worldBounds = Rect.fromLTRB(
        0,
        camera.position.y - screenBufferSpace, // TODO
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
        camera.position.y - screenBufferSpace, // TODO
        camera.gameSize.x,
        camera.position.y + _world.size.y,
      );
    }

    // if Dash falls off screen, game over!
    if (dash.position.y >
        camera.position.y + _world.size.y + dash.size.y + screenBufferSpace) {
      // TODO (sprint 2): find a cleaner way to calculate bottom of screen
      onLose();
    }
  }

  @override
  Color backgroundColor() {
    return const Color.fromARGB(255, 241, 247, 249);
  }

  // TODO: Detect when Dash has fallen bellow the bottom platform
  void onLose() {
    pauseEngine();
    overlays.add('gameOverOverlay');

    // TODO: Load Game Over text, restart button
  }
}
