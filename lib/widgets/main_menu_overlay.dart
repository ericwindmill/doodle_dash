import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../game/doodle_dash.dart';
import '../util/theme.dart';

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
      color: Palette.background,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Doodle Dash',
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(color: Palette.lightText),
              ),
              const WhiteSpace(),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Select character:',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(color: Palette.lightText),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          if (states.contains(MaterialState.hovered)) {
                            return Palette.spaceLight;
                          }
                          if (character != null &&
                              character == Character.sparky) {
                            return Palette.spaceLight;
                          }
                          return Palette.spaceMedium;
                        },
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Image.asset(
                        'images/game/left_dash.png',
                        height: 125,
                        width: 125,
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
                          if (states.contains(MaterialState.hovered)) {
                            return Palette.spaceLight;
                          }
                          if (character != null &&
                              character == Character.sparky) {
                            return Palette.spaceLight;
                          }
                          return Palette.spaceMedium;
                        },
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Image.asset(
                        'images/game/right_sparky.png',
                        height: 125,
                        width: 125,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Difficulty:',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Palette.lightText),
                  ),
                  Expanded(
                    child: Slider(
                      thumbColor: Palette.accent,
                      activeColor: Palette.active,
                      inactiveColor: Palette.inactive,
                      value: (widget.game as DoodleDash).level.toDouble(),
                      max: 5,
                      min: 1,
                      divisions: 4,
                      label: 'Difficulty',
                      onChanged: ((value) {
                        setState(() {
                          (widget.game as DoodleDash)
                              .selectDifficulty(value.toInt());
                        });
                      }),
                    ),
                  ),
                ],
              ),
              const WhiteSpace(),
              Center(
                child: ElevatedButton(
                  onPressed: (character != null)
                      ? () async {
                          (widget.game as DoodleDash)
                              .selectCharacter(character!);
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
