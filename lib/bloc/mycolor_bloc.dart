import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:videodown/infrastructure/themes.dart';

enum MyColorEvent { Theme1, Theme2, Theme3 }
enum MyIsTvEvent { isTvTrue, isTvFalse }
enum MyisTermsEvent { isTermsTrue, isTermsFalse }
enum MyIsOldPlayerEvent { isOldPlayerTrue, isOldPlayerFalse }
enum MyDefaultSourceEvent { s0, s1, s2, s3 }
enum MyDefaultInfoApiEvent { i0, i1 }
enum MyBaseUrlEvent { b0, b1, b2, b3, b4, b5, b6, b7 }

/*
https://animeflv.vip/


*/
class MyColorBloc extends Bloc<MyColorEvent, MyThemeClass> {
  MyThemeClass initial = MyThemeClass();
  MyColorBloc() : super(MyThemeClass());
  //MyColorBloc({MyThemeClass initial}) : super(UserRegInitialState()) {userRepository = UserRepository();}
  //MyColorBloc({MyThemeClass initial}) : super(MyThemeClass(themename: MyColorsTheme1.themename));

  @override
  MyThemeClass get initialState => initial;

  SharedPreferences? preferences;
  
  saveTheme(MyThemeClass myColors) async {
    preferences = await SharedPreferences.getInstance();
    preferences!.setString("themename", myColors.themename.toString());
    print("SAVED theme: ${myColors.themename}");
    MyColors().init(myColors);
  }

  @override
  Stream<MyThemeClass> mapEventToState(MyColorEvent event) async* {
    switch (event) {
      case MyColorEvent.Theme1:
        MyThemeClass temp =  MyThemeClass(
          themename: "theme1",
        );
        saveTheme(temp);
        yield temp;
        break;
      case MyColorEvent.Theme2:
        MyThemeClass temp =  MyThemeClass(
            themename: "theme2",
        );
        saveTheme(temp);
        yield temp;
        break;
      case MyColorEvent.Theme3:
        MyThemeClass temp = MyThemeClass(
          themename: MyColors.themename,
        );
        saveTheme(temp);
        yield temp;
        break;
    }
  }
  }



