import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../game/doodle_dash.dart';

class GameOverlay extends StatelessWidget {
  const GameOverlay(this.game, {super.key});

  final Game game;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned(
            top: 30,
            left: 30,
            child: Text('Score: ${(game as DoodleDash).score}'),
          ),
          Positioned(
            top: 30,
            right: 30,
            child: ElevatedButton(
                child: const Icon(Icons.pause),
                onPressed: () {
                  (game as DoodleDash).togglePauseState();
                }),
          ),
        ],
      ),
    );
  }
}
