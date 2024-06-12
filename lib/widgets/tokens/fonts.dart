import 'package:flutter/material.dart';

import 'colors.dart';

class ProjectFonts extends TextStyle{

  const ProjectFonts.headline01(Color color):
    super(fontFamily: 'Roboto',
        fontWeight: FontWeight.w400,
        fontSize: 24.0,
        color: ProjectPalette.neutral2,
        letterSpacing: 0.18);

  static TextStyle headline1 = const TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
    fontSize: 24.0,
    color: ProjectPalette.neutral2,
    letterSpacing: 0.18
  );

  static TextStyle headline2 = const TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w500,
    fontSize: 20.0,
    color: ProjectPalette.neutral2,
    letterSpacing: 0.15
  );

  static TextStyle subtitle1 = const TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
    fontSize: 16.0,
    color: ProjectPalette.neutral2,
    letterSpacing: 0.15
  );

  static TextStyle body1 = const TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
    fontSize: 14.0,
    color: ProjectPalette.neutral2,
    letterSpacing: 0.25
  );

  static TextStyle body2 = const TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
    fontSize: 12.0,
    color: ProjectPalette.neutral2,
    letterSpacing: 0.4
  );

  static TextStyle button = const TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w500,
    fontSize: 14.0,
    color: ProjectPalette.neutral2,
    letterSpacing: 0.1
  );

  static TextStyle caption = const TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
    fontSize: 12.0,
    color: ProjectPalette.neutral2,
    letterSpacing: 0.4
  );

  static TextStyle overline = const TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w500,
    fontSize: 10.0,
    color: ProjectPalette.neutral2,
    letterSpacing: 1.5,
    // height: 1.6
  );
}