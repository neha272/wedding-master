import 'package:flutter/material.dart';

// Color pinkPrimary = const Color(0xffbd3042);
Color white = Colors.white;
Color black = Colors.black;
Color scaffoldBlack = const Color(0xff151516);
Color mediumBlack = const Color(0xff1f2021);
Color lightBlack = const Color(0xff464646);
Color carouselBlack = const Color(0xff1f1f23);
Color eventGrey = const Color(0xff4c4c4c);
Color iconGrey = const Color(0xff6f7375);
Color timeGrey = const Color(0xff2b2b2b);
Color grey = Colors.grey;
Color yellow = const Color(0xffeacc4e);
Color textField = const Color(0xFF242B33);
Color hintText = const Color(0x8F3E4148);
Color hintLightText = const Color(0x413E4148);
Color buttonBg = const Color(0xFF5369FB);

Gradient pink = const LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xfff3686d),
      Color(0xffed2831),
    ]);

Gradient greyToWhite = const LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    // stops: [0.1,0.1],
    colors: [
      Color(0xffdedfe6),
      Color(0xffffffff),
    ]);
Gradient greyToWhiteDiagonal = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [
      0,
      1
    ],
    colors: [
      Color(0xffdedfe6),
      Color(0xffffffff),
    ]);

Gradient blackToBlack = const LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0x2F000000),
      Color(0xff000000),
    ]);
