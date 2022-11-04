import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../doodle_dash.dart';
import '../util/util.dart';

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
    return LayoutBuilder(builder: (context, constraints) {
      final characterWidth = constraints.maxWidth / 5;

      final TextStyle titleStyle = (constraints.maxWidth > 830)
          ? Theme.of(context).textTheme.displayLarge!
          : Theme.of(context).textTheme.displaySmall!;

      // 760 is the smallest height the browser can have until the
      // layout is too large to fit.
      final bool screenHeightIsSmall = constraints.maxHeight < 760;

      return Material(
        color: Palette.background,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Doodle Dash',
                    style: titleStyle.copyWith(
                      color: Palette.lightText,
                      height: .8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const WhiteSpace(),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Select your character:',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(color: Palette.lightText),
                    ),
                  ),
                  if (!screenHeightIsSmall) const WhiteSpace(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (states) {
                              if (states.contains(MaterialState.hovered)) {
                                return Palette.spaceLight;
                              }
                              if (character != null &&
                                  character == Character.dash) {
                                return Palette.spaceLight;
                              }
                              return Palette.spaceMedium;
                            },
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/game/left_dash.png',
                                height: characterWidth,
                                width: characterWidth,
                              ),
                              const WhiteSpace(height: 18),
                              const Text(
                                'Dash',
                                style: TextStyle(fontSize: 24),
                              ),
                            ],
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
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
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
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/game/right_sparky.png',
                                height: characterWidth,
                                width: characterWidth,
                              ),
                              const WhiteSpace(height: 18),
                              const Text(
                                'Sparky',
                                style: TextStyle(fontSize: 24),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (!screenHeightIsSmall) const WhiteSpace(height: 50),
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
                          label: (widget.game as DoodleDash).level.toString(),
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
                  if (!screenHeightIsSmall) const WhiteSpace(height: 50),
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
        ),
      );
    });
  }
}

class WhiteSpace extends StatelessWidget {
  const WhiteSpace({super.key, this.height = 100});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}
