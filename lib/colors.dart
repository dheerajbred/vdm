import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
// import 'package:admost_flutter_plugin/admost.dart';
// import 'package:admost_flutter_plugin/admost_interstitial.dart';
// import 'package:admost_flutter_plugin/admost_rewarded.dart';
// import 'package:admost_flutter_plugin/admost_ad_events.dart';
// import 'package:admost_flutter_plugin/admost_banner.dart';
// import 'package:admost_flutter_plugin/admost_banner_size.dart';
// import 'package:admost_flutter_plugin/admost_banner_controller.dart';
// import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter/cupertino.dart';
// import 'package:facebook_audience_network/facebook_audience_network.dart';
// import 'package:facebook_audience_network/ad/ad_banner.dart';
// import 'package:facebook_audience_network/ad/ad_native.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:http/io_client.dart';
import 'package:flash/flash.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'package:videodownloader/videodownloader.dart';
import 'package:get/get.dart';
import 'package:videodown/downloads_database.dart';
import 'package:flutter_adcel/flutter_adcel.dart';

int adsworking = 1;

class MyColorsTheme1 {
  static Color primary1 = Color.fromRGBO(17, 17, 17, 1);
  static Color primary2 = Color.fromRGBO(10, 10, 10, 1);
  static Color primary3 = Color.fromRGBO(27, 27, 27, 1);
  static Color opp1 = Color.fromRGBO(255, 255, 255, 1);
  //static Color reddy = Colors.red;
  static Color reddy = Color.fromRGBO(220, 25, 25, 1);
  //  static Color reddy = Color(0xFFFFFB00);
  //reddy = Color.fromRGBO(248, 231, 2, 1);
  //reddy = Color.fromRGBO(100, 100, 255, 1);
  static Color? purp = Colors.purpleAccent[400];

  static int numb = 11111;
  static String themename = "theme1";
}

class MyColorsTheme2 {
  static Color primary1 = Color.fromRGBO(248, 248, 248, 1);
  static Color primary2 = Color.fromRGBO(225, 225, 225, 1);
  static Color primary3 = Color.fromRGBO(255, 255, 255, 1);
  static Color opp1 = Color.fromRGBO(0, 0, 0, 1);
  static Color reddy = Color.fromRGBO(220, 25, 25, 1);
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
    print("--------myTheme.themename.toString(): " +
        myTheme.themename.toString());

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
  static late TextStyle menubuttonstylewhite = TextStyle(
      fontSize: 17.0,
      color: Colors.white,
      letterSpacing: -0.4,
      decoration: TextDecoration.none);
  static late TextStyle small;
  static late TextStyle smallwhite = TextStyle(
    fontSize: 10,
    color: Colors.white,
    fontWeight: FontWeight.w600,
  );

  void init(MyThemeClass myColors) async {
    if (myColors.themename.toString() == "theme1") {
      menu = new TextStyle(
        fontSize: 15,
        color: MyColorsTheme1.opp1,
        fontWeight: FontWeight.w300,
      );
      infobutton = new TextStyle(
        fontSize: 12,
        color: MyColorsTheme1.primary1,
        fontWeight: FontWeight.w500,
      );
      tile = new TextStyle(
        fontSize: 20,
        color: MyColorsTheme1.opp1,
        fontWeight: FontWeight.w600,
      );
      normal = new TextStyle(
        fontSize: 16,
        color: MyColorsTheme1.opp1,
        fontWeight: FontWeight.w300,
      );
      heading = new TextStyle(
        fontSize: 23,
        color: MyColorsTheme1.opp1,
        fontWeight: FontWeight.w800,
      );
      buttonstyle = new TextStyle(
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
      menu = new TextStyle(
        fontSize: 15,
        color: MyColorsTheme2.opp1,
        fontWeight: FontWeight.w300,
      );
      infobutton = new TextStyle(
        fontSize: 12,
        color: MyColorsTheme2.primary1,
        fontWeight: FontWeight.w500,
      );
      tile = new TextStyle(
        fontSize: 20,
        color: MyColorsTheme2.opp1,
        fontWeight: FontWeight.w600,
      );
      normal = new TextStyle(
        fontSize: 16,
        color: MyColorsTheme2.opp1,
        fontWeight: FontWeight.w300,
      );
      heading = new TextStyle(
        fontSize: 23,
        color: MyColorsTheme2.opp1,
        fontWeight: FontWeight.w800,
      );
      buttonstyle = new TextStyle(
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

class MyCommonConstants {
  static late String defaultSource;
  void initDefaultSource(MyDefaultSourceClass mySource) async {
    if (mySource.sourcenum.toString() == "0") {
      defaultSource = "0";
    } else if (mySource.sourcenum.toString() == "1") {
      defaultSource = "1";
    } else if (mySource.sourcenum.toString() == "2") {
      defaultSource = "2";
    } else if (mySource.sourcenum.toString() == "3") {
      defaultSource = "3";
    }
  }

  static late String defaultinfoapi;
  void initDefaultapiinfo(MyDefaultInfoApiClass myapiinfo) async {
    if (myapiinfo.infoapinum.toString() == "0") {
      defaultinfoapi = "0";
    } else if (myapiinfo.infoapinum.toString() == "1") {
      defaultinfoapi = "1";
    }
  }

  /*static String undefined = "Undefined";
  static String running = "Running";
  static String paused = "Paused";
  static String complete = "Complete";
  static String canceled = "Canceled";
  static String failed = "Failed";*/

  static String downloadDefault = 'default';
  static String downloadPrepare = 'prepare';
  static String downloadPending = 'pending';
  static String downloadDownloading = 'downloading';
  static String downloadStart = 'start';
  static String downloadSuccess = 'success';
  static String downloadError = 'error';
  static String downloadEnospc = 'enospc';
  static String downloadPause = 'pause';
  static String downloadproxyready = 'proxyready';

  static String downloadManagerNormal = "DownloadManagerNormal";
  static String m3u8Downloader = "m3u8Downloader";

/*

/////////*************CLONE**************////////////////
https://gogoanime.123unblock.fun/
https://gogoanime.mrunlock.space/
http://rc84reg2.com/
https://gogoanimes.info/
https://www1.gogo-anime.ac
https://animesgogo.com/
http://mediterraneotaste.net/
https://decorfooriass.com/
http://qshazj.com
http://viphookuplocators1.com/

/////////*************SOURCE**************////////////////
https://www7.watchseries.fm
https://www11.gogoanimehub.com/
https://gogoanimeplay.net/
https://www3.gogoanime.pro

https://gogoanimetv.to/
https://ww.gogoanimes.org/
*/

  static String sb0 = "https://www2.gogoanime.video/";
  static String sb1 = "https://gogoanime.so/";
  static String sb2 = "https://www25.gogoanimes.tv/";
  static String sb3 = "https://www8.gogoanimehub.tv/";
  static String sb4 = "https://ww.gogoanimes.org/";
  static String sb5 = "https://gogoanimetv.io/";
  static String sb6 = "https://gogoanimetv.cc/";
  static String sb7 = "https://www1.gogoanimes.info/";

  static String serType1 = "Type1";
  static String serType2 = "Type2";

  static late String defaultBaseURL;
  static late String serverType;

  void initDefaultBaseURL(MyDefaultBaseURLClass myBaseURL) async {
    if (myBaseURL.baseurllink.toString() == "b0") {
      defaultBaseURL = sb0;
    } else if (myBaseURL.baseurllink.toString() == "b1") {
      defaultBaseURL = sb1;
    } else if (myBaseURL.baseurllink.toString() == "b2") {
      defaultBaseURL = sb2;
    } else if (myBaseURL.baseurllink.toString() == "b3") {
      defaultBaseURL = sb3;
    } else if (myBaseURL.baseurllink.toString() == "b4") {
      defaultBaseURL = sb4;
    } else if (myBaseURL.baseurllink.toString() == "b5") {
      defaultBaseURL = sb5;
    } else if (myBaseURL.baseurllink.toString() == "b6") {
      defaultBaseURL = sb6;
    } else if (myBaseURL.baseurllink.toString() == "b7") {
      defaultBaseURL = sb7;
    }

    if (MyCommonConstants.defaultBaseURL == MyCommonConstants.sb0 ||
        MyCommonConstants.defaultBaseURL == MyCommonConstants.sb1 ||
        MyCommonConstants.defaultBaseURL == MyCommonConstants.sb2 ||
        MyCommonConstants.defaultBaseURL == MyCommonConstants.sb3 ||
        MyCommonConstants.defaultBaseURL == MyCommonConstants.sb4) {
      serverType = serType1;
    } else {
      serverType = serType2;
    }
    //print("*****defaultBaseURL****::::::::;" + defaultBaseURL);
  }

  static String serverchildrens0 = "Vid";
  static String serverchildrens1 = "SO";
  static String serverchildrens2 = "TV";
  static String serverchildrens3 = "HubTV";
  static String serverchildrens4 = "Org";
  static String serverchildrens5 = "TvIO";
  static String serverchildrens6 = "TvCC";
  static String serverchildrens7 = "Info";

  void launchRateUs() async {
    launch('https://kutt.it/VDM2_KZv8k4');
  }

  static const platformid = const MethodChannel("IronSourceAdBridge");

  Future<void> addToVideoToDatabase(
    String name,
    String videoUrl,
    String thunmbnaillink,
    String isgrabbed,
    String headers,
  ) async {
    if (name.trim().isEmpty) {
      name = videoUrl
          .trim()
          .split('/')
          .last
          .trim()
          .replaceAll('.mp4', '')
          .replaceAll('.MP4', '')
          .replaceAll('.mov', '')
          .replaceAll('.MOV', '')
          .replaceAll('.flv', '')
          .replaceAll('.FLV', '')
          .replaceAll('.mkv', '')
          .replaceAll('.MKV', '')
          .replaceAll('.m3u8', '')
          .replaceAll('.M3U8', '');
    }
    if (thunmbnaillink.trim().isNotEmpty) {
      final response = await http.get(Uri.parse(thunmbnaillink.trim()));
      if (response.statusCode == 200) {
      } else {
        thunmbnaillink = 'EMPTY';
      }
    } else {
      thunmbnaillink = 'EMPTY';
    }

    DownloadDatabase db = DownloadDatabase();
    List<DownloadEpisodelist> downloadEpisodelist = [];
    List<Map<String, dynamic>> tmplinkmap = [];
    var dir = await getExternalStorageDirectory();
    var dirloc = "${dir!.path}/AnimePrime/";
    print("isgrabbed: " + isgrabbed);
    tmplinkmap.add({
      "videoname": name,
      "videourl": videoUrl,
      "localurl": dirloc + name + ".mp4",
      "imageurl": thunmbnaillink,
      'isgrabbed': (isgrabbed != '') ? '1' : '0',
      "downloadertype": MyCommonConstants.m3u8Downloader,
      'headers': headers.trim(),
      //"localname": "AnimeName" + " " + "EpisodeNumber" + " " + "ServerName" + " " + "Quality" + "Extention"
    });

    var tmpson = json.encode(tmplinkmap);
    downloadEpisodelist = (json.decode(tmpson) as List)
        .map((data) => new DownloadEpisodelist.fromJson(data))
        .toList();

    print("downloadEpisodelist------------- " +
        downloadEpisodelist.first.isgrabbed.toString());

    /*try {
                                              db.deleteMovie(downloadState.videoname);
                                            } catch (e) {
                                              print('---------------------no delete available');
                                            }*/
    DownloadEpisodelist downloadState = downloadEpisodelist.first;
    print("---video downloadState.videoname: " +
        downloadState.videoname.toString());
    print("---video downloadState.videourl: " +
        downloadState.videourl.toString());
    //print("---video downloadState.localname: " + downloadState.localname.toString());
    List<DownloadEpisodelist> filteredEpisodes = await db.getMovies();
    bool isExists = false;
    for (var i = 0; i < filteredEpisodes.length; i++) {
      if (filteredEpisodes[i].videoname == downloadState.videoname) {
        db.updateMovie(downloadState);
        print("---update success");
        isExists = true;
      }
    }
    try {
      if (!isExists) {
        db.addMovie(downloadState);
        print("---add success");
      }
      // SystemNavigator.pop();
      // Get.back();
      /*Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Downloader(
                                              title: "Downloads",
                                            ),
                                          ));*/
    } catch (e) {
      if (!isExists) {
        db.addMovie(downloadState);
        print("---add success");
      }
      // Get.back();
      /*Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Downloader(
                                              title: "Downloads",
                                            ),
                                          ));*/
      print('-----------------------adVideoToDatabase trying again');
    }
  }

  void setSystemUI() {
    print("----------MyColors setSystemUI ");
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      //statusBarColor: MyColors.opp1,
      systemNavigationBarColor: MyColors.primary1,
      systemNavigationBarIconBrightness:
          (MyColors.themename == MyColorsTheme1.themename)
              ? Brightness.light
              : Brightness.dark,
      statusBarIconBrightness: (MyColors.themename == MyColorsTheme1.themename)
          ? Brightness.light
          : Brightness.dark,
    ));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp
    ]);
  }

  String getQuality(String videoname) {
    String qua;
    try {
      qua = videoname
          .toString()
          .split("_")[videoname.toString().split("_").length - 1]
          .split(")")[1]
          .split(".")[0]
          .trim();

      // if(qua.isEmpty){
      //   qua = videoname;
      // }
    } catch (e) {
      qua = 'EMPTY';
    }

    return qua;
  }

  String getEpisodeNumber(String videoname) {
    String qua;
    try {
      qua = videoname
          .toString()
          .split("_")[videoname.toString().split("_").length - 1]
          .split("(")[1]
          .split(")")[0]
          .replaceAll("-", " ")
          .trim();

      // if(qua.isEmpty){
      //   qua = videoname;
      // }
    } catch (e) {
      qua = 'EMPTY';
    }
    return qua;
  }

  String getTitleName(String videoname) {
    String qua;
    try {
      qua = videoname
          .toString()
          .replaceAll(
              videoname
                  .toString()
                  .split("_")[videoname.toString().split("_").length - 1],
              "")
          .replaceAll("_", " ")
          .trim();
      if (qua.isEmpty) {
        qua = videoname;
      }
    } catch (e) {
      qua = 'EMPTY';
    }

    return qua;
  }

  Future<void> showDemoDialog<T>(
      {BuildContext? context, Widget? child, bool? barrierDismissible}) async {
    showDialog<T>(
      barrierDismissible: barrierDismissible!,
      context: context!,
      builder: (context) => Shortcuts(shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent()
      }, child: child!),
    );
  }

  void playVideoPlayer(List<DownloadEpisodelist> downloadEpisodelist,
      int downloadEpisodelistInt, context) async {
    MethodChannel platformcannel = const MethodChannel('IronSourceAdBridge');
    print(
        "playmethod: " + downloadEpisodelist[downloadEpisodelistInt].videourl);
    platformcannel.invokeMethod(
      'playmethod',
      downloadEpisodelist[downloadEpisodelistInt].videourl,
    );

    /*if(MyIsOldPlayerMode.isOldPlayerMode && !MyIsTvMode.isTvMode){
          platformcannel.invokeMethod('playmethod',downloadEpisodelist[downloadEpisodelistInt].videourl,);
        }
        else{
        Navigator.push(context,MaterialPageRoute(builder: (context) => MyAsmVideoPlayer(downloadEpisodelist: downloadEpisodelist, downloadEpisodelistInt: downloadEpisodelistInt,),),);
        }    */
  }

  void directPlayVideoPlayer(String videoUrl, String videoName, context) async {
    MethodChannel platformcannel = const MethodChannel('IronSourceAdBridge');
    platformcannel.invokeMethod(
      'playmethod',
      videoUrl,
    );
    /*if(MyIsOldPlayerMode.isOldPlayerMode && !MyIsTvMode.isTvMode){
        platformcannel.invokeMethod('playmethod',videoUrl,);
        }
        else{
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => MyAsmVideoPlayer(videoUrl: videoUrl, videoName: videoName, referredBy: "Downloads",),),);
        }   */
  }

  void videoAd(int index) async {
    if (adsworking == 1) {
      if (index == 9999) {
        ////////////////////load ads
      } else if (index == 1) {
        ////////////////////rewarded
        print('MyCommonConstants rewardedAd() /////////////////////////////');
        AdCel.showInterstitialAdZone(AdCelAdType.REWARDED, "Menu");
      } else if (index == 0) {
        print("SHOWING interstitail AD");
        AdCel.showInterstitialAdZone(AdCelAdType.INTERSTITIAL, "Menu");
      }
    }
  }

  /*
  void videoAd(int index) async {
    if (adsworking == 1) {
      print("SHOWING AD");
      AdmostInterstitial interstitialAd;
      interstitialAd = AdmostInterstitial(
        zoneId: '19c6f289-a583-4d50-8f3c-7df679fa46ef', 
        listener: (AdmostAdEvent event, Map<String, dynamic> args) {
          if (event == AdmostAdEvent.loaded) {print("loaded interstitialAd");}
          if (event == AdmostAdEvent.dismissed) {
            interstitialAd.load();
          }
          if (event == AdmostAdEvent.completed) {
            interstitialAd.load();
          }
          if (event == AdmostAdEvent.failedToLoad) {
            interstitialAd.load();
            // Start hoping they didn't just ban your account :)
            print("Error code: ${args['errorCode']}");
          }
        },
      );
      AdmostRewarded rewardAd;
      rewardAd = AdmostRewarded(
        zoneId: '0b36c261-8ee9-4108-a48a-b05975c52b9a', //AP3
        listener: (AdmostAdEvent event, Map<String, dynamic> args) {
          if (event == AdmostAdEvent.loaded) {
            print("loaded rewardAd");
          } else if (event == AdmostAdEvent.dismissed) {
            rewardAd.load();
          } else if (event == AdmostAdEvent.failedToLoad) {
            rewardAd.load();
            // Start hoping they didn't just ban your account :)
            print("AdmostAdEvent.failedToLoad");
          } else if (event == AdmostAdEvent.completed) {
            rewardAd.load();
            print("REWARDED");
          }
        },
      );
      if (index == 9999) {
        ////////////////////load ads
        if (await interstitialAd.isLoaded) {
        } else {
          interstitialAd.load();
          print("first load interstitialAd");
        }

        if (await rewardAd.isLoaded) {
        } else {
          rewardAd.load();
          print("first load rewardAd");
        }
      } else if (index == 1) {
        ////////////////////rewarded
        print('MyCommonConstants rewardedAd() /////////////////////////////');
        /*platformid.invokeMethod('loadRewardedAd');
        MethodChannel('javatodart').setMethodCallHandler((MethodCall call) {
          if (call.method == 'onRewardedVideoAdRewarded') {
            print(
                'onRewardedVideoAdRewarded Episode Clicked and REWARDED AD is SHOWN ///////');
          }
          if (call.method == 'onInterstitialAdClosed') {
            print(
                'onInterstitialAdClosed Episode Clicked and INTERSTITIAL AD is CLOSED ///////');
          }
        });*/
        if (await rewardAd.isLoaded) {
          rewardAd.show();
        } else {
          print("not loaded yet");
          rewardAd.load();
        }
      } else if (index == 0) {
        ////////interstitail
        /*print('MyCommonConstants interstitialdAd() /////////////////////////////');
        platformid.invokeMethod('loadInterstitialAd');*/
        if (await interstitialAd.isLoaded) {
          interstitialAd.show();
        } else {
          interstitialAd.load();
        }
      }
    }
  }*/

  /*Future<String> videoAd(int index) async {
    if (adsworking == 1) {
      AdmostInterstitial interstitialAd;
      interstitialAd = AdmostInterstitial(
        zoneId: '19c6f289-a583-4d50-8f3c-7df679fa46ef', 
        listener: (AdmostAdEvent event, Map<String, dynamic> args) {
          if (event == AdmostAdEvent.loaded) {print("loaded interstitialAd");}
          if (event == AdmostAdEvent.dismissed) {
            interstitialAd.load();
          }
          if (event == AdmostAdEvent.completed) {
            interstitialAd.load();
            return 'interstitialAd_COMPLETED';
          }
          if (event == AdmostAdEvent.failedToLoad) {
            interstitialAd.load();
            // Start hoping they didn't just ban your account :)
            print("Error code: ${args['errorCode']}");
          }
        },
      );
      AdmostRewarded rewardAd;
      rewardAd = AdmostRewarded(
        zoneId: '0b36c261-8ee9-4108-a48a-b05975c52b9a', //AP3
        listener: (AdmostAdEvent event, Map<String, dynamic> args) {
          if (event == AdmostAdEvent.loaded) {
            print("loaded rewardAd");
          } else if (event == AdmostAdEvent.dismissed) {
            rewardAd.load();
          } else if (event == AdmostAdEvent.failedToLoad) {
            rewardAd.load();
            // Start hoping they didn't just ban your account :)
            print("AdmostAdEvent.failedToLoad");
          } else if (event == AdmostAdEvent.completed) {
            rewardAd.load();
            print("REWARDED");
            return 'rewardAd_COMPLETED';
          }
        },
      );
      if (index == 9999) {
        ////////////////////load ads
        if (await interstitialAd.isLoaded) {
        } else {
          interstitialAd.load();
          print("first load interstitialAd");
        }

        if (await rewardAd.isLoaded) {
        } else {
          rewardAd.load();
          print("first load rewardAd");
        }
      } else if (index == 1) {
        ////////////////////rewarded
        print('MyCommonConstants rewardedAd() /////////////////////////////');
        /*platformid.invokeMethod('loadRewardedAd');
        MethodChannel('javatodart').setMethodCallHandler((MethodCall call) {
          if (call.method == 'onRewardedVideoAdRewarded') {
            print(
                'onRewardedVideoAdRewarded Episode Clicked and REWARDED AD is SHOWN ///////');
          }
          if (call.method == 'onInterstitialAdClosed') {
            print(
                'onInterstitialAdClosed Episode Clicked and INTERSTITIAL AD is CLOSED ///////');
          }
        });*/
        if (await rewardAd.isLoaded) {
        print("SHOWING rewardAd AD");
          rewardAd.show();
        } else {
          
          print("not loaded yet");
          rewardAd.load();
          interstitialAd.show();
        }
      } else if (index == 0) {
        print("SHOWING interstitail AD");
        ////////interstitail
        /*print('MyCommonConstants interstitialdAd() /////////////////////////////');
        platformid.invokeMethod('loadInterstitialAd');*/
        if (await interstitialAd.isLoaded) {
          interstitialAd.show();
        } else {
          interstitialAd.load();
        }
      } else if (index == 5555) {                                           //////check if available
      if (await interstitialAd.isLoaded || await rewardAd.isLoaded){
        return 'ads_available';
      } else { return 'ads_NOT_available'; }

      }
    }
  }*/

  void showCenterFlash({
    FlashPosition? position,
    context,
    FlashBehavior? style,
    Alignment? alignment,
    required Widget childwidget,
    required int duration,
    required double width,
    required double height,
    required Color backgroundColor,
    bool enableDrag = true,
  }) {
    showFlash(
      context: context,
      //persistent: false,
      duration: Duration(seconds: duration),
      builder: (context, controller) {
        return Flash(
          controller: controller,
          //barrierBlur: 3.1,
          backgroundColor: backgroundColor,
          borderRadius: BorderRadius.circular(8.0),
          boxShadows: [
            BoxShadow(
                color: Colors.black.withOpacity(.35),
                offset: new Offset(0, 0),
                blurRadius: 10.0)
          ],
          //barrierDismissible: true,
          //borderColor: Colors.blue,
          position: position,
          forwardAnimationCurve: Curves.easeIn,
          reverseAnimationCurve: Curves.easeOut,
          behavior: style,
          alignment: alignment,
          enableVerticalDrag: enableDrag,
          onTap: () => controller.dismiss(),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: DefaultTextStyle(
                style: TextStyle(color: MyColors.primary1),
                child: Container(
                    width: width, height: height, child: childwidget)),
          ),
        );
      },
    );
  }

  void showdialogFlash({
    FlashPosition? position,
    context,
    // FlashStyle? style,
    Alignment? alignment,
    required Widget childwidget,
    required int duration,
    required double width,
    required double height,
    required Color backgroundColor,
    required Color borderColor,
    bool enableDrag = true,
  }) {
    showFlash(
      context: context,
      //persistent: false,
      duration: Duration(seconds: duration),
      builder: (context, controller) {
        return Flash.dialog(
          controller: controller,
          backgroundColor: backgroundColor,
          margin: const EdgeInsets.only(left: 40.0, right: 40.0),
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: DefaultTextStyle(
                style: TextStyle(color: MyColors.primary1),
                child: Container(
                    width: width, height: height, child: childwidget)),
          ),
        );
      },
    );
  }
}

class MyAdsOnVideoPage extends StatelessWidget {
  const MyAdsOnVideoPage();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        if (adsworking == 1) ...[
          //  MyAdmostBanner(),
          MyAdmostBanner(),
        ]
        /*const MyFacebookBanner(),
        Padding(padding: EdgeInsets.symmetric(vertical: 3),),
        const MyFacebookBanner(),
        Padding(padding: EdgeInsets.symmetric(vertical: 3),),

        Align(alignment: Alignment(0, 0),child: FacebookNativeAd(
        adType: NativeAdType.NATIVE_AD,
        placementId: "339939053337540_397864967544948",
        width: double.infinity,
        height: 300,
        backgroundColor: MyColors.primary3,
        titleColor: MyColors.opp1,
        descriptionColor: MyColors.opp1,
        buttonColor: Colors.purple,
        buttonTitleColor: Colors.white,
        //buttonBorderColor: Colors.white,
        listener: (result, value) {
        print("Native Ad: $result --> $value");
        //if (result == NativeAdResult.LOADED)_isNativeAdLoaded = true;
        /// Once an Interstitial Ad has been dismissed and becomes invalidated,
        /// load a fresh Ad by calling this function.
        },
      )
      ),
        Padding(padding: EdgeInsets.symmetric(vertical: 3),),
        
        Align(alignment: Alignment(0, 0),child: FacebookNativeAd(
        adType: NativeAdType.NATIVE_BANNER_AD,
        bannerAdSize: NativeBannerAdSize.HEIGHT_100,
        placementId: "339939053337540_382323715765740",
        width: double.infinity,
        backgroundColor: MyColors.primary3,
        titleColor: MyColors.opp1,
        descriptionColor: MyColors.opp1,
        buttonColor: Colors.purple,
        buttonTitleColor: Colors.white,
        //buttonBorderColor: Colors.white,
        listener: (result, value) {
          print("Native Banner Ad: $result --> $value");
        },
      )
      ),*/
      ],
    );
  }
}

class MyAdmostBanner extends StatelessWidget with AdCelBannerListener {
  MyAdmostBanner();

  late AdCelBannerController _adCelBannerController;
  @override
  Widget build(BuildContext context) {
    print("/////------------------render MyAdmostBanner--------");
    return Card(
      elevation: 0,
      color: MyColors.opp1.withOpacity(0),
      clipBehavior: Clip.hardEdge,
      child: Container(
        alignment: Alignment.center,
        height: 50,
        // color: Colors.blue[700],
        child: AdCelBanner(
          adSize: AdCelBanner.SIZE_320x50,
          listener: this,
          onBannerCreated: (AdCelBannerController controller) {
            print(
                'MAIN.DART >>>> Load Banner Ad with ID = ${controller.getId}');
            controller.setRefreshInterval(35);
            _adCelBannerController = controller;
          },
        ),
      ),
    );
  }

  // Banner Callbacks
  @override
  void onBannerClicked() {
    print('MAIN.DART >>>> onBannerClicked');
  }

  @override
  void onBannerAllProvidersFailedToLoad() {
    print('MAIN.DART >>>> onBannerAllProvidersFailedToLoad');

    _adCelBannerController.setRefreshInterval(35);
    _adCelBannerController.loadNextAd();
  }

  @override
  void onBannerFailedToLoad() {
    print('MAIN.DART >>>> onBannerFailedToLoad');
  }

  @override
  void onBannerFailedToLoadProvider(String provider) {
    print('MAIN.DART >>>> onBannerFailedToLoadProvider: $provider');
  }

  @override
  void onBannerLoad() {
    print('MAIN.DART >>>> onBannerLoad');
  }
}

// class MyAdmostBanner extends  StatelessWidget{
//   const MyAdmostBanner();
//   @override
//   Widget build(BuildContext context) {
//     print("/////------------------render MyAdmostBanner--------");
//     return Card(
//       elevation: 0,
//       color: MyColors.primary1,
//                     child:
//                     AdmostBanner(
//                       adUnitId: 'fad2a5c7-6df6-4636-bc14-f701285bb429',
//                       adSize: AdmostBannerSize.BANNER,
//                       listener: (AdmostAdEvent event,
//                           Map<String, dynamic> args) {
//                         if (event == AdmostAdEvent.loaded) {
//                           print("/////////////////////////AdmostBanner Ad Loaded");
//                         }
//                         if (event == AdmostAdEvent.clicked) {
//                           print("/////////////////////////AdmostBanner Ad clicked");
//                         }
//                         if (event == AdmostAdEvent.failedToLoad) {
//                           print("/////////////////////////AdmostBanner Error code: ${args['errorCode']}");
//                         }
//                       },
//                     )
//                 );
//   }
// }

class MySliverSpace extends StatelessWidget {
  const MySliverSpace({Key? key, required this.x}) : super(key: key);
  final double x;
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (
          context,
          index,
        ) {
          return new Padding(
            padding: EdgeInsets.symmetric(vertical: x),
          );
        },
        childCount: 1,
      ),
    );
  }
}

class MyVerticalPadding extends StatelessWidget {
  const MyVerticalPadding({Key? key, required this.x}) : super(key: key);
  final double x;
  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: EdgeInsets.symmetric(vertical: x),
    );
  }
}

class EmptyPadding extends StatelessWidget {
  const EmptyPadding({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: EdgeInsets.all(0),
    );
  }
}

class LineChartSample extends StatefulWidget {
  LineChartSample({Key? key, required this.videoTaskItem}) : super(key: key);
  final VideoTaskItem videoTaskItem;
  @override
  _LineChartSampleState createState() => _LineChartSampleState();
}

class _LineChartSampleState extends State<LineChartSample> {
  /*List<Color> gradientColors = [
    const Color(0xFFE6233D),
    const Color(0xFFE49C00),
  ];*/

  List<Color> gradientColors = [
    const Color(0xFFAF0058),
    const Color(0xFFE7912F),
  ];

  bool showAvg = false;

  List<double> speedlist = [];
  double temp = 0;
  int random(int min, int max) {
    var rn = new Random();
    return min + rn.nextInt(max - min);
  }

  @override
  Widget build(BuildContext context) {
    double? tmp = widget.videoTaskItem.speedDouble();
    // spots.add(FlSpot(spots.length.toDouble(), tmp));
    speedlist.add(tmp ?? 0);
    if (speedlist.length > 100) speedlist.removeAt(0);
    //print("----------------apots.len: " + speedlist.length.toString() + "   |      " + tmp.toString());
    const dur = Duration(seconds: 10);
    /*Timer.periodic(dur, (timer) {
    setState(() {
         double speed = double.parse(random(1,5).toString());
         temp++;
         speedlist.add(speed);

         spots.add(FlSpot(temp, speed));
    
    if(speedlist.length > 100){
        speedlist.removeAt(0);
        spots.removeAt(0);
    }
    temp++;
    //print(temp.toString() + ") speed = " + speed.toString()  + "       length: " +speedlist.length.toString());
    });
  });*/

    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 4.5,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            //: const EdgeInsets.only(right: 18.0, left: 12.0, top: 24, bottom: 12),
            child: LineChart(
              mainData(speedlist),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData mainData(List<double> speedlist) {
    List<FlSpot> spots = [];
    double maxy = 0;
    double miny = 0;
    for (int i = 0; i < speedlist.length; i++) {
      if (speedlist[i] > maxy) maxy = speedlist[i];
      if (speedlist[i] < miny) miny = speedlist[i];
      spots.add(FlSpot(double.parse(i.toString()), speedlist[i]));
    }

    LineChartBarData lBardata = LineChartBarData(
      //shadow: Shadow(color: Colors.black, blurRadius: 10),
      spots: spots,
      isCurved: true,
      gradient: LinearGradient(colors: gradientColors),
      barWidth: 2,
      isStrokeCapRound: true,
      showingIndicators: [1, 2, 5, 1, 4, 5],
      //gradientFrom: Offset(2, 3),
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList()),
      ),
    );
    return LineChartData(
      //lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: MyColors.opp1.withOpacity(0.05),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: MyColors.opp1.withOpacity(0.05),
            strokeWidth: 1,
          );
        },
      ),
      clipData: FlClipData(top: true, bottom: true, left: true, right: true),
      titlesData: FlTitlesData(
        show: false,
        /*bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) =>
              const TextStyle(color: Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return 'MAR';
              case 5:
                return 'JUN';
              case 8:
                return 'SEP';
            }
            return '';
          },
          margin: 8,
        ),
        rightTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '10k';
              case 3:
                return '30k';
              case 5:
                return '50k';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),*/
      ),
      borderData: FlBorderData(
          show: false,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 99,
      minY: miny - (miny / 2),
      maxY: maxy + (maxy / 3),
      showingTooltipIndicators: [
        ShowingTooltipIndicators(10 as List<LineBarSpot>, )
      ],
      lineBarsData: [lBardata],
    );
  }

  /*LineChartData avgData() {
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) =>
              const TextStyle(color: Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return 'MAR';
              case 5:
                return 'JUN';
              case 8:
                return 'SEP';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '10k';
              case 3:
                return '30k';
              case 5:
                return '50k';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData:
          FlBorderData(show: true, border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
          ],
          isCurved: true,
          colors: [
            ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2),
            ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2),
          ],
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(show: true, colors: [
            ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2).withOpacity(0.1),
            ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2).withOpacity(0.1),
          ]),
        ),
      ],
    );
  }*/
}

class MyNameLogo extends StatelessWidget {
  const MyNameLogo({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/namelogo.png');
  }
}

class GoogleHttpClient extends IOClient {
  Map<String, String> _headers;

  GoogleHttpClient(this._headers) : super();

  /*@override
  Future<http.StreamedResponse> send(http.BaseRequest request) =>
      super.send(request..headers.addAll(_headers));
    
  @override
  Future<http.Response> head(Object url, {Map<String, String> headers}) =>
      super.head(url, headers: headers..addAll(_headers));*/
}

class DownloadsArguments {
  final String videoUrl;
  final String thumbUrl;
  final String name;
  final String headers;
  final String isgrabbed;

  DownloadsArguments(
      this.videoUrl, this.thumbUrl, this.name, this.headers, this.isgrabbed);
}

class MyThemeClass {
  /*Color primary1;
  Color primary2;
  Color primary3;
  Color opp1;
  Color reddy;
  Color purp;
  int numb;*/
  String? themename;
  /*TextStyle infobutton;
  TextStyle tile;
  TextStyle normal;
  TextStyle heading;
  TextStyle buttonstyle;*/

  MyThemeClass({
    /*this.primary1, 
    this.primary2, 
    this.primary3, 
    this.opp1, 
    this.reddy,
    this.purp,
    this.numb,*/
    this.themename,
  });
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

class DownloadEpisodelist {
  String videoname;
  String videourl;
  String imageurl;
  String localurl;
  String downloadertype;
  String headers;
  bool isgrabbed;
  bool iscompleted;

  DownloadEpisodelist._({
    required this.videoname,
    required this.videourl,
    required this.imageurl,
    required this.localurl,
    required this.downloadertype,
    required this.headers,
    required this.isgrabbed,
    required this.iscompleted,
  });
  factory DownloadEpisodelist.fromJson(Map<String, dynamic> json) {
    return new DownloadEpisodelist._(
      videoname: json['videoname'],
      videourl: json['videourl'],
      imageurl: json['imageurl'],
      localurl: json['localurl'],
      downloadertype: json['downloadertype'],
      headers: json['headers'],
      isgrabbed: json['isgrabbed'] == '1' ? true : false,
      iscompleted: false,
    );
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['videoname'] = videoname;
    map['videourl'] = videourl;
    map['imageurl'] = imageurl;
    map['localurl'] = localurl;
    map['downloadertype'] = downloadertype;
    map['headers'] = headers;
    map['isgrabbed'] = isgrabbed;
    map['iscompleted'] = iscompleted;
    return map;
  }

  DownloadEpisodelist.fromDb(Map map)
      : videoname = map["videoname"],
        videourl = map["videourl"],
        imageurl = map["imageurl"],
        localurl = map["localurl"],
        downloadertype = map["downloadertype"],
        headers = map["headers"],
        isgrabbed = map['isgrabbed'] == 1 ? true : false,
        iscompleted = map['iscompleted'] == 1 ? true : false;
}

extension StringCasingExtension on String {
  ///capitalize string
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String removeClutter() => length > 0
      ? '${this.replaceAll("%20", " ").replaceAll("%E2%98%86", "☆").replaceAll("%E2%99%A1", "♡")}'
      : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
  String getTitleFromUrl(String? removeformatString) => length > 0
      ? '${this.toString().split("/").last.trim().replaceAll("mp4", '').replaceAll(removeformatString.toString(), '')}'
      : '';
  String removelastString(String? removeformatString) => length > 0
      ? ('${this.toString()[this.toString().length - 1].trim()}' ==
              removeformatString.toString()
          ? '${substring(0, this.toString().length - 1)}'
          : this)
      : '';
}
