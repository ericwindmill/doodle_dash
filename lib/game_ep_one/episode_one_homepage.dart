import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'doodle_dash.dart';

class MyHomePageEpisodeOne extends StatefulWidget {
  const MyHomePageEpisodeOne({super.key, required this.title});
  final String title;
  @override
  State<MyHomePageEpisodeOne> createState() => _MyHomePageState();
}

Game game = DoodleDashEp1();

class _MyHomePageState extends State<MyHomePageEpisodeOne> {
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
            ),
          );
        }),
      ),
    );
  }
}
