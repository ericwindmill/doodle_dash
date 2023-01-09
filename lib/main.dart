import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'game/doodle_dash.dart';
import 'game/util/util.dart';
import 'game/widgets/widgets.dart';
import 'game_ep_one/episode_one_homepage.dart';
import 'game_ep_two/game/episode_two_homepage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Doodle Dash',
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        colorScheme: lightColorScheme,
        useMaterial3: true,
        // textTheme: appFontTheme,
      ),
      darkTheme: ThemeData(
        colorScheme: darkColorScheme,
        textTheme: GoogleFonts.audiowideTextTheme(ThemeData.dark().textTheme),
        useMaterial3: true,
      ),
      routerConfig: GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) {
              return const MyHomePage(title: 'DoodleDash');
            },
          ),
          GoRoute(
            path: '/episode_1',
            builder: (context, state) {
              return const MyHomePageEpisodeOne(title: 'DoodleDash');
            },
          ),
          GoRoute(
            path: '/episode_2',
            builder: (context, state) {
              return const MyHomePageEpisodeTwo(title: 'DoodleDash');
            },
          ),
        ],
      ),
    );
  }
}

Game game = DoodleDash();

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
