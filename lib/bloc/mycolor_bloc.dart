import 'dart:math';
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/rendering.dart';
import 'package:videodown/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    print("SAVED theme: " + myColors.themename.toString());
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





/*
class MyisTvBloc extends Bloc<MyIsTvEvent, MyIsTvClass> {
  MyIsTvClass initial;
  MyisTvBloc(this.initial);

  @override
  MyIsTvClass get initialState => initial;

  SharedPreferences preferences;

  saveTheme(MyIsTvClass myistv) async {
    preferences = await SharedPreferences.getInstance();
    preferences.setBool("myIsTv", myistv.isTvSet);
    print("SAVED theme: myistv : " + myistv.isTvSet.toString());
    print("MyIsTvMode.isTvMode : " + MyIsTvMode.isTvMode.toString());
  }

  @override
  Stream<MyIsTvClass> mapEventToState(MyIsTvEvent event) async* {
    switch (event) {
      case MyIsTvEvent.isTvTrue:
        MyIsTvClass temp = MyIsTvClass(isTvSet: true);
        saveTheme(temp);
        yield temp;
        break;
      case MyIsTvEvent.isTvFalse:
        MyIsTvClass temp = MyIsTvClass(isTvSet: false);
        saveTheme(temp);
        yield temp;
        break;
    }
  }
}

class MyisTermsBloc extends Bloc<MyisTermsEvent, MyisTermsClass> {
  MyisTermsClass initial;
  MyisTermsBloc(this.initial);

  @override
  MyisTermsClass get initialState => initial;

  SharedPreferences preferences;

  saveTheme(MyisTermsClass MyisTerms) async {
    preferences = await SharedPreferences.getInstance();
    preferences.setBool("MyisTerms", MyisTerms.isTermsSet);
    print("SAVED theme: MyisTerms : " + MyisTerms.isTermsSet.toString());
    print("MyisTermsMode.isTvMode : " + MyIsTermsMode.isTermsMode.toString());
  }

  @override
  Stream<MyisTermsClass> mapEventToState(MyisTermsEvent event) async* {
    switch (event) {
      case MyisTermsEvent.isTermsTrue:
        MyisTermsClass temp = MyisTermsClass(isTermsSet: true);
        saveTheme(temp);
        yield temp;
        break;
      case MyisTermsEvent.isTermsFalse:
        MyisTermsClass temp = MyisTermsClass(isTermsSet: false);
        saveTheme(temp);
        yield temp;
        break;
    }
  }
}

class MyisOldPlayerBloc extends Bloc<MyIsOldPlayerEvent, MyIsOldPlayerClass> {
  MyIsOldPlayerClass initial;
  MyisOldPlayerBloc(this.initial);

  @override
  MyIsOldPlayerClass get initialState => initial;

  SharedPreferences preferences;

  saveTheme(MyIsOldPlayerClass myisOldPlayer) async {
    preferences = await SharedPreferences.getInstance();
    preferences.setBool("myIsOldPlayer", myisOldPlayer.isOldPlayerSet);
    print("SAVED theme: myisOldPlayer : " +
        myisOldPlayer.isOldPlayerSet.toString());
    print("MyIsOldPlayerMode.isOldPlayerMode : " +
        MyIsOldPlayerMode.isOldPlayerMode.toString());
  }

  @override
  Stream<MyIsOldPlayerClass> mapEventToState(MyIsOldPlayerEvent event) async* {
    switch (event) {
      case MyIsOldPlayerEvent.isOldPlayerTrue:
        MyIsOldPlayerClass temp = MyIsOldPlayerClass(isOldPlayerSet: true);
        saveTheme(temp);
        yield temp;
        break;
      case MyIsOldPlayerEvent.isOldPlayerFalse:
        MyIsOldPlayerClass temp = MyIsOldPlayerClass(isOldPlayerSet: false);
        saveTheme(temp);
        yield temp;
        break;
    }
  }
}

class MyDefaultSourceBloc
    extends Bloc<MyDefaultSourceEvent, MyDefaultSourceClass> {
  MyDefaultSourceClass ini;
  MyDefaultSourceBloc(this.ini);

  @override
  MyDefaultSourceClass get initialState => ini;

  SharedPreferences preferences;

  saveTheme(MyDefaultSourceClass myNum) async {
    preferences = await SharedPreferences.getInstance();
    preferences.setString("sourcenum", myNum.sourcenum.toString());
    print("SAVED source: " + myNum.sourcenum.toString());
  }

  @override
  Stream<MyDefaultSourceClass> mapEventToState(
      MyDefaultSourceEvent event) async* {
    switch (event) {
      case MyDefaultSourceEvent.s0:
        MyDefaultSourceClass temp = MyDefaultSourceClass(
          sourcenum: "0",
        );
        saveTheme(temp);
        yield temp;
        break;
      case MyDefaultSourceEvent.s1:
        MyDefaultSourceClass temp = MyDefaultSourceClass(
          sourcenum: "1",
        );
        saveTheme(temp);
        yield temp;
        break;
      case MyDefaultSourceEvent.s2:
        MyDefaultSourceClass temp = MyDefaultSourceClass(
          sourcenum: "2",
        );
        saveTheme(temp);
        yield temp;
        break;
      case MyDefaultSourceEvent.s3:
        MyDefaultSourceClass temp = MyDefaultSourceClass(
          sourcenum: "3",
        );
        saveTheme(temp);
        yield temp;
        break;
    }
  }
}

class MyDefaultInfoApiBloc
    extends Bloc<MyDefaultInfoApiEvent, MyDefaultInfoApiClass> {
  MyDefaultInfoApiClass ini;
  MyDefaultInfoApiBloc(this.ini);

  @override
  MyDefaultInfoApiClass get initialState => ini;

  SharedPreferences preferences;

  saveTheme(MyDefaultInfoApiClass myNum) async {
    preferences = await SharedPreferences.getInstance();
    preferences.setString("infoapinum", myNum.infoapinum.toString());
    print("SAVED infoapinum: " + myNum.infoapinum.toString());
  }

  @override
  Stream<MyDefaultInfoApiClass> mapEventToState(
      MyDefaultInfoApiEvent event) async* {
    switch (event) {
      case MyDefaultInfoApiEvent.i0:
        MyDefaultInfoApiClass temp = MyDefaultInfoApiClass(
          infoapinum: "0",
        );
        saveTheme(temp);
        yield temp;
        break;
      case MyDefaultInfoApiEvent.i1:
        MyDefaultInfoApiClass temp = MyDefaultInfoApiClass(
          infoapinum: "1",
        );
        saveTheme(temp);
        yield temp;
        break;
    }
  }
}

class MyBaseUrlBloc extends Bloc<MyBaseUrlEvent, MyDefaultBaseURLClass> {
  MyDefaultBaseURLClass ini;
  MyBaseUrlBloc(this.ini);

  @override
  MyDefaultBaseURLClass get initialState => ini;

  SharedPreferences preferences;

  saveTheme(MyDefaultBaseURLClass myBase) async {
    preferences = await SharedPreferences.getInstance();
    preferences.setString("baseurllink", myBase.baseurllink.toString());
    print("SAVED baseurllink: " + myBase.baseurllink.toString());
  }

  @override
  Stream<MyDefaultBaseURLClass> mapEventToState(MyBaseUrlEvent event) async* {
    switch (event) {
      case MyBaseUrlEvent.b0:
        MyDefaultBaseURLClass temp = MyDefaultBaseURLClass(
          //baseurllink: "https://gogoanime.video/",
          baseurllink: "b0",
        );
        saveTheme(temp);
        yield temp;
        break;
      case MyBaseUrlEvent.b1:
        MyDefaultBaseURLClass temp = MyDefaultBaseURLClass(
          //baseurllink: "https://www9.gogoanime.io/",
          baseurllink: "b1",
        );
        saveTheme(temp);
        yield temp;
        break;
      case MyBaseUrlEvent.b2:
        MyDefaultBaseURLClass temp = MyDefaultBaseURLClass(
            //baseurllink: "https://gogoanime.tv/"
            baseurllink: "b2");
        saveTheme(temp);
        yield temp;
        break;
      case MyBaseUrlEvent.b3:
        MyDefaultBaseURLClass temp = MyDefaultBaseURLClass(
          //baseurllink: "https://gogoanimetv.io/",
          baseurllink: "b3",
        );
        saveTheme(temp);
        yield temp;
        break;
      case MyBaseUrlEvent.b4:
        MyDefaultBaseURLClass temp = MyDefaultBaseURLClass(
          //baseurllink: "https://gogoanime.tv/",
          baseurllink: "b4",
        );
        saveTheme(temp);
        yield temp;
        break;
      case MyBaseUrlEvent.b5:
        MyDefaultBaseURLClass temp = MyDefaultBaseURLClass(
          //baseurllink: "https://gogoanime.tv/",
          baseurllink: "b5",
        );
        saveTheme(temp);
        yield temp;
        break;
      case MyBaseUrlEvent.b6:
        MyDefaultBaseURLClass temp = MyDefaultBaseURLClass(
          //baseurllink: "https://gogoanime.tv/",
          baseurllink: "b6",
        );
        saveTheme(temp);
        yield temp;
        break;
      case MyBaseUrlEvent.b7:
        MyDefaultBaseURLClass temp = MyDefaultBaseURLClass(
          //baseurllink: "https://gogoanime.tv/",
          baseurllink: "b7",
        );
        saveTheme(temp);
        yield temp;
        break;
    }
  }
}
*/
/*
class MyMessagesBloc extends Bloc<MyBaseUrlEvent, MyDefaultBaseURLClass> {
  MyDefaultBaseURLClass ini;
  MyMessagesBloc(this.ini);

  @override
  MyDefaultBaseURLClass get initialState => ini;

  SharedPreferences preferences;
  
  saveTheme(MyDefaultBaseURLClass myBase) async {
    preferences = await SharedPreferences.getInstance();
    preferences.setString("baseurllink", myBase.baseurllink.toString());
    print("SAVED baseurllink: " + myBase.baseurllink.toString());
  }

  @override
  Stream<MyDefaultBaseURLClass> mapEventToState(MyBaseUrlEvent event) async* {
    switch (event) {
      case MyBaseUrlEvent.b0:
        MyDefaultBaseURLClass temp =  MyDefaultBaseURLClass(
          //baseurllink: "https://gogoanime.video/",
          baseurllink: "b0",
        );
        saveTheme(temp);
        yield temp;
        break;
      case MyBaseUrlEvent.b1:
        MyDefaultBaseURLClass temp =  MyDefaultBaseURLClass(
          //baseurllink: "https://www9.gogoanime.io/",
          baseurllink: "b1",
        );
        saveTheme(temp);
        yield temp;
        break;
      case MyBaseUrlEvent.b2:
        MyDefaultBaseURLClass temp =  MyDefaultBaseURLClass(
          //baseurllink: "https://gogoanime.tv/"
          baseurllink: "b2"
        );
        saveTheme(temp);
        yield temp;
        break;
      case MyBaseUrlEvent.b3:
        MyDefaultBaseURLClass temp =  MyDefaultBaseURLClass(
          //baseurllink: "https://gogoanimetv.io/",
          baseurllink: "b3",
        );
        saveTheme(temp);
        yield temp;
        break;
      case MyBaseUrlEvent.b4:
        MyDefaultBaseURLClass temp =  MyDefaultBaseURLClass(
          //baseurllink: "https://gogoanime.tv/",
          baseurllink: "b4",
        );
        saveTheme(temp);
        yield temp;
        break;
    }
  }
}
*/
