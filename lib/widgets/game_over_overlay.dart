import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../game/doodle_dash.dart';

class GameOverOverlay extends StatelessWidget {
  const GameOverOverlay(this.game, {super.key});

  final Game game;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double menuHeight = screenSize.height > 300 ? 300 : screenSize.height;
    final double menuWidth = screenSize.width > 300 ? 300 : screenSize.width;

    return Material(
      color: Colors.black45,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints.tight(Size(menuWidth, menuHeight)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Game Over',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              ValueListenableBuilder(
                  valueListenable: (game as DoodleDash).score,
                  builder: (context, value, child) {
                    return Text(
                      'Score: $value',
                      style: Theme.of(context).textTheme.displaySmall,
                    );
                  }), // todo: get game score
              ElevatedButton(
                onPressed: () {
                  (game as DoodleDash).resetGame();
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(
                    const Size.fromHeight(40),
                  ),
                  textStyle: MaterialStateProperty.all(
                      Theme.of(context).textTheme.titleLarge),
                ),
                child: const Text('Play Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
