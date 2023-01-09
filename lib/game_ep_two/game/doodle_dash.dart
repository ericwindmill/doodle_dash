import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

import 'platform_manager.dart';
import 'sprites/sprites.dart';
import 'world.dart';

enum GameState { intro, playing, gameOver }

class DoodleDashEp2 extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  DoodleDashEp2({super.children});

  final Player dash = Player();
  final World _world = World();
  PlatformManager platformManager = PlatformManager();

  int screenBufferSpace = 200;
  GameState state = GameState.intro;
  bool get isPlaying => state == GameState.playing;
  bool get isGameOver => state == GameState.gameOver;
  bool get isIntro => state == GameState.intro;

  ValueNotifier<int> score = ValueNotifier(0);

  @override
  Future<void> onLoad() async {
    await add(_world);

    // add the pause button and score keeper
    overlays.add('gameOverlay');

    // Add Dash component to the game
    await add(dash);

    initializeGameStart();
  }

  @override
  void update(double dt) {
    super.update(dt);

    // stop updating in between games
    if (isGameOver) {
      return;
    }

    // show the main menu when the game launches
    // And return so the engine doesn't  update as long as the menu is up.
    if (isIntro) {
      overlays.add('mainMenuOverlay');
      return;
    }

    if (isPlaying) {
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
          camera.position.y + _world.size.y + dash.size.y + screenBufferSpace) {
        onLose();
      }
    }
  }

  @override
  Color backgroundColor() {
    return const Color.fromARGB(255, 241, 247, 249);
  }

  // This method sets (or resets) the camera, dash and platform manager.
  // It is called when you start a game. Resets game state
  void initializeGameStart() {
    // remove platform if necessary, because a new one is made each time a new
    // game is started.
    if (children.contains(platformManager)) platformManager.removeFromParent();

    // reset dash's velocity
    dash.reset();

    //reset score
    score.value = 0;

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
    camera.followComponent(dash);

    // move dash back to the start
    dash.position = Vector2(
      (_world.size.x - dash.size.x) / 2,
      (_world.size.y - dash.size.y) / 2,
    );

    // reset the the platforms
    platformManager = PlatformManager();
    add(platformManager);
  }

  void startGame() {
    state = GameState.playing;
    overlays.remove('mainMenuOverlay');
  }

  void resetGame() {
    initializeGameStart();
    startGame();
    overlays.remove('gameOverOverlay');
  }

  void onLose() {
    state = GameState.gameOver;
    overlays.add('gameOverOverlay');
  }

  void togglePauseState() {
    if (paused) {
      resumeEngine();
    } else {
      pauseEngine();
    }
  }
}
