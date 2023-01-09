import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../game/doodle_dash.dart';

// Overlay that appears for the main menu

class MainMenuOverlay extends StatelessWidget {
  const MainMenuOverlay(this.game, {super.key});

  final Game game;

  // TODO: Definitely style this overlay more

  @override
  Widget build(BuildContext context) {
    // The menu height and width is 300, unless the device screen is smaller than 300 x 300,
    // then it takes up the entire screen.
    final screenSize = MediaQuery.of(context).size;
    final double menuHeight = screenSize.height > 300 ? 300 : screenSize.height;
    final double menuWidth = screenSize.width > 300 ? 300 : screenSize.width;

    return Material(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints.tight(Size(menuWidth, menuHeight)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Doodle Dash!',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              ElevatedButton(
                onPressed: () {
                  (game as DoodleDashEp2).startGame();
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(
                    const Size.fromHeight(40),
                  ),
                  textStyle: MaterialStateProperty.all(
                      Theme.of(context).textTheme.titleLarge),
                ),
                child: const Text('Play'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
