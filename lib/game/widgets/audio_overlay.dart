import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../doodle_dash.dart';

class AudioControl extends StatefulWidget {
  const AudioControl(this.game, {super.key});

  final Game game;

  @override
  State<AudioControl> createState() => _AudioControlState();
}

class _AudioControlState extends State<AudioControl> {
  bool audioOn = false;

  @override
  Widget build(BuildContext context) {
    DoodleDash game = widget.game as DoodleDash;

    return Padding(
      padding: EdgeInsets.all(15),
      child: Align(
        alignment: Alignment.bottomRight,
        child: IconButton(
          onPressed: () {
            setState(() {
              game.audio.toggleSound();
              audioOn = game.audio.audioOn;
            });
          },
          icon: audioOn
              ? const Icon(Icons.volume_up_outlined)
              : const Icon(Icons.volume_off_outlined),
        ),
      ),
    );
  }
}
