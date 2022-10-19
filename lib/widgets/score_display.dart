import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../game/doodle_dash.dart';

class ScoreDisplay extends StatelessWidget {
  const ScoreDisplay({super.key, required this.game});

  final Game game;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: (game as DoodleDash).score,
      builder: (context, value, child) {
        return Text(
          'Score: $value',
          style: Theme.of(context).textTheme.displaySmall,
        );
      },
    );
  }
}
