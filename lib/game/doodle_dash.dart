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
        350, // todo: refactor to use a variable for jump speed and this
  );
  Player dash = Player();

  bool _cameraFixedWhileDashFalling = false;
  double currentWorldBoundBottom = 100000;

  @override
  Future<void> onLoad() async {
    await add(_world);

    dash.position = Vector2(
      (_world.size.x - dash.size.x) / 2,
      ((_world.size.y + 100) + dash.size.y),
    );
    await add(dash);
    add(platformManager);
    camera.worldBounds = Rect.fromLTRB(
      0,
      -10000, // todo
      camera.gameSize.x,
      10000,
    );

    dash.megaJump();
  }

  @override
  // ignore: unnecessary_overrides
  void update(double dt) {
    super.update(dt);

    /// NOTE FOR FUTURE ME:
    /// I think what I need to do is have the camera follow dash if she's in the top half
    /// of the screen and moving up, but the camera should be fixed if shes in the bottom half
    /// of the screen OR moving down while in the top half.
    ///

    var isInTopHalfOfScreen = dash.position.y <= (_world.size.y / 2);

    // when dash first reaches the center Y after launching onto screen,
    // fix camera on dash
    // if (dash.position.y <= (_world.size.y / 2) && !_cameraFixedForGame) {
    //   camera.followComponent(dash);
    //   _cameraFixedForGame = true;
    // }

    // the lower bound of the world should always be the current screen.position.y
    // so it must increase as dash moves up.
    // if (!dash.isMovingDown) {
    //   currentWorldBoundBottom = dash.center.y + (_world.size.y / 2);
    //   camera.worldBounds = Rect.fromLTRB(
    //     0,
    //     -10000, // todo
    //     camera.gameSize.x,
    //     currentWorldBoundBottom,
    //   );
    // } else {
    //   camera.resetMovement();
    //   _cameraFixedForGame = false;
    // }

    // What would be better is to have the camera stop following Dash if this is true
    // then, let Dash fall off screen, and when shes completely off, call onLose.
    if (dash.position.y > platformManager.platforms.first.y + 2000) {
      onLose();
    }
  }

  @override
  Color backgroundColor() {
    return const Color.fromARGB(255, 241, 247, 249);
  }

  // Todo: Detect when Dash has fallen bellow the bottom platform
  void onLose() {
    print('loser!');
    pauseEngine();
  }
}
