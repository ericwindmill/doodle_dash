import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../game/doodle_dash.dart';

// Overlay that shows up during an active game

class GameOverlay extends StatefulWidget {
  const GameOverlay(this.game, {super.key});

  final Game game;

  @override
  State<GameOverlay> createState() => GameOverlayState();
}

class GameOverlayState extends State<GameOverlay> {
  bool isPaused = false;

  // TODO: Style button
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // TODO: Break out buttons into separate widgets
          Positioned(
            top: 30,
            left: 30,
            child: ValueListenableBuilder(
                valueListenable: (widget.game as DoodleDash).score,
                builder: (context, value, child) {
                  return Text(
                    'Score: $value',
                    style: Theme.of(context).textTheme.displaySmall,
                  );
                }),
          ),
          Positioned(
            top: 30,
            right: 30,
            child: ElevatedButton(
                child: const Icon(Icons.pause),
                onPressed: () {
                  (widget.game as DoodleDash).togglePauseState();
                }),
          ),
          Positioned(
            top: 30,
            right: 30,
            child: ElevatedButton(
              child: isPaused
                  ? const Icon(
                      Icons.play_arrow,
                      size: 48,
                    )
                  : const Icon(
                      Icons.pause,
                      size: 48,
                    ),
              onPressed: () {
                (widget.game as DoodleDash).togglePauseState();
                setState(() {
                  isPaused = !isPaused;
                });
              },
            ),
          ),
          if (isPaused)
            Positioned(
              // positions button with width of button in mind
              top: MediaQuery.of(context).size.height / 2 - 72.0,
              right: MediaQuery.of(context).size.width / 2 - 72.0,
              child: const Icon(
                Icons.pause_circle,
                size: 144.0,
                color: Colors.black12,
              ),
            ),
        ],
      ),
    );
  }
}
