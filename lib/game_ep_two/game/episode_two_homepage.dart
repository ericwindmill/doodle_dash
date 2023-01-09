import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../widgets/game_over_overlay.dart';
import '../widgets/game_overlay.dart';
import '../widgets/main_menu_overlay.dart';
import 'doodle_dash.dart';

class MyHomePageEpisodeTwo extends StatefulWidget {
  const MyHomePageEpisodeTwo({super.key, required this.title});
  final String title;
  @override
  State<MyHomePageEpisodeTwo> createState() => _MyHomePageState();
}

Game game = DoodleDashEp2();

class _MyHomePageState extends State<MyHomePageEpisodeTwo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LayoutBuilder(builder: (context, constraints) {
          return Container(
            constraints: const BoxConstraints(
              // 1000 is arbitrary, should be tweaked (todo eric)
              // 550 is the smallest Chrome will allow you to make the window
              maxWidth: 800,
              minWidth: 550,
            ),
            child: GameWidget(
              // hot reload in development mode,
              game: game,
              overlayBuilderMap: <String, Widget Function(BuildContext, Game)>{
                'gameOverlay': (context, game) => GameOverlay(game),
                'mainMenuOverlay': (context, game) => MainMenuOverlay(game),
                'gameOverOverlay': (context, game) => GameOverOverlay(game),
              },
            ),
          );
        }),
      ),
    );
  }
}
