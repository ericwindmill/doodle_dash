import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../game/doodle_dash.dart';

class GameOverlay extends StatefulWidget {
  const GameOverlay(this.game, {super.key});

  final Game game;

  @override
  State<GameOverlay> createState() => GameOverlayState();
}

class GameOverlayState extends State<GameOverlay> {
  bool isPaused = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
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
