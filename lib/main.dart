import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'game/doodle_dash.dart';
import 'util/theme.dart';
import 'widgets/game_over_overlay.dart';
import 'widgets/game_overlay.dart';
import 'widgets/main_menu_overlay.dart';
import 'util/color_schemes.dart';

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
        colorScheme: darkColorScheme,
        textTheme: appFontTheme,
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
          game: game,
          overlayBuilderMap: <String, Widget Function(BuildContext, Game)>{
            'gameOverlay': (context, game) => GameOverlay(game),
            'mainMenuOverlay': (context, game) => MainMenuOverlay(game),
            'gameOverOverlay': (context, game) => GameOverOverlay(game),
          },
        ),
      ),
    );
  }
}
