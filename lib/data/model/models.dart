// import 'package:admost_flutter_plugin/admost.dart';
// import 'package:admost_flutter_plugin/admost_interstitial.dart';
// import 'package:admost_flutter_plugin/admost_rewarded.dart';
// import 'package:admost_flutter_plugin/admost_ad_events.dart';
// import 'package:admost_flutter_plugin/admost_banner.dart';
// import 'package:admost_flutter_plugin/admost_banner_size.dart';
// import 'package:admost_flutter_plugin/admost_banner_controller.dart';
// import 'package:flutter_feather_icons/flutter_feather_icons.dart';
// import 'package:facebook_audience_network/facebook_audience_network.dart';
// import 'package:facebook_audience_network/ad/ad_banner.dart';
// import 'package:facebook_audience_network/ad/ad_native.dart';
//import 'package:firebase_auth/firebase_auth.dart';




class MyIsTvMode {
  static late bool isTvMode;
  void init(MyIsTvClass myTv) async {
    //print("------------------MyIsTvMode init myTv: " + myTv.isTvSet.toString());
    if (myTv.isTvSet!) {
      isTvMode = true;
    } else {
      isTvMode = false;
    }
  }
}

class MyIsTermsMode {
  static late bool isTermsMode;
  void init(MyisTermsClass myterms) async {
    //print("------------------MyIsTermsMode init myTv: " + myTv.IsTermsSet.toString());
    if (myterms.isTermsSet!) {
      isTermsMode = true;
    } else {
      isTermsMode = false;
    }
  }
}

class MyIsOldPlayerMode {
  static late bool isOldPlayerMode;
  void init(MyIsOldPlayerClass myOldPlayer) async {
    //print("------------------MyIsOldPlayerMode init myOldPlayer: " + myOldPlayer.isOldPlayerSet.toString());
    if (myOldPlayer.isOldPlayerSet!) {
      isOldPlayerMode = true;
    } else {
      isOldPlayerMode = false;
    }
  }
}




class MyIsTvClass {
  bool? isTvSet;

  MyIsTvClass({
    this.isTvSet,
  });
}

class MyisTermsClass {
  bool? isTermsSet;

  MyisTermsClass({
    this.isTermsSet,
  });
}

class MyIsOldPlayerClass {
  bool? isOldPlayerSet;

  MyIsOldPlayerClass({
    this.isOldPlayerSet,
  });
}

class MyDefaultSourceClass {
  String? sourcenum;

  MyDefaultSourceClass({
    this.sourcenum,
  });
}

class MyDefaultInfoApiClass {
  String? infoapinum;

  MyDefaultInfoApiClass({
    this.infoapinum,
  });
}

class MyDefaultBaseURLClass {
  String? baseurllink;

  MyDefaultBaseURLClass({
    this.baseurllink,
  });
}

class MyMessagesClass {
  String? msgtoken;

  MyMessagesClass({
    this.msgtoken,
  });
}
