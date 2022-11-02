import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Palette {
  static const Color spaceMedium = Color.fromARGB(255, 19, 54, 115);
  static const Color spaceLight = Color.fromARGB(255, 44, 109, 183);
  static const Color spaceDark = Color.fromARGB(255, 11, 39, 91);
  static const Color trashCanRed = Color.fromARGB(255, 219, 97, 76);
  static const Color cometTailPurple = Color.fromARGB(255, 153, 113, 179);
  static const Color cometYellow = Color.fromARGB(255, 223, 197, 83);

  static const Color primary = spaceMedium;
  static const Color accent = cometTailPurple;
  static const Color background = spaceDark;
  static const Color active = spaceLight;
  static const Color inactive = spaceMedium;
  static const Color lightText = Colors.white;
  static const Color darkText = Colors.black87;
  static const Color error = trashCanRed;

  // generated from http://mcg.mbitson.com/#!?mcgpalette0=%23133773
  static const MaterialColor primarySwatch =
      MaterialColor(_primarySwatchPrimaryValue, <int, Color>{
    50: Color(0xFFE3E7EE),
    100: Color(0xFFB8C3D5),
    200: Color(0xFF899BB9),
    300: Color(0xFF5A739D),
    400: Color(0xFF365588),
    500: Color(_primarySwatchPrimaryValue),
    600: Color(0xFF11316B),
    700: Color(0xFF0E2A60),
    800: Color(0xFF0B2356),
    900: Color(0xFF061643),
  });
  static const int _primarySwatchPrimaryValue = 0xFF133773;

  static const MaterialColor accentSwatch =
      MaterialColor(primarySwatchAccentValue, <int, Color>{
    100: Color(0xFF7993FF),
    200: Color(primarySwatchAccentValue),
    400: Color(0xFF1341FF),
    700: Color(0xFF0031F8),
  });
  static const int primarySwatchAccentValue = 0xFF466AFF;
}

TextTheme appFontTheme = GoogleFonts.audiowideTextTheme();
