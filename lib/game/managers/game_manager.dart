import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../doodle_dash.dart';

class GameManager extends Component with HasGameRef<DoodleDash> {
  GameManager();

  Character character = Character.dash;
  ValueNotifier<int> score = ValueNotifier(0);
  GameState state = GameState.intro;

  bool get isPlaying => state == GameState.playing;
  bool get isGameOver => state == GameState.gameOver;
  bool get isIntro => state == GameState.intro;

  void reset() {
    score.value = 0;
    state = GameState.intro;
  }

  void increaseScore() {
    score.value++;
  }

  void selectCharacter(Character selectedCharacter) {
    character = selectedCharacter;
  }
}

enum GameState { intro, playing, gameOver }
