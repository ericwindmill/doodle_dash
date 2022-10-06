import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'game/doodle_dash.dart';
import 'widgets/game_over_overlay.dart';
import 'widgets/game_overlay.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doodle Dash',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Doodle Dash'),
    );
  }
}

final Game game = DoodleDash();

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GameWidget(
          // hot reload in development mode,
          game: kReleaseMode ? game : DoodleDash(),
          overlayBuilderMap: <String, Widget Function(BuildContext, Game)>{
            'gameOverlay': (_, game) => GameOverlay(game),
            // 'mainMenu': (context, game) => Container(),
            // 'pauseOverlay': (context, game) => Container(),
            'gameOverOverlay': (context, game) => GameOverOverlay(),
          },
        ),
      ),
    );
  }
}
