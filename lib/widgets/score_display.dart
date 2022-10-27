import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../game/doodle_dash.dart';
import '../util/theme.dart';

class ScoreDisplay extends StatelessWidget {
  const ScoreDisplay({super.key, required this.game, this.isLight = false});

  final Game game;
  final bool isLight;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: (game as DoodleDash).score,
      builder: (context, value, child) {
        return Text(
          'Score: $value',
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
                color: isLight ? Palette.lightText : Palette.darkText,
              ),
        );
      },
    );
  }
}
