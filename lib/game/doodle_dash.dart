import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

import './world.dart';
import 'platform_manager.dart';
import 'sprites/sprites.dart';

class DoodleDash extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  DoodleDash({super.children});

  Player dash = Player();
  World _world = World();

  PlatformManager platformManager = PlatformManager(
    maxVerticalDistanceToNextPlatform:
        350, // TODO: (sprint 2) refactor to use a variable called jumpSpeed so this and Dash's jump are in sync, make responsive
  );

  int screenBufferSpace = 100;
  int score = 0;

  @override
  Future<void> onLoad() async {
    await add(_world);
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
    await setupNewGame();
  }

  Future<void> setupNewGame() async {
    // reset state if nessecary
    if (children.contains(platformManager)) platformManager.removeFromParent();
    if (children.contains(dash)) dash.removeFromParent();
    score = 0;

    // Set Dash's position, starting off screen ("below" camera)
    dash = Player();
    dash.position = Vector2(
      (_world.size.x - dash.size.x) / 2,
      ((_world.size.y + screenBufferSpace) + dash.size.y),
    );

    // Add Dash component to the game
    await add(dash);

    // Add the platform manager component to the game
    // replace the platform every new game so that onMount is called
    platformManager = PlatformManager(maxVerticalDistanceToNextPlatform: 350);
    await add(platformManager);

    // Launches Dash from below the screen into frame when the game starts
    dash.megaJump();
  }

  // on mount is called after onLoad
  @override
  void onMount() {
    super.onMount();
    overlays.add('mainMenuOverlay');
    pauseEngine();
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Camera should only follow Dash when she's moving up, if she's following down
    // the camera should stay where it is and NOT follow her down.
    if (dash.isMovingDown) {
      camera.worldBounds = Rect.fromLTRB(
        0,
        camera.position.y - screenBufferSpace,
        camera.gameSize.x,
        camera.position.y + _world.size.y,
      );
    }

    var isInTopHalfOfScreen = dash.position.y <= (_world.size.y / 2);
    if (!dash.isMovingDown && isInTopHalfOfScreen) {
      // Here, we really only care about the "T" porition of the LTRB.
      // ensure that the world is always much taller than Dash will reach
      // we will want to consider not doing this on every frame tick if it
      // becomes janky
      camera.worldBounds = Rect.fromLTRB(
        0,
        camera.position.y - screenBufferSpace,
        camera.gameSize.x,
        camera.position.y + _world.size.y,
      );
      camera.followComponent(dash);
    }
    // if Dash falls off screen, game over!
    if (dash.position.y >
        camera.position.y +
            _world.size.y +
            dash.size.y +
            screenBufferSpace +
            200) {
      onLose();
    }
  }

  @override
  Color backgroundColor() {
    return const Color.fromARGB(255, 241, 247, 249);
  }

  void startGame() async {
    resumeEngine();
    overlays.remove('mainMenuOverlay');
  }

  void onLose() {
    pauseEngine();
    overlays.add('gameOverOverlay');
    setupNewGame();
  }

  void toMenuFromGameOver() {
    dash.position = Vector2(0, 0);
    overlays.remove('gameOverOverlay');
    overlays.add('mainMenuOverlay');
  }

  void togglePauseState() {
    if (paused) {
      resumeEngine();
    } else {
      pauseEngine();
    }
  }
}
