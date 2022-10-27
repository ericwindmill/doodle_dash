import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../game/doodle_dash.dart';
import 'score_display.dart';

// Overlay that pops up when the game ends

class GameOverOverlay extends StatelessWidget {
  const GameOverOverlay(this.game, {super.key});

  final Game game;

  @override
  Widget build(BuildContext context) {
    // Sets overlay width & height to be screen dimension or 300 at most.
    // 300 is arbitrary, but looks good
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
              ScoreDisplay(
                game: game,
              ),
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
