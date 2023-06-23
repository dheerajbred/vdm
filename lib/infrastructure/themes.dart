import 'package:flutter/material.dart';

class MyThemeClass {
  String? themename;

  MyThemeClass({
    this.themename,
  });
}

class MyColorsTheme1 {
  static Color primary1 = const Color.fromRGBO(17, 17, 17, 1);
  static Color primary2 = const Color.fromRGBO(10, 10, 10, 1);
  static Color primary3 = const Color.fromRGBO(27, 27, 27, 1);
  static Color opp1 = const Color.fromRGBO(255, 255, 255, 1);
  //static Color reddy = Colors.red;
  static Color reddy = const Color.fromRGBO(220, 25, 25, 1);
  //  static Color reddy = Color(0xFFFFFB00);
  //reddy = Color.fromRGBO(248, 231, 2, 1);
  //reddy = Color.fromRGBO(100, 100, 255, 1);
  static Color? purp = Colors.purpleAccent[400];

  static int numb = 11111;
  static String themename = "theme1";
}

class MyColorsTheme2 {
  static Color primary1 = const Color.fromRGBO(248, 248, 248, 1);
  static Color primary2 = const Color.fromRGBO(225, 225, 225, 1);
  static Color primary3 = const Color.fromRGBO(255, 255, 255, 1);
  static Color opp1 = const Color.fromRGBO(0, 0, 0, 1);
  static Color reddy = const Color.fromRGBO(220, 25, 25, 1);
  static Color? purp = Colors.purpleAccent[400];

  static int numb = 55555555;
  static String themename = "theme2";
}

class MyColors {
  static late Color primary1;
  static late Color primary2;
  static late Color primary3;
  static late Color opp1;
  static late Color reddy;
  static late Color purp;

  static late int numb;
  static late String themename;

  void init(MyThemeClass myTheme) async {
    print("--------myTheme.themename.toString(): ${myTheme.themename}");

    if (myTheme.themename.toString() == "theme1") {
      primary1 = MyColorsTheme1.primary1;
      primary2 = MyColorsTheme1.primary2;
      primary3 = MyColorsTheme1.primary3;
      opp1 = MyColorsTheme1.opp1;
      reddy = MyColorsTheme1.reddy;
      //reddy = Color.fromRGBO(248, 231, 2, 1);
      //reddy = Color.fromRGBO(100, 100, 255, 1);
      purp = MyColorsTheme1.purp!;

      numb = MyColorsTheme1.numb;
      themename = MyColorsTheme1.themename;
    } else if (myTheme.themename.toString() == "theme2") {
      primary1 = MyColorsTheme2.primary1;
      primary2 = MyColorsTheme2.primary2;
      //primary3 = Color.fromRGBO(240, 240,240, 1);
      primary3 = MyColorsTheme2.primary3;
      opp1 = MyColorsTheme2.opp1;
      reddy = MyColorsTheme2.reddy;
      purp = MyColorsTheme2.purp!;

      numb = MyColorsTheme2.numb;
      themename = MyColorsTheme2.themename;
    }
  }
}


