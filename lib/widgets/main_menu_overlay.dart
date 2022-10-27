import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../game/doodle_dash.dart';

// Overlay that appears for the main menu

class MainMenuOverlay extends StatefulWidget {
  const MainMenuOverlay(this.game, {super.key});

  final Game game;

  @override
  State<MainMenuOverlay> createState() => _MainMenuOverlayState();
}

class _MainMenuOverlayState extends State<MainMenuOverlay> {
  Character? character;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Doodle Dash!',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const WhiteSpace(),
            Text(
              'Select character',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        character = Character.dash;
                      });
                    },
                    style: ButtonStyle(
                      side: MaterialStateProperty.all(
                        const BorderSide(color: Colors.black38, width: 2),
                      ),
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (states) {
                          if (character != null &&
                              character == Character.dash) {
                            return Theme.of(context).primaryColor;
                          }
                          return Colors.transparent;
                        },
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Image.asset(
                        'images/game/left_dash.png',
                        height: 150,
                        width: 150,
                      ),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        character = Character.sparky;
                      });
                    },
                    style: ButtonStyle(
                      side: MaterialStateProperty.all(
                        const BorderSide(color: Colors.black38, width: 2),
                      ),
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (states) {
                          if (character != null &&
                              character == Character.sparky) {
                            return Theme.of(context).primaryColor;
                          }
                          return Colors.transparent;
                        },
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Image.asset(
                        'images/game/right_sparky.png',
                        height: 150,
                        width: 150,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const WhiteSpace(),
            Center(
              child: ElevatedButton(
                onPressed: (character != null)
                    ? () async {
                        (widget.game as DoodleDash).selectCharacter(character!);
                        (widget.game as DoodleDash).startGame();
                      }
                    : null,
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(
                    const Size(100, 50),
                  ),
                  textStyle: MaterialStateProperty.all(
                      Theme.of(context).textTheme.titleLarge),
                ),
                child: const Text('Start'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WhiteSpace extends StatelessWidget {
  const WhiteSpace({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 100,
    );
  }
}
