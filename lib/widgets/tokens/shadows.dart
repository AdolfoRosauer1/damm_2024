import 'package:flutter/material.dart';

class ProjectShadows{
  static List<BoxShadow> shadow1 = const [
    BoxShadow(
    color: Color(0x00000026),
    offset: Offset(0, 1),
    blurRadius: 3,
    spreadRadius: 1,
  ),
  BoxShadow(
    color: Color(0x0000004D),
    offset: Offset(0, 1),
    blurRadius: 2,
    spreadRadius: 0,
  )];
  static List<BoxShadow> shadow2 = const [
    BoxShadow(
    color: Color(0x00000026),
    offset: Offset(0, 2),
    blurRadius: 6,
    spreadRadius: 2,
  ),
  BoxShadow(
    color: Color(0x0000004D),
    offset: Offset(0, 1),
    blurRadius: 2,
    spreadRadius: 0,
  )];

  static List<BoxShadow> shadow3 = const [
    BoxShadow(
    color: Color(0x0000004D),
    offset: Offset(0, 4),
    blurRadius: 4,
    spreadRadius: 1,
  ),
  BoxShadow(
    color: Color(0x00000026),
    offset: Offset(0, 8),
    blurRadius: 12,
    spreadRadius: 6,
  )];


}