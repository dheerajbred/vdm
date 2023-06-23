
import 'dart:convert';

import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:videodown/data/model/download.model.dart';
import 'package:videodown/data/model/models.dart';
import 'package:videodown/data/repository/local/download_db.dart';
import 'package:videodown/infrastructure/themes.dart';
import 'package:http/http.dart' as http;

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

  static const platformid = MethodChannel("IronSourceAdBridge");

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
    print("isgrabbed: $isgrabbed");
    tmplinkmap.add({
      "videoname": name,
      "videourl": videoUrl,
      "localurl": "$dirloc$name.mp4",
      "imageurl": thunmbnaillink,
      'isgrabbed': (isgrabbed != '') ? '1' : '0',
      "downloadertype": MyCommonConstants.m3u8Downloader,
      'headers': headers.trim(),
      //"localname": "AnimeName" + " " + "EpisodeNumber" + " " + "ServerName" + " " + "Quality" + "Extention"
    });

    var tmpson = json.encode(tmplinkmap);
    downloadEpisodelist = (json.decode(tmpson) as List)
        .map((data) => DownloadEpisodelist.fromJson(data))
        .toList();

    print("downloadEpisodelist------------- ${downloadEpisodelist.first.isgrabbed}");

    DownloadEpisodelist downloadState = downloadEpisodelist.first;
    print("---video downloadState.videoname: ${downloadState.videoname}");
    print("---video downloadState.videourl: ${downloadState.videourl}");
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
    } catch (e) {
      if (!isExists) {
        db.addMovie(downloadState);
        print("---add success");
      }

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
        "playmethod: ${downloadEpisodelist[downloadEpisodelistInt].videourl}");
    platformcannel.invokeMethod(
      'playmethod',
      downloadEpisodelist[downloadEpisodelistInt].videourl,
    );
  }

  void directPlayVideoPlayer(String videoUrl, String videoName, context) async {
    MethodChannel platformcannel = const MethodChannel('IronSourceAdBridge');
    platformcannel.invokeMethod(
      'playmethod',
      videoUrl,
    );
  }

  void videoAd(int index) async {
    // if (adsworking == 1) {
    //   if (index == 9999) {
    //     ////////////////////load ads
    //   } else if (index == 1) {
    //     ////////////////////rewarded
    //     print('MyCommonConstants rewardedAd() /////////////////////////////');
    //     AdCel.showInterstitialAdZone(AdCelAdType.REWARDED, "Menu");
    //   } else if (index == 0) {
    //     print("SHOWING interstitail AD");
    //     AdCel.showInterstitialAdZone(AdCelAdType.INTERSTITIAL, "Menu");
    //   }
    // }
  }

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
                offset: const Offset(0, 0),
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
                child: SizedBox(
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
                child: SizedBox(
                    width: width, height: height, child: childwidget)),
          ),
        );
      },
    );
  }
}



