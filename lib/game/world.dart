import 'package:flame/components.dart';
import 'package:flame/parallax.dart';

import './doodle_dash.dart';

class World extends ParallaxComponent<DoodleDash> {
  @override
  Future<void> onLoad() async {
    parallax = await gameRef.loadParallax(
      [ParallaxImageData('game/test-space-bg.png')],
    );
  }
}
