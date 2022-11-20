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
  Character character = Character.dash;

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
                      height: .8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const WhiteSpace(),
                  Align(
                    alignment: Alignment.center,
                    child: Text('Select your character:',
                        style: Theme.of(context).textTheme.headlineSmall!),
                  ),
                  if (!screenHeightIsSmall) const WhiteSpace(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        style: (character == Character.dash)
                            ? ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        const Color.fromARGB(31, 64, 195, 255)))
                            : null,
                        onPressed: () {
                          setState(() {
                            character = Character.dash;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/game/dash_center.png',
                                height: characterWidth,
                                width: characterWidth,
                              ),
                              const WhiteSpace(height: 18),
                              const Text(
                                'Dash',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                      OutlinedButton(
                        style: (character == Character.sparky)
                            ? ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        const Color.fromARGB(31, 64, 195, 255)))
                            : null,
                        onPressed: () {
                          setState(() {
                            character = Character.sparky;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/game/sparky_center.png',
                                height: characterWidth,
                                width: characterWidth,
                              ),
                              const WhiteSpace(height: 18),
                              const Text(
                                'Sparky',
                                style: TextStyle(fontSize: 20),
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
                      Text('Difficulty:',
                          style: Theme.of(context).textTheme.bodyLarge!),
                      Expanded(
                        child: Slider(
                          value: (widget.game as DoodleDash)
                              .levelManager
                              .selectedLevel
                              .toDouble(),
                          max: 5,
                          min: 1,
                          divisions: 4,
                          label: (widget.game as DoodleDash)
                              .levelManager
                              .selectedLevel
                              .toString(),
                          onChanged: ((value) {
                            setState(() {
                              (widget.game as DoodleDash)
                                  .levelManager
                                  .selectLevel(value.toInt());
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
                                  .gameManager
                                  .selectCharacter(character);
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
