import 'package:flutter/material.dart';

import 'colors.dart';

class ProjectFonts extends TextStyle{

  ProjectFonts.headline01(Color color):
    super(fontFamily: 'Roboto',
        fontWeight: FontWeight.w400,
        fontSize: 24.0,
        color: ProjectPallette.neutral2,
        letterSpacing: 0.18);

  static TextStyle headline1 = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
    fontSize: 24.0,
    color: ProjectPallette.neutral2,
    letterSpacing: 0.18
  );

  static TextStyle headline2 = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w500,
    fontSize: 20.0,
    color: ProjectPallette.neutral2,
    letterSpacing: 0.15
  );

  static TextStyle subtitle1 = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
    fontSize: 16.0,
    color: ProjectPallette.neutral2,
    letterSpacing: 0.15
  );

  static TextStyle body1 = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
    fontSize: 14.0,
    color: ProjectPallette.neutral2,
    letterSpacing: 0.25
  );

  static TextStyle body2 = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
    fontSize: 12.0,
    color: ProjectPallette.neutral2,
    letterSpacing: 0.4
  );

  static TextStyle button = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w500,
    fontSize: 14.0,
    color: ProjectPallette.neutral2,
    letterSpacing: 0.1
  );

  static TextStyle caption = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
    fontSize: 12.0,
    color: ProjectPallette.neutral2,
    letterSpacing: 0.4
  );

  static TextStyle overline = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w500,
    fontSize: 10.0,
    color: ProjectPallette.neutral2,
    letterSpacing: 1.5,
    // height: 1.6
  );
}