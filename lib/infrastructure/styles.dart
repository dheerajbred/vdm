import 'package:flutter/material.dart';
import 'package:videodown/infrastructure/themes.dart';


class MyTexStyle {
  static late TextStyle menu;
  static late TextStyle menusmall;
  static late TextStyle menubold;
  static late TextStyle infobutton;
  static late TextStyle tile;
  static late TextStyle normal;
  static late TextStyle heading;
  static late TextStyle buttonstyle;
  static late TextStyle menubuttonstyle;
  static TextStyle menubuttonstylewhite = const TextStyle(
      fontSize: 17.0,
      color: Colors.white,
      letterSpacing: -0.4,
      decoration: TextDecoration.none);
  static late TextStyle small;
  static TextStyle smallwhite = const TextStyle(
    fontSize: 10,
    color: Colors.white,
    fontWeight: FontWeight.w600,
  );

  void init(MyThemeClass myColors) async {
    if (myColors.themename.toString() == "theme1") {
      menu = TextStyle(
        fontSize: 15,
        color: MyColorsTheme1.opp1,
        fontWeight: FontWeight.w300,
      );
      infobutton = TextStyle(
        fontSize: 12,
        color: MyColorsTheme1.primary1,
        fontWeight: FontWeight.w500,
      );
      tile = TextStyle(
        fontSize: 20,
        color: MyColorsTheme1.opp1,
        fontWeight: FontWeight.w600,
      );
      normal = TextStyle(
        fontSize: 16,
        color: MyColorsTheme1.opp1,
        fontWeight: FontWeight.w300,
      );
      heading = TextStyle(
        fontSize: 23,
        color: MyColorsTheme1.opp1,
        fontWeight: FontWeight.w800,
      );
      buttonstyle = TextStyle(
        fontSize: 13,
        color: MyColorsTheme1.primary1,
        fontWeight: FontWeight.w500,
      );
      menubuttonstyle = TextStyle(
          fontSize: 17.0,
          color: MyColorsTheme1.opp1,
          letterSpacing: -0.4,
          decoration: TextDecoration.none);
      small = TextStyle(
        fontSize: 10,
        color: MyColorsTheme1.opp1,
        fontWeight: FontWeight.w300,
      );
    } else if (myColors.themename.toString() == "theme2") {
      menu = TextStyle(
        fontSize: 15,
        color: MyColorsTheme2.opp1,
        fontWeight: FontWeight.w300,
      );
      infobutton = TextStyle(
        fontSize: 12,
        color: MyColorsTheme2.primary1,
        fontWeight: FontWeight.w500,
      );
      tile = TextStyle(
        fontSize: 20,
        color: MyColorsTheme2.opp1,
        fontWeight: FontWeight.w600,
      );
      normal = TextStyle(
        fontSize: 16,
        color: MyColorsTheme2.opp1,
        fontWeight: FontWeight.w300,
      );
      heading = TextStyle(
        fontSize: 23,
        color: MyColorsTheme2.opp1,
        fontWeight: FontWeight.w800,
      );
      buttonstyle = TextStyle(
        fontSize: 13,
        color: MyColorsTheme2.primary1,
        fontWeight: FontWeight.w500,
      );
      menubuttonstyle = TextStyle(
          fontSize: 17.0,
          color: MyColorsTheme2.opp1,
          letterSpacing: -0.4,
          decoration: TextDecoration.none);
      small = TextStyle(
        fontSize: 10,
        color: MyColorsTheme2.opp1,
        fontWeight: FontWeight.w300,
      );
    }
  }
}