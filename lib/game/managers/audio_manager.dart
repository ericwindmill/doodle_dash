import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';

import '../doodle_dash.dart';

class AudioManager extends Component with HasGameRef<DoodleDash> {
  AudioManager();

  initialize() async {
    await FlameAudio.audioCache.loadAll([
      'broken_platform.mp3',
      'enemy.mp3',
      'game_over.mp3',
      'noogler_hat.mp3',
      'normal_platform.mp3',
      'rocket.mp3',
      'start_game.mp3',
      'trampoline.mp3',
      'trashcan_death.mp3',
      'underscore.mp3',
    ]);

    FlameAudio.bgm.initialize();
  }

  bool audioOn = false;

  void play(String audioFile) {
    if (audioOn) FlameAudio.play(audioFile);
  }

  void toggleSound() {
    audioOn = !audioOn;

    switch (audioOn) {
      case true:
        playBgmMusic();
      case false:
        FlameAudio.bgm.stop();
    }
  }

  void playBgmMusic() {
    FlameAudio.bgm.play('underscore.mp3');
  }
}
