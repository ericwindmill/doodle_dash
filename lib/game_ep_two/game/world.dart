import 'package:flame/components.dart';
import 'package:flame/parallax.dart';

import 'doodle_dash.dart';

class World extends ParallaxComponent<DoodleDashEp2> {
  @override
  Future<void> onLoad() async {
    parallax = await gameRef.loadParallax(
      [ParallaxImageData('game/graph_paper.png')],
    );
  }
}
