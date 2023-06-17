// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:html/parser.dart';
//import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
// import 'package:media_storage/media_storage.dart';
import 'package:external_path/external_path.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:videodownloader/videodownloader.dart';
import 'package:open_file/open_file.dart';
//import 'package:simple_permissions/simple_permissions.dart';
//import 'package:file_utils/file_utils.dart';
import 'package:fluttertoast/fluttertoast.dart' as toast;
import 'package:external_video_player_launcher/external_video_player_launcher.dart';
import 'dart:math';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
// import 'package:open_app/open_app.dart';
import 'package:videodown/colors.dart';
import 'package:videodown/customdrawer.dart';
import 'package:videodown/downloads_database.dart';
import 'package:videodown/download_from_share_in_page.dart';
//import 'package:videodown/customdrawer.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:connectivity/connectivity.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import 'package:rxdart/rxdart.dart';
//import 'package:share/share.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
// import 'package:line_icons/line_icons.dart';
import 'package:ionicons/ionicons.dart';
// import 'package:groovin_material_icons/groovin_material_icons.dart';
// import 'package:flutter_easyrefresh/bezier_hour_glass_header.dart';
// import 'package:flutter_easyrefresh/ball_pulse_header.dart';
// import 'package:flutter_easyrefresh/easy_refresh.dart';
// import 'package:mx_player_plugin/mx_player_plugin.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:uni_links/uni_links.dart';
import 'package:app_links/app_links.dart';

//import 'package:share/share.dart';
import 'package:expandable/expandable.dart';
import 'package:flash/flash.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
// import 'package:intent/intent.dart' as android_intent;
// import 'package:intent/extra.dart' as android_extra;
// import 'package:intent/typedExtra.dart' as android_typedExtra;
// import 'package:intent/action.dart' as android_action;
// import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:get/get.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:ndialog/ndialog.dart';
import 'package:flutter_adcel/flutter_adcel.dart';


class Downloader extends StatefulWidget {
  Downloader({
    Key? key,
    required this.title,
    this.nointent_previousintent = 'Empty',

  }) : super(key: key);
  final String title;
  final String nointent_previousintent;
  @override
  DownloaderState createState() => DownloaderState();
}

class DownloaderState extends State<Downloader> with WidgetsBindingObserver, AdCelInterstitialListener {
  List<DownloadEpisodelist> filteredEpisodes = [];

  List<DownloadEpisodelist> movieCache = [];

  late StreamSubscription _intentDataStreamSubscription;

  late List<_TaskInfo> _tasks;
  late List<_ItemHolder> _items;
  late bool _isLoading;
  late bool _permissisonReady;
  late String _localPath;
  late Directory _appDocsDir;
  var _myhomepagescafoldkey = GlobalKey<ScaffoldState>();
  final PublishSubject subject = PublishSubject<String>();
  var _listscafoldkey = GlobalKey<ScaffoldState>();
  //var _slidablekey = new GlobalKey<SlidableState>();

  late int boltdowncnt;
  late SharedPreferences preferences;

  String downloadStatusString = "zzzzzzzz";
  String downloadpersistentString = "aaaaaaaa";
  static const MethodChannel channel =
      const MethodChannel('IronSourceAdBridge');
  static const EventChannel eventChannel = EventChannel('DOWNLOADING_CHANNEL');

  bool isFullIntent = false;

  _refresh() async {
    setState(() {});
  }

  /*void _requestDownload(_TaskInfo task) async {
    print("_requestDownload----------- " + task.name.toString());
    /*task.taskId = await FlutterDownloader.enqueue(
        url: task.link,
        headers: {
          "auth": "test_for_sql_encoding"
        },
        savedDir: _localPath,
        showNotification: true,
        //fileName: task.name,
        openFileFromNotification: true);*/
  }

  void _cancelDownload(_TaskInfo task) async {
    //await FlutterDownloader.cancel(taskId: task.taskId);
  }

  void _pauseDownload(_TaskInfo task) async {
    //await FlutterDownloader.pause(taskId: task.taskId);
  }

  void _resumeDownload(_TaskInfo task) async {
    //String newTaskId = await FlutterDownloader.resume(taskId: task.taskId);
    //task.taskId = newTaskId;
  }

  void _retryDownload(_TaskInfo task) async {
    //String newTaskId = await FlutterDownloader.retry(taskId: task.taskId);
    //task.taskId = newTaskId;
  }*/

  /*Future<bool> _openDownloadedFile(String loc) {
    //String aa = "/storage/emulated/0/Anime Prime Downloads" + "/" + task.localnametask;
    //print("/////////// _openDownloadedFile: " + task.name + " | " + task.localnametask);
    //String aa = task.localnametask;
    print("aaaaaaaaaaaaaaaaaaaaaaaa: " + loc);
    MyCommonConstants().directPlayVideoPlayer(loc, "task.name", context,);
    //channel.invokeMethod('playmethod', aa,);
    //return FlutterDownloader.open(taskId: task.taskId);
  }

  void _delete(_TaskInfo task) async {
    //await FlutterDownloader.remove(taskId: task.taskId, shouldDeleteContent: true);
    await _prepare();
    setState(() {});
  }*/

  Future<bool> _checkPermission() async {
    // print("------------------------00000000000------_checkPermission");
    // print("------------------------000000111100000------_checkPermission");
    //PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    if (await Permission.storage.request().isGranted) {
      // print("------------------------111------_checkPermission");

      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();

      return true;
    } else {
      // print("------------------------22222222------_checkPermission");

      return true;
    }

    return false;
  }
    DownloadDatabase db = DownloadDatabase();

  Future<Null> _prepare() async {
    // print("preparing");
    Directory appdocdir = await getApplicationDocumentsDirectory();
    // print("appdocdir: " + appdocdir.path);
    filteredEpisodes = await db.getMovies();
    setState(() {
      movieCache = filteredEpisodes;
    });

    //final tasks = await FlutterDownloader.loadTasks();

    int count = 0;
    _tasks = [];
    _items = [];
    //print("---video.isgrabbed: " + filteredEpisodes.first.isgrabbed.toString());
    Iterable inReverse = filteredEpisodes.reversed;
    filteredEpisodes = inReverse.toList().cast<DownloadEpisodelist>();
    _tasks.addAll(filteredEpisodes.map((video) => _TaskInfo(
          name: video.videoname,
          link: video.videourl,
          // videoTaskItem: null,
          localnametask: video.localurl,
          isComp: video.iscompleted,
          isGrabbed: video.isgrabbed,
          image: video.imageurl,
          downloadPagetype: video.downloadertype,
          headerString: video.headers,
        )));

    List urls = [];
    //_items.add(_ItemHolder(name: 'Videjjjos'));
    for (int i = count; i < _tasks.length; i++) {
      urls.add(_tasks[i].link);
    }
    // print("--------uls list count: " + urls.length.toString());

    for (int i = count; i < _tasks.length; i++) {
      // print(i.toString() +")   " +"_tasks[i].isComp)))" +_tasks[i].isComp.toString());
      final item = VideoDownloader.generateItem(_tasks[i].link!);
      item?.onDownloadSuccess = () {
        // print(i.toString() +")   ----VideoDownloader-----item: " +item.toString() +"     *onDownloadSuccess*     " +item.taskStateString());
        // print("----onDownloadSuccess filteredEpisodes[i].videoname: " + filteredEpisodes[i].videoname +" -------filePath: " +_tasks[i].videoTaskItem!.filePath +"-------iscpmpleted: " + filteredEpisodes[i].iscompleted.toString());
        _tasks[i].status = MyCommonConstants.downloadSuccess;
        _tasks[i].isComp = true;
        _tasks[i].localnametask = _tasks[i].videoTaskItem!.filePath;
        if (filteredEpisodes[i].iscompleted != true) {
          filteredEpisodes[i].iscompleted = true;
          filteredEpisodes[i].localurl = _tasks[i].videoTaskItem!.filePath ?? "No Path";
          // print("////////////////////filteredEpisodes[i].videoname: " +filteredEpisodes[i].videoname +" | " +"filteredEpisodes[i].localurl: " +filteredEpisodes[i].localurl);
          db.updateMovie(filteredEpisodes[i]);
          _prepare();
        }
        if (mounted) setState(() {});
      };
      item?.onDownloadProgress = () {
        //print(i.toString() + ")   ----VideoDownloader-----item: "+ item.toString() + "     *onDownloadProgress*     " + item.taskStateString());
        _tasks[i].status = MyCommonConstants.downloadDownloading;
        if (mounted) setState(() {});
      };
      item?.onDownloadSpeed = () {
        //print(i.toString() + ")   ----VideoDownloader-----item: "+ item.toString() + "     *onDownloadSpeed*     " + item.taskStateString());
        if (mounted) setState(() {});
      };
      item?.onDownloadError = () {
        // print(i.toString() +")   ----VideoDownloader-----item: " +item.toString() +"     *onDownloadError*     " +item.taskStateString());
        _tasks[i].status = MyCommonConstants.downloadError;
        if (mounted) setState(() {});
      };
      item?.onDownloadPause = () {
        // print(i.toString() +")   ----VideoDownloader-----item: " +item.toString() +"     *onDownloadPause*     " +item.taskStateString());
        _tasks[i].status = MyCommonConstants.downloadPause;
        if (mounted) setState(() {});
      };
      item?.onDownloadPending = () {
        // print(i.toString() +")   ----VideoDownloader-----item: " +item.toString() +"     *onDownloadPending*     " +item.taskStateString());
        _tasks[i].status = MyCommonConstants.downloadPending;
        if (mounted) setState(() {});
      };
      item?.onDownloadPrepare = () {
        // print(i.toString() +")   ----VideoDownloader-----item: " +item.toString() +"     *onDownloadPrepare*     " +item.taskStateString());
        _tasks[i].status = MyCommonConstants.downloadPrepare;
        if (mounted) setState(() {});
      };
      _tasks[i].videoTaskItem = item;
      _items.add(_ItemHolder(name: _tasks[i].name!, task: _tasks[i]));
      if (_tasks[i].isComp!) {
        // print(i.toString() +")   ----VideoDownloader-----item: " +item.toString() +"     *isComp*     " +item.taskStateString());
        _tasks[i].status = MyCommonConstants.downloadSuccess;
        //_tasks[i].localnametask = _tasks[i].videoTaskItem.filePath;
      }
      count++;
    }

    /*tasks?.forEach((task) {
      for (_TaskInfo info in _tasks) {
        if (info.link == task.url) {
          info.taskId = task.taskId;
          info.status = task.status;
          info.progress = task.progress;
        }
      }
    });*/
    // print("------------------------0000000000------_permissisonReady:" +_permissisonReady.toString());

    _permissisonReady = await _checkPermission();

    // print("------------------------111------_permissisonReady:" +_permissisonReady.toString());

    /*_localPath = (await _findLocalPath()) + '/AnimePrime';

    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }*/
    _appDocsDir = await getApplicationDocumentsDirectory();
    // print('_appDocsDir = $_appDocsDir');

    // print("-----------preparelength-----------" +filteredEpisodes.length.toString());
    for (var i = 0; i < filteredEpisodes.length; i++) {
      // print("-----------prepare-----------");
      // print("video name: " + filteredEpisodes[i].videoname);
      // print("video videourl: " + filteredEpisodes[i].videourl);
      // print("video imageurl: " + filteredEpisodes[i].imageurl);
      // print("video localurl: " + filteredEpisodes[i].localurl);
      // print("video iscompleted: " + filteredEpisodes[i].iscompleted.toString());
      // print("_tasks name: " + _tasks[i].name!);
      // print("_tasks progress: " + _tasks[i].progress.toString());
      // print("_tasks isGrabbed: " + _tasks[i].isGrabbed.toString());
      // print("_tasks isComp: " + _tasks[i].isComp.toString());
      // print("_tasks status: " + _tasks[i].status);
      // print("_tasks image: " + _tasks[i].image!);
      // print("_tasks downloadPagetype: " + _tasks[i].downloadPagetype!);
      // print("filteredEpisodes headers: " + filteredEpisodes[i].headers.toString());
      // print("---");
    }

    for (var i = 0; i < _tasks.length; i++) {
      // print("-----------prepare-----------");
      // print("_tasks localnametask: " + _tasks[i].localnametask!);
      // print("filteredEpisodes isgrabbed: " +filteredEpisodes[i].isgrabbed.toString());
      // print("_tasks headerString: " + _tasks[i].headerString!);
      // print("filteredEpisodes iscompleted: " +filteredEpisodes[i].iscompleted.toString());
      // print("---");
    }
    // print("----------------_isLoading: " + _isLoading.toString());
    setState(() {
      _isLoading = false;
    });

    //_persistantStatus();
  }

  File fileFromDocsDir(String filename) {
    String pathName = p.join(_appDocsDir.path, filename);
    print("//////////fffffffffffffff/////////pathName: "+ pathName);
    return File(pathName);
  }

  /*Future<String> _findLocalPath() async {
    final directory = widget.platform == TargetPlatform.android
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    print("directory path::::::::: " +  directory.path.toString());
    return directory.path;
  }*/

  // bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
  //   //eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError, cancelOnError: true).cancel();
  //   // Navigator.of(context).pop(true);

  //   //return true;
  // }


  Future<String> _setVideoSaveDirectory(String str) async {
    const folderName="VDM Downloads";
final path= Directory(str + "/$folderName");
    if ((await path.exists())){
        print("_setVideoSaveDirectory ****exist**** $path");
      }else{
        print("_setVideoSaveDirectory ****not exist CREATING**** $path");
        path.create();
      }
    return path.path;

  }

  List<VideoTaskItem> items = [];
  late ConnectivityResult interneticc;

  Future<dynamic> _internetChecker() async {
    var abc = await (Connectivity().checkConnectivity());
    // debugPrint('_fetchData internetConnectionChecker $abc');

    setState(() {
      interneticc = abc;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _internetChecker();
    //_refresh();
    
    // MyCommonConstants().videoAd(9999);
      AdCel.setLogging(true);
    //AdCel.setTestMode(true);
    // AdCel.setUserConsent(true);
    AdCel.requestTrackingAuthorization();
    AdCel.init("0ae348ea-a23b-4ecf-bd83-3a68daa7f328:14ad0f3b-c030-478b-bb6a-256af2e1eb45", [
      AdCelAdType.BANNER,
      AdCelAdType.IMAGE,
      AdCelAdType.VIDEO,
      AdCelAdType.INTERSTITIAL,
      AdCelAdType.REWARDED
    ]);
    // AdCel.setTestMode(true);

    AdCel.setInterstitialListener(this);

    initUniLinks();
     

    ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS).then((value) {
          _setVideoSaveDirectory(value).then((val) {
            VideoDownloader.init(
          config: VideoDownloadConfig(
        concurrentCount: 2,
        cacheDirectoryPath: val,
      ));
      });
    });


      //     getExternalStorageDirectory().then((val) {
      //       VideoDownloader.init(
      //     config: VideoDownloadConfig(
      //   concurrentCount: 2,
      //   cacheDirectoryPath: val!.path,
      // ));

      //     });



    getboltdownloadscount();

    ExternalPath.getExternalStorageDirectories().then((value) {
      
    });

    //BackButtonInterceptor.add(myInterceptor);
    //MyCommonConstants().videoAd(0);
    filteredEpisodes = [];
    movieCache = [];
    //subject.stream.listen(searchDataList);
    //setupList();
    _prepare();
    /*FlutterDownloader.registerCallback((id, status, progress) {
      print(
          'Download task ($id) is in status ($status) and process ($progress)');
      final task = _tasks.firstWhere((task) => task.taskId == id);
      setState(() {
        task?.status = status;
        task?.progress = progress;
      });
    });*/
/*final it = [
      'https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/master.m3u8',
      'https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4',
      'https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-avi-file.avi',
      'https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mov-file.mov',
    ];
    items = it.map((e) {
      final item = VideoDownloader.generateItem(e);
      item.onDownloadSuccess = () {
        if (mounted) setState(() {});
      };
      item.onDownloadProgress = () {
        if (mounted) setState(() {});
      };
      item.onDownloadSpeed = () {
        if (mounted) setState(() {});
      };
      item.onDownloadError = () {
        if (mounted) setState(() {});
      };
      item.onDownloadPause = () {
        if (mounted) setState(() {});
      };
      return item;
    }).toList();*/

    //eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError, cancelOnError: true);

    //_persistantStatus();
    _isLoading = true;
    _permissisonReady = false;

    //WidgetsBinding.instance.addPostFrameCallback((_) => initListener());
  }

    bool _isRewardButtonDisabled = true;


  // Adcel interstial callbacks
    @override
  void onFirstInterstitialLoad(String adType, String provider) {
    print('MAIN.DART >>>> onFirstInterstitialLoad: $adType, $provider');
    setState(() {
      _isRewardButtonDisabled = false;
    });
  }

  @override
  void onInterstitialClicked(String adType, String provider) {
    print('MAIN.DART >>>> onInterstitialClicked: $adType, $provider');
  }

  @override
  void onInterstitialDidDisappear(String adType, String provider) {
    print('MAIN.DART >>>> onInterstitialDidDisappear: $adType, $provider');
  }

  @override
  void onInterstitialFailLoad(String adType, String error) {
    print('MAIN.DART >>>> onInterstitialFailLoad: $adType, $error');
  }

  @override
  void onInterstitialFailedToShow(String adType) {
    print('MAIN.DART >>>> onInterstitialFailedToShow: $adType');
  }

  @override
  void onInterstitialWillAppear(String adType, String provider) {
    print('MAIN.DART >>>> onInterstitialWillAppear: $adType, $provider');
  }

  @override
  void onRewardedCompleted(String adProvider, String currencyName, String currencyValue) {
    print('MAIN.DART >>>> onRewardedCompleted: $adProvider, $currencyName, $currencyValue');
  } 



  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('AppLifecycleState state: $state');
    if (Platform.isAndroid) {
      if (state == AppLifecycleState.resumed) {
        initUniLinks();
      }
    }
  }
  final _appLinks = AppLinks();

  String tmp_initialLink = 'sss';
  Future<Null> initUniLinks() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    //https://animeprimepage.page.link/?link=https://animeprime.app/azur-lane-episode-10&apn=my.animeprime.app
    try {
      String initialLink;

  _appLinks.getLatestAppLink().then((value) async {
    setState(() {
      initialLink = value.toString();
      print('----------tmp_initialLink: $initialLink  ---widget:' +  (widget.nointent_previousintent).toString() + ' ----'+
      ( (widget.nointent_previousintent.trim() != value.toString().trim()) && ((widget.nointent_previousintent).toString() != '')  ).toString());
  if (value != null) {
    if( (widget.nointent_previousintent.trim() != value.toString().trim()) && ((widget.nointent_previousintent).toString() != '')  ) {


    // if(true) {
      setState(() {
        tmp_initialLink = initialLink;
      });
          Get.to(DownloadFromShareInPage(
        intentString: value.toString(),
        isDirectdownfile: false,
      ));
          // _navigateToDownloadPage(magicvdmstring);
        }
    //_gotoImageCollections(initialLink);
    //Navigator.pushNamed(context, deepLink.path);
  }
    });
  });

      // print("////////////////////////videoman initialLink:  " + initialLink);
      // List queryParams = Uri.parse(initialLink)?.queryParametersAll?.entries?.toList();
      // print("//////////////videoman queryParams:   " + queryParams.toString());
      // Parse the link and warn the user, if it is not correct,
      // but keep in mind it could be `null`.
      
    } on PlatformException {
      // Handle exception by warning the user their action did not succeed
      // return?
    }
  }

  /*initListener() {
    _intentDataStreamSubscription = ReceiveSharingIntent.getMediaStream()
        .listen((List<SharedMediaFile> value) {
      print('---------- media stream shared --------------');
      print(value);
    }, onError: (err) {
      print("getIntentDataStream error: $err");
    });

    // For sharing images coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> value) {
      print('---------- initial media shared --------------');
      print(value);
    });

    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    _intentDataStreamSubscription = ReceiveSharingIntent.getTextStream().listen((String value) {
      print("---------- URL Shared : " + value);
      _navigateToDownloadPage(value);
      // setState(() {
      //   passedParameters = value;
      // });
    }, onError: (err) {
      print("-----  getUrlLinkStream error: $err");
    });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((String value) {
      print("---------- Initial Text : -----------");
      _navigateToDownloadPage(value);
      print(value);
    });
  }*/

  /*_navigateToDownloadPage(String value) async {
    
    String slpitstring = '***8***';
    if (value != null) {
      var split = value.split(slpitstring);
      final values = {for (int i = 0; i < split.length; i++) i: split[i]};

      // var videoUrl = values[0].toString();
      // var thumbUrl = values[1].toString();
      // var name = values[2].toString();
      // var headers = values[3].toString();
      // var isgrabbed = values[4].toString();

      print('_navigateToDownloadPage value: $value');
      
      var videoUrl = value.toString().trim().split(slpitstring).first.trim();
      String thumbUrl = 'Empty';
      String name = 'Empty';
      String headers = 'Empty';
      String isgrabbed = 'Empty';

      if(value.toString().trim().contains('isCustomVdm')){
              var cus = value.toString().trim().split(slpitstring);
              var cu = cus.firstWhere((element) => element.contains('isCustomVdm')).trim().split('===').last.trim();
              if(cu == '1'){
                setState(() {
                    isgrabbed = 'isgrabbedtrue';
                  });
              }
            }
      if(value.toString().trim().contains('customVdmVideoImg')){
              var cut = value.toString().trim().split(slpitstring);
              var cur = cut.firstWhere((element) => element.contains('customVdmVideoImg')).trim().split('===').last.trim();
              if((cur != 'empty') || (cur != '') || (cur != null)){
                setState(() {
                    thumbUrl = cur.trim();
                  });
              }
            }
      if(value.toString().trim().contains('customVdmTitle')){
              var cut = value.toString().trim().split(slpitstring);
              var cur = cut.firstWhere((element) => element.contains('customVdmTitle')).trim().split('===').last.trim();
              if((cur != 'empty') || (cur != '') || (cur != null)){
                setState(() {
                    name = cur.trim();
                  });
              }
            }
      if(value.toString().trim().contains('customVdmHeaders')){
              var cut = value.toString().trim().split(slpitstring);
              var cur = cut.firstWhere((element) => element.contains('customVdmHeaders')).trim().split('===').last.trim();
              if((cur != 'empty') || (cur != '') || (cur != null)){
                setState(() {
                    headers = cur.trim();
                  });
              }
            }

      print('_navigateToDownloadPage videoUrl: $videoUrl thumbUrl: $thumbUrl name: $name headers: $headers isgrabbed: $isgrabbed');

      var arguments = DownloadsArguments(videoUrl, thumbUrl, name, headers, isgrabbed);
      await Get.to(DownloadFromShareInPage(
        downloadsArguments: arguments,
        isIntent: true,
      ));
      setState(() {
        isFullIntent = true;
      });
      // await Get.toNamed('/download', arguments: arguments);
      return true;
    }
    _intentDataStreamSubscription.cancel();
  }*/

/*
    void _onEvent(Object event) async {
      downloadStatusString = event.toString();
      print("------------------_onEvent downloadStatusString: " + downloadStatusString);
      for (var i = 0; i < _items.length; i++) {
        //print("---------_items.length: " + _items.length.toString());
        if (downloadStatusString != "TaskID=ABC") {
          if (_items[i].task.link == downloadStatusString.split(",")[5].toString()) {
            try {
              setState(() {
                _items[i].task.taskId = downloadStatusString.split(",")[0].toString().replaceAll("TaskID=", "").trim();
                _items[i].task.localnametask = downloadStatusString.split(",")[1].toString();
                _items[i].task.progress = int.parse(downloadStatusString.split(",")[2]);
              });
            } catch (e) {
              print("-----_onEvent error: " + e);
            }
            //print("-----" + _items[i].task.name + " = " + _items[i].task.status  + " | " + "taskId = " + _items[i].task.taskId.toString() + " | " + "progress = " + _items[i].task.progress.toString() + " | " + "localnametask = " + _items[i].task.localnametask.toString());

          if (downloadStatusString.split(",")[3].toString() == MyCommonConstants.running) {
            setState(() {
              _items[i].task.status = MyCommonConstants.running;
            });
            //print("-----cond 1----" + _items[i].task.name + " is = " + MyCommonConstants.running);
          }
          else if (downloadStatusString.split(",")[3].toString() == MyCommonConstants.complete) {
            _items[i].task.status = MyCommonConstants.complete;
            print("-----cond 2----" + _items[i].task.name + " is = " + MyCommonConstants.complete);
            DownloadDatabase db = DownloadDatabase();
            if (filteredEpisodes[i].iscompleted != true) {
              filteredEpisodes[i].iscompleted = true;
              filteredEpisodes[i].localurl = downloadStatusString.split(",")[1].toString();
              db.updateMovie(filteredEpisodes[i]);
              _prepare();
            }
            }
          else if (downloadStatusString.split(",")[3].toString() == MyCommonConstants.failed) {
            setState(() {
              _items[i].task.status = MyCommonConstants.failed;
            });
            //print("-----cond 3----" + _items[i].task.name + " is = " + MyCommonConstants.failed);
          }
        }
        }
      }
    
  }

  void _onError(Object error) {
    setState(() {
      downloadStatusString = "/////////////------------------downloadStatusString: ERROR";
    });
  }

  void _persistantStatus() async {
    downloadpersistentString = await channel.invokeMethod('get_persistentString');
    print("//////////_persistantStatus: " + downloadpersistentString);
    setState(() {
          List alist  = downloadpersistentString.split("|||");
    print("----alist.length: " + alist.length.toString());
    for (var i = 0; i < alist.length; i++) {
      //print("----alist " + i.toString() + " : " + alist[i]);
      if(alist[i] != "XYZ"){
        print("saatatta");
         _TaskInfo temptask;
         int tempnum;
         print("_items.length: "+ _items.length.toString());
        for (var j = 0; j < _items.length; j++) {
          if(alist[i].split(",")[5].toString() == _items[j].task.link){
            temptask = _items[j].task;
            tempnum = j;
            print("----alist temptask.name: " + temptask.name + "and tempnum: " + i.toString());
          }
        }
        print("temptask.name: " + temptask.name + " & tempnum: " + tempnum.toString() + " & status: " + alist[i].split(",")[3].toString());
        
        if (alist[i].split(",")[3].toString() == MyCommonConstants.complete) {
          print("-----cond 2----" + temptask.name + " is = " + MyCommonConstants.complete);
          print("-----cond 2222----" + filteredEpisodes[tempnum].videoname + " is = " + MyCommonConstants.complete);
            temptask.status = MyCommonConstants.complete;
            DownloadDatabase db = DownloadDatabase();
            if (filteredEpisodes[tempnum].iscompleted != true) {
              filteredEpisodes[tempnum].iscompleted = true;
              filteredEpisodes[tempnum].localurl = downloadStatusString.split(",")[1].toString();
              print("////////////////////filteredEpisodes[tempnum].videoname: " + filteredEpisodes[tempnum].videoname  + " | " + "filteredEpisodes[tempnum].localurl: " + filteredEpisodes[tempnum].localurl);
              print("/////////////////////filteredEpisodes[i].videoname: " + filteredEpisodes[i].videoname  + " | " + "filteredEpisodes[i].localurl: " + filteredEpisodes[i].localurl);
              db.updateMovie(filteredEpisodes[tempnum]);
              _prepare();
            }
            }
          else if (alist[i].split(",")[3].toString() == MyCommonConstants.failed) {
            //print("-----cond 3----" + temptask.name + " is = " + MyCommonConstants.failed);
            temptask.status = MyCommonConstants.failed;
          }
          //print("------------------------------------------");
      }
    }
    });
  }*/

  void setupList() async {}

  @override
  void dispose() {
    subject.close();
    WidgetsBinding.instance.removeObserver(this);
    //BackButtonInterceptor.remove(myInterceptor);
    //FlutterDownloader.registerCallback(null);
    super.dispose();
  }

  void searchDataList(query) {
    if (query.isEmpty) {
      setState(() {
        filteredEpisodes = movieCache;
      });
    }
    setState(() {});
    filteredEpisodes = filteredEpisodes
        .where((m) => m.videoname
            .toLowerCase()
            .trim()
            .contains(RegExp(r'' + query.toLowerCase().trim() + '')))
        .toList();
    setState(() {});
  }

  void onRemovePressed(_TaskInfo task, int index) {
    print("onRemovePressed----------task: " +
        task.name! +
        " ----------index: " +
        index.toString());
    // if (_items[index].task.videoTaskItem!.taskState ==VideoTaskState.DOWNLOADING ||_items[index].task.videoTaskItem!.taskState == VideoTaskState.PAUSE) {
    //   VideoDownloader.delete(task.videoTaskItem, deleteSourceFile: true);
    // }
    setState(() {});
    VideoDownloader.delete(task.videoTaskItem!, deleteSourceFile: true);
    DownloadDatabase db = DownloadDatabase();
    print("deleting----------------");
    print(filteredEpisodes.length);
    print(filteredEpisodes[index].videoname);
    print(index);
    print(filteredEpisodes.length);
    db.deleteMovie(filteredEpisodes[index].videoname);
    //filteredEpisodes.remove(filteredEpisodes[index]);

    setState(() {
      print("removing----------------");
      print(filteredEpisodes[index].videoname);
      print(index);
      print(filteredEpisodes.length);
      filteredEpisodes.remove(filteredEpisodes[index]);
    });

    /*if (
      true
      //task.status == DownloadTaskStatus.complete
      ){
      t
      _prepare();
      //_delete(task);
    }
    else{
      _cancelDownload(task);
    }*/

    //channel.invokeMethod('downloader_cancel',{"id":  task.taskId, "url": task.link, "downloadPagetype": task.downloadPagetype});

    try {
      if (task.downloadPagetype == MyCommonConstants.m3u8Downloader) {
        File videoFile = File(task.localnametask!
            .replaceAll(
                "/" +
                    task.localnametask!
                        .split("/")[task.localnametask!.split("/").length - 1],
                "")
            .trim());
        videoFile.delete(recursive: true);
        print(task.downloadPagetype! + " ///// deleted: " + videoFile.path);
      } else if (task.downloadPagetype ==
          MyCommonConstants.downloadManagerNormal) {
        File videoFile = File(task.localnametask!.trim());
        videoFile.delete(recursive: true);
        print(task.downloadPagetype! + " ///// deleted: " + videoFile.path);
      }
    } catch (e) {
      print("onRemovePressed ERROR: $e");
    }
    _prepare();
    //initState();
  }

  // GlobalKey<EasyRefreshState> _easyRefreshKey =
  //     new GlobalKey<EasyRefreshState>();
  // GlobalKey<RefreshHeaderState> _headerKey =
  //     new GlobalKey<RefreshHeaderState>();
  // GlobalKey<RefreshFooterState> _footerKey =
  //     new GlobalKey<RefreshFooterState>();

  SliverList _sliverfav() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        print("filteredEpisodes--------------------------");
        print(filteredEpisodes.length);
        print(index);
        print(filteredEpisodes[index].videoname);
        return Column(
          children: <Widget>[
            Slidable(
              actionPane: const SlidableDrawerActionPane(),
              actionExtentRatio: 0.25,
              child: GestureDetector(
                onTap: () {
                  //Navigator.push(context,MaterialPageRoute(builder: (context) => ImageCollectionsPage(url: filteredEpisodes[index].localurl),),);
                },
                child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: MyColors.primary3,
                    ),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                  alignment: const Alignment(-1, 0),
                                  child: Container(
                                    //width: 200,
                                    //padding: EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(2)),
                                      //gradient: new LinearGradient(colors: [ Colors.blue.withOpacity(0.7) ,Colors.transparent],begin: FractionalOffset.centerLeft,end: FractionalOffset.centerRight,stops: [0.5, 1.5],)
                                    ),
                                    child: Text(
                                      filteredEpisodes[index].videoname,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 5,
                                      style: MyTexStyle.tile,
                                    ),
                                  )),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                        ),
                        LinearProgressIndicator(),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                        ),
                      ],
                    )),
              ),
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: 'Remove',
                  color: MyColors.reddy,
                  icon: FeatherIcons.x,
                  closeOnTap: true,
                  onTap: () {
                    //onRemovePressed(index);
                  },
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
            )
          ],
        );
      }, childCount: filteredEpisodes.length),
    );
  }

  SliverList _sliverheading(String x) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (
          context,
          index,
        ) {
          return Container(
            width: 200,
            alignment: const Alignment(0, 0),

            // padding: EdgeInsets.all(2.0),
            child: Container(
                  width: 300,
            
                  //padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    //image: DecorationImage(image: NetworkImage('https://ya-webdesign.com/images/paint-brush-stroke-png.png')),
                    borderRadius: const BorderRadius.all(Radius.circular(2)),
                    //color: Colors.red,
                    //gradient: new LinearGradient(colors: [ Colors.blue.withOpacity(0.7) ,Colors.transparent],begin: FractionalOffset.centerLeft,end: FractionalOffset.centerRight,stops: [0.5, 1.5],)
                  ),
                  child: Text(
                    x,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    style: MyTexStyle.heading,
                  ),
                )
          );
        },
        childCount: 1,
      ),
    );
  }

  SliverList _sliverdescription(String x) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (
          context,
          index,
        ) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: ExpandablePanel(
              header: Text(
                'Note! ↴',
                style: MyTexStyle.menu,
              ),
              expanded: Text(
                x,
                style: MyTexStyle.menu,
                softWrap: true,
              ),
               collapsed: Container(),
            ),
          );
        },
        childCount: 1,
      ),
    );
  }

  SliverList _sliverTextFiled() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (
          context,
          index,
        ) {
          return TextField(
            decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                prefixIcon: Icon(EvaIcons.search,
                    color: MyColors.reddy.withOpacity(0.4)),
                hintText: "Search",
                hintStyle: TextStyle(
                    fontSize: 16,
                    color: MyColors.reddy.withOpacity(0.4),
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.none),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(0.0),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: MyColors.reddy.withOpacity(0.4), width: 2),
                  borderRadius: BorderRadius.all(
                    Radius.circular(0.0),
                  ),
                ),
                filled: true,
                fillColor: MyColors.opp1.withOpacity(0.04)),
            style: TextStyle(
                fontSize: 16,
                color: MyColors.reddy.withOpacity(0.8),
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.none),
            onChanged: (String string) => (subject.add(string)),
            keyboardType: TextInputType.url,
          );
        },
        childCount: 1,
      ),
    );
  }

  SliverList _sliverspace(double x) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (
          context,
          index,
        ) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: x),
          );
        },
        childCount: 1,
      ),
    );
  }

  Widget _buildActionForTask(_TaskInfo task) {
    //print("_buildActionForTask----------------------------------------------------------task.status: " + task.status);
    if (
        //true
        task.status == MyCommonConstants.downloadDefault) {
      //print("_buildActionForTask---------------------------------------------undefined-------------");
      return CupertinoButton(
        onPressed: () {
          channel.invokeMethod(
              'downloader', {"url": task.link, "localname": task.name});
          print(
              "button pressed ---------------------------------------------condition 1-------------");
          //Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Downloader(platform: Theme.of(context).platform, title: "Downloads",), ));
        },
        child: Icon(
          FontAwesomeIcons.download,
          color: MyColors.reddy,
          size: 18,
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        color: Colors.white,
        //shape: CircleBorder(),
        //fillColor: Colors.yellow,
        //constraints: new BoxConstraints(minHeight: 32.0, minWidth: 32.0),
      );
    } /*else if (
      //task.name == downloadStatusString.split(",")[1].toString() && task.status == MyCommonConstants.running
      task.status == MyCommonConstants.running
      ) {
      //print("_buildActionForTask---------------------------------------running-------------------");
      return new RawMaterialButton(
        onPressed: () {
          //_pauseDownload(task);
          channel.invokeMethod('downloader_cancel',{"id": task.taskId });
          setState(() {
            task.status = MyCommonConstants.undefined;
          });
          print("////downloader_pause downloader_pause: " + task.taskId.toString());
        },
        child: new Icon(Icons.pause, color: Colors.green, size: 22, ),
        shape: new CircleBorder(),
        //constraints: new BoxConstraints(minHeight: 32.0, minWidth: 32.0),
      );
    } else if (task.status == DownloadTaskStatus.paused) {
      print("_buildActionForTask-----------------------------------paused-----------------------");
      return new RawMaterialButton(
        onPressed: () {
          _resumeDownload(task);
        },
        child: new Icon(FontAwesomeIcons.play, color: Colors.green, size: 18,   ),
        shape: new CircleBorder(),
        constraints: new BoxConstraints(minHeight: 32.0, minWidth: 32.0),
      );
    } */
    else if (task.status == MyCommonConstants.downloadSuccess) {
      //print("_buildActionForTask-----------------------------------complete-----------------------");
      return Row(
        children: [
          const Text(
            'Completed',
            style: TextStyle(color: Colors.purple),
          ),
          /*RawMaterialButton(
            onPressed: () {
              _delete(task);
            },
            child: Icon(CupertinoIcons.delete_solid,color: Colors.red,),
            shape: new CircleBorder(),
            constraints: new BoxConstraints(minHeight: 32.0, minWidth: 32.0),
          )*/
        ],
      );
    }
    else{
      return const Text(
            'ELSE CONDIION',
            style: TextStyle(color: Colors.purple),
          );

    }
    /*else if (task.status == DownloadTaskStatus.canceled) {
      print("_buildActionForTask----------------------------canceled------------------------------");
      return new Text('Canceled', style: new TextStyle(color: Colors.red));
    } else if (task.status == DownloadTaskStatus.failed) {
      print("_buildActionForTask----------------------------------failed------------------------");
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          new Text('Failed', style: new TextStyle(color: Colors.red)),
          RawMaterialButton(
            onPressed: () {
              _retryDownload(task);
            },
            child: Icon(
              FeatherIcons.refreshCw,
              color: Colors.green,
            ),
            shape: new CircleBorder(),
            constraints: new BoxConstraints(minHeight: 32.0, minWidth: 32.0),
          )
        ],
      );
    } else {
      print("_buildActionForTask---------------------------------nulll-------------------------");
      return null;
    }*/
  }


   /* void _showDialogFlash() {
    FlashHelper.simpleDialog(
      context,
      title: 'Flash Dialog',
      message:
          '⚡️A highly customizable, powerful and easy-to-use alerting library for Flutter.',
      negativeAction: (context, controller, setState) {
        return FlatButton(
          child: Text('NO'),
          onPressed: () => controller.dismiss(),
        );
      },
      positiveAction: (context, controller, setState) {
        return FlatButton(
          child: Text('YES'),
          onPressed: () => controller.dismiss(),
        );
      },
    );
  }*/



  void _showDownloadSlideDialog(String finalstring) async {

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;


  await NAlertDialog(
                //title: Text("Test"),
                content: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, 
                              children: [
                                Container(
                                  //width: w,
                                  //height: 85.0 + 10,
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    /*boxShadow: <BoxShadow>[
                                      new BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        offset: new Offset(0.0, 2.0),
                                        blurRadius: 10.0,
                                      )
                                    ],*/
                                    borderRadius:BorderRadius.all(Radius.circular(20)),
                                    color: MyColors.primary3,
                                  ),
                                  child: Container(
                                    //height: 100,
                                    //color: Colors.red,
                                    child: Row(
                                      children: [
                                        Container(
                                        height: 85,
                                        width: 85,
                                        decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(15)),
                                            image: DecorationImage(
                                                image: AssetImage('assets/vlclogo.png'),fit: BoxFit.fill)),
                                      ),
                                        Expanded(
                                      flex: 2,
                                          child: Center(child: CupertinoButton(
                                              onPressed: () {
                                                launch("https://play.google.com/store/apps/details?id=org.videolan.vlc");
                                              },
                                              child: Text("Get it on Play Store➚",
                                                  style: MyTexStyle.menu),
                                              color: MyColors.primary1,
                                              minSize: 3,
                                              padding: EdgeInsets.all(5),
                                            ),)),
                                      ],
                                    ) 
                                  ),
                                ),
                                Padding(padding: EdgeInsets.all(2.5)), 
                                Row(
                                  children: [
                                    Expanded( flex: 5,
                                      child: CupertinoButton(
                                                  onPressed: () async {
                                                    Clipboard.setData(new ClipboardData(text: finalstring));
                                          toast.Fluttertoast.showToast(
                                              msg: finalstring,
                                              toastLength: toast.Toast.LENGTH_LONG,
                                              gravity: toast.ToastGravity.BOTTOM);
                                    // await PlayerPlugin.openWithVlcPlayer(finalstring);
                                    ExternalVideoPlayerLauncher.launchVlcPlayer(
                                    finalstring.trim(), MIME.applicationXMpegURL, {
                                  "title":  "",});
                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.center,
                                                    children: <Widget>[
                                                      Text('Play in VLC', style: TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.white.withOpacity(1),
                                                            fontWeight: FontWeight.w400,
                                                            decoration: TextDecoration.none),
                                      
                                                          ),
                                                      //Icon(LineIcons.download,size: 30, color: MyColors.opp1,),
                                                    ],
                                                  ),
                                                  color: Color(0xFF695dfc),
                                                  //borderRadius: BorderRadius.all(Radius.circular(15)),
                                                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                ),
                                    ),
                                    Expanded(
                                    flex: 1,
                                    child: CupertinoButton(
                                      onPressed: () async {
                                        await OpenFile.open(finalstring,
                                            type: "audio/x-mpegurl");
                                      },
                                      child: Icon(FeatherIcons.share,
                                          size: 18,
                                          color: MyColors.opp1
                                          ),
                                      //color: Colors.black.withOpacity(1),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                    ),
                                  ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                dismissable: true,
                backgroundColor: MyColors.primary1.withOpacity(0.3),
                dialogStyle: DialogStyle(
                  // animatePopup: true, 
                  backgroundColor: Colors.transparent, elevation: 0, ),
                blur: 15,
              ).show(context);

/*
    slideDialog.showSlideDialog(
      context: context,
      barrierDismissible: true,
      //barrierColor: MyColors.primary2.withOpacity(.9),
      pillColor: Colors.red,
      backgroundColor: MyColors.primary2,
      child: new Container(
          width: w,
          height: h,
          alignment: Alignment.topCenter,
          //color: Colors.red,
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (
                    context,
                    index,
                  ) {
                    return Column(
                      children: [
                        Text(
                          "Play Using",
                          textAlign: TextAlign.center,
                          style: MyTexStyle.small
                        ),
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Container(
                            width: w,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    child: Image(
                                  image: NetworkToFileImage(
                                      url:
                                          'https://i.postimg.cc/9fnnR37w/Vlc.png',
                                      file: fileFromDocsDir('Vlc.png'),
                                      debug: false),
                                  height: 100,
                                )),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                ),
                                CupertinoButton(
                                  onPressed: () {
                                    launch("https://play.google.com/store/apps/details?id=org.videolan.vlc");
                                  },
                                  child: Text(
                                    "Get it on Play Store➚",
                                    style: MyTexStyle.infobutton,
                                  ),
                                  color: Colors.orange[700],
                                  minSize: 5,
                                  padding: EdgeInsets.all(5),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                flex: 5,
                                child: new CupertinoButton(
                                  onPressed: () async {
                                    await PlayerPlugin.openWithVlcPlayer(finalstring);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        ' Play in VLC',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: MyColors.primary1.withOpacity(1),
                                          fontWeight: FontWeight.w500,
                                          decoration: TextDecoration.none),
                                      ),
                                      /*Icon(
                                        GroovinMaterialIcons.play,
                                        size: 30,
                                        color: MyColors.primary1,
                                      ),*/
                                    ],
                                  ),
                                  color: Colors.red,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                ),
                              ),
                              Padding(padding: EdgeInsets.all(5)),
                              Expanded(
                                flex: 1,
                                child: new CupertinoButton(
                                  onPressed: () async {
                                    await OpenFile.open(finalstring,
                                        type: "audio/x-mpegurl");
                                  },
                                  child: Icon(FeatherIcons.share,
                                      size: 30,
                                      color: Colors.red.withOpacity(0.5)),
                                  //color: Colors.black.withOpacity(1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 60),
                        ),
                      ],
                    );
                  },
                  childCount: 1,
                ),
              ),
            ],
          )),
    );*/
  }


  getboltdownloadscount() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    boltdowncnt =  preferences.getInt("boltdownloadscount") ?? 2;
    print("getboltdownloadscount : " + boltdowncnt.toString());
    setState(() {
      boltdowncnt = boltdowncnt;
    });

  }

  getADDrewboltdowns(int sec) async {  ////Add +5

      var internetcc = await (Connectivity().checkConnectivity());
      if(internetcc.toString() != 'ConnectivityResult.none'){
       
       
        // String resavailavle = await MyCommonConstants().videoAd(5555); ////check if ads avilable 
        String resavailavle = ''; ////check if ads avilable 
        print('resavailavle : '+  resavailavle.toString());
        if(
          true
          // resavailavle == 'ads_available'
        ){

          // String res = await MyCommonConstants().videoAd(1);
          String res = '';
          if(true
            // res == 'rewardAd_COMPLETED' || res == 'interstitialAd_COMPLETED'
            ){
            print("sucesssssss");
          }
          else{
            print("failllled ad res: "  + res.toString());
          }
          
          shownumberboltdownsflash('+5');
          
          Future.delayed(Duration(seconds: sec), () async {
              SharedPreferences preferences = await SharedPreferences.getInstance();
              int boltdowncnttmp = boltdowncnt + 5;
              await preferences.setInt("boltdownloadscount", boltdowncnttmp);
              getboltdownloadscount();
              });


        }


      }
      else{
        print('NOT CONNECTED TO INTERNET internetcc : '+  internetcc.toString());
      }



  }

  use1boltdowns() async {   //// -1
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int boltdowncnttmp = boltdowncnt - 1;
    await preferences.setInt("boltdownloadscount", boltdowncnttmp);
    getboltdownloadscount();
    shownumberboltdownsflash('-1');

  }

  shownumberboltdownsflash(String x){
        MyCommonConstants().showCenterFlash(
      context: context,
      alignment: Alignment.center,
      duration: 1,
      width: 45,
      height: 45,
      backgroundColor: MyColors.primary3,
      // borderColor: MyColors.primary3,
      childwidget: FittedBox(
        child: Center(
          child: Row(
                crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, 
                children: [
                  Text(x, 
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.orange,
                    fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.center,
                    ),
                  Icon(FontAwesomeIcons.bolt, color: Colors.orange, size: 23,),
                ],
              ),
              ),
      ),
            );  

  }

  Future<dynamic> _gotoDirectLinkPage(Widget pgbuilder) async {
    Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => pgbuilder,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(0.0, 1.0);
          var end = Offset.zero;
          var curve = Curves.easeIn;
          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(
            curve: curve,
          ));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: Duration(seconds: 1)));
    //imageCache.clear();
  }

  int speed = 30000;

  int random(min, max) {
    var rn = Random();
    return min + rn.nextInt(max - min);
  }

  Widget videothumb(String theme){
    return Container(
      height: 80,
      width: 80,
    );
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    //print("------------------------------_permissisonReady: " + _permissisonReady.toString());

    /*Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        speed = random(30000, 300000000);
        //print("speed = "+ speed.toString());
      });
  });*/

    return Scaffold(
        /*appBar: AppBar(
          backgroundColor: MyColors.primary3,
          title: Text('Downloads', style: MyTexStyle.tile),
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          leading: IconButton(
              onPressed: () {
                //Get.back();
              },
              icon: Icon(EvaIcons.menu)),
        ),*/
        //drawer: CustomDrawer(),
        drawer: CustomDrawer(
          isReviewFinal: false,
        ),
        key: _myhomepagescafoldkey,
        /*floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Transform.scale(
                scale: 0.65,
                child: FloatingActionButton(
                  heroTag: "btn1",
                  backgroundColor: Colors.pink,
                  onPressed: () {
                    //MyCommonConstants().videoAd(1);
                  },
                  child: Icon(GroovinMaterialIcons.video),
                ),
              ),
              FloatingActionButton.extended(
                heroTag: "btn2",
                backgroundColor: Colors.yellow,
                elevation: 1,
                onPressed: () async {
                  var arguments = DownloadsArguments('', '', '', '', '');
                  await Get.to(DownloadFromShareInPage(
                    downloadsArguments: arguments,
                  ));
                },
                label: Text(
                  'NEW',
                ),
                icon: Icon(
                  Icons.file_download,
                  color: Colors.black,
                  size: Theme.of(context).textTheme.headline6.fontSize,
                ),
              )
            ],
          ),
        ),*/
        body: _isLoading
            ? Container(
                color: MyColors.primary1,
                child:  Center(
                  child:  CircularProgressIndicator(),
                ),
              )
            : _permissisonReady
                ?  LiquidPullToRefresh(
                    showChildOpacityTransition: false,
                    color: Colors.blue, 
                    onRefresh: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Downloader(
                              title: "Downloads",
                            ),
                          ));
                      MyCommonConstants().setSystemUI();
                      throw 'throwed';
                    },
                    child: 
                    /*(isFullIntent)
                        ? Container(
                            height: h,
                            width: w,
                            color: MyColors.primary1,
                            child: Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 50),
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Video added👍\n\nGo back to Video Download Manager\nand refresh',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: MyColors.opp1,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 5,
                                        ),
                                    /*Icon(
                                      EvaIcons.arrowRight,
                                      color: MyColors.opp1,
                                    )*/
                                  ],
                                ),
                              ),
                            ),
                          )
                        : */
                        Column(
                            children: [
                              Container(
                                  height: h - 125 - 30 - 40 + 30 + 55 - 5,
                                  width: w,
                                  color: MyColors.primary1,
                                  child: SafeArea(
                                    child: Stack(
                                      children: <Widget>[
                                        Container(
                                          //padding: EdgeInsets.symmetric(horizontal: 20),
                                          height: h,
                                          width: w,
                                          child: CustomScrollView(
                                                slivers: <Widget>[
                                                  _sliverspace(5),
                                                  _sliverheading("Downloads"),
                                                  // _sliverspace(10),
                                                  // _sliverdescription("**The download links expire within 60mins from adding them to Downloads. Prefer to download no more than 3 videos at once.\n**You can Directly download or Delete downloads by swiping the item left.\n**Direct Download option is only available for MP4 videos and not for M3U8 videos.\n**M3U8 video can be downloaded using an external app\n**Uninstalling the app will delete all your downloads."),
                                                  _sliverspace(5),
                                                  SliverList(
                                                    delegate:SliverChildBuilderDelegate(
                                                      (context, index) {
                                                        for (var i = 0;i < _items.length;i++) {
                                                          // print('_items.length: + ${_items.length}');
                                                          // print(i.toString() +")    ---------_tasks.name: " +_items[i].task.name!);
                                                          // print(i.toString() +")    ---------_tasks.status: " +_items[i].task.status);
                                                        }
                                                        // try {
                                                          return Padding(
                                                            padding:const EdgeInsets.symmetric(horizontal: 10),
                                                            child:  Padding(
                                                              padding: EdgeInsets.symmetric(vertical: 5),
                                                              child: Slidable(
                                                                //key: _slidablekey,
                                                                actionPane: const SlidableDrawerActionPane(),
                                                                actionExtentRatio:0.25,
                                                                // ignore: sort_child_properties_last
                                                                // child: Text('dheer'),
                                                               child: GestureDetector(
                                                                  onTap: () async {
                                                                    if (_items[index].task.isComp!) {
                                                                      print("--ontap: " +_tasks[index].localnametask! +'\n_items[index].task.videoTaskItem.taskStateString(): ' +_items[index].task.videoTaskItem!.taskStateString());
                                                                      //await PlayerPlugin.openWithVlcPlayer(_tasks[index].localnametask);
                                                                      _showDownloadSlideDialog(_tasks[index].localnametask!);
                                                                    }
                                          
                                                                    //_openDownloadedFile(_tasks[index].videoTaskItem.filePath);
                                                                    /*if (_items[index].task.isComp ==true) {
                                                                    channel.invokeMethod('playmethod',_tasks[index].localnametask,);
                                                                    //await PlayerPlugin.openWithVlcPlayer("/storage/emulated/0/Download/ssshls/local.m3u8");
                                                                    /*_openDownloadedFile(_tasks[index].videoTaskItem.filePath)
                                                                .then((success) {
                                                              if (!success) {
                                                                Scaffold.of(context)
                                                                    .showSnackBar(SnackBar(
                                                                        content: Text(
                                                                            'Cannot open this file')));
                                                              }
                                                            });*/
                                                                  }*/
                                                                  },
                                                                  child: Container(
                                                                    //height: 100,
                                                                    decoration:BoxDecoration(
                                                                      boxShadow: <BoxShadow>[BoxShadow(color: Colors.black.withOpacity(0.1),offset: const Offset(0.0,2.0),blurRadius:10.0,)
                                                                      ],
                                                                      borderRadius:const BorderRadius.all(Radius.circular(15)),
                                                                      color: MyColors
                                                                          .primary3,
                                                                    ),
                                                                    child: Column(
                                                                      children: <Widget>[
                                                                        const Padding(padding: EdgeInsets.symmetric(vertical:5),),
                                                                        Row(
                                                                          children: <
                                                                              Widget>[
                                                                            const Padding(padding:EdgeInsets.symmetric(horizontal: 5),),
                                                                            Stack(
                                                                              children: <
                                                                                  Widget>[
                                                                                /*Container(
                                                                                  height: 80,
                                                                                  width: 80,
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                                                                                    image: DecorationImage(
                                                                                      colorFilter: (MyColors.themename == "theme2")? (_items[index].task.isComp == false)? ColorFilter.mode(Colors.white.withOpacity(0.9), BlendMode.lighten): null: (_items[index].task.isComp == false)? ColorFilter.mode(Colors.black.withOpacity(0.9), BlendMode.multiply): null,
                                                                                      //image: NetworkImage(_items[index].task.image),
                                                                                      // ignore: prefer_const_constructors
                                                                                      image: (_items[index].task.image == 'EMPTY') ? ((MyColors.themename == "theme2") ? 
                                                                                      AssetImage('assets/videothumblight.png') : 
                                                                                      AssetImage('assets/videothumbdark.png')) 
                                                                                      :AssetImage('assets/videothumbdark.png'),
                                                                                          // ignore: prefer_const_constructors
                                                                                          // : NetworkImage(
                                                                                          //   _items[index].task.image!,
                                                                                          //     //file: fileFromDocsDir(_items[index].task.image.split("/")[_items[index].task.image.split("/").length-1]),
                                                                                          //     // file: fileFromDocsDir(_items[index].task.image!.split("/")[_items[index].task.image!.split("/").length - 1]),
                                                                                          //     // debug: true,
                                                                                          //   ),
                                                                                      fit: BoxFit.cover,
                                                                                    ),
                                                                                  ),
                                                                                  padding: EdgeInsets.all(5.0),
                                                                                  //decoration: BoxDecoration(boxShadow:<BoxShadow>[new BoxShadow(color: const Color.fromARGB(50, 0, 0, 0),offset: new Offset(0.0, 0.0),blurRadius: 0.0)]),
                                                                                ),*/
                                                                                // colorFilter: (MyColors.themename == "theme2")? (_items[index].task.isComp == false)? 
                                                                                // ColorFilter.mode(Colors.white.withOpacity(0.9), BlendMode.lighten): null: 
                                                                                // (_items[index].task.isComp == false)? ColorFilter.mode(Colors.black.withOpacity(0.9), BlendMode.multiply): null,
                                                                                Container(
                                                                                  height: 80,
                                                                                  width: 80,
                                                                                  decoration: BoxDecoration(
                                                                                    color: MyColors.opp1.withOpacity(0.05),
                                                                                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                                                                                    ),
                                                                                  // padding: EdgeInsets.all(5.0),
                                                                                  child: Icon(Ionicons.play, color: Colors.red, size: 35)
                                                                                  //decoration: BoxDecoration(boxShadow:<BoxShadow>[new BoxShadow(color: const Color.fromARGB(50, 0, 0, 0),offset: new Offset(0.0, 0.0),blurRadius: 0.0)]),
                                                                                ),
                                                                                
                                                                                Container(
                                                                                  height: 80,
                                                                                  width: 80,
                                                                                  decoration: BoxDecoration(
                                                                                    color: (MyColors.themename == "theme2") ? 
                                                                                    (_items[index].task.isComp == false) ? MyColors.primary1.withOpacity(1): MyColors.primary1.withOpacity(0.0): (_items[index].task.isComp == false)? MyColors.primary1.withOpacity(1) : MyColors.primary1.withOpacity(0.0),
                                                                                    // MyColors.opp1,
                                                                                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                                                                                    ),
                                                                                  // padding: EdgeInsets.all(5.0),
                                                                                ),
                                                                                
                                                                                //(_items[index].task.status != MyCommonConstants.complete && _items[index].task.status != MyCommonConstants.running) ?
                                                                                ((_items[index].task.videoTaskItem!.taskStateString() == MyCommonConstants.downloadDefault || _items[index].task.videoTaskItem!.taskStateString() == MyCommonConstants.downloadStart || _items[index].task.videoTaskItem!.taskStateString() == MyCommonConstants.downloadPending || _items[index].task.status == MyCommonConstants.downloadError) && _items[index].task.isComp == false)
                                                                                    ? GestureDetector(
                                                                                        onTap: () {
                                                                                          if(boltdowncnt >= 1){
                                                                                          use1boltdowns();
                                                                                          print(" ---------------------------------------------download pressed-------------\n" + _items[index].task.videoTaskItem!.url);
                                          
                                                                                          late Map<String, String> headers;
                                                                                          try {
                                                                                            final headersInput = _items[index].task.headerString!.trim();
                                                                                            if (headersInput.isNotEmpty) {
                                                                                              try {
                                                                                                var headersMap = <String, String>{};
                                                                                                var splitHeaders = headersInput.split('|||');
                                                                                                for (var i = 0; i < splitHeaders.length; i++) {
                                                                                                  var singleEntries = splitHeaders[i].split('&&&');
                                                                                                  headersMap[singleEntries[0]] = singleEntries[1];
                                                                                                }
                                                                                                headers = headersMap;
                                                                                              } catch (e) {
                                                                                                headers = {
                                                                                                  // "Accept": "application/json",
                                                                                                  // 'User-Agent': 'Mozilla/5.0 ( compatible )',
                                                                                                  "User-Agent": "animdl/1.5.84",
                                                                                                };
                                                                                              }
                                                                                            } else {
                                                                                              headers = {
                                                                                                // "Accept": "application/json",
                                                                                                  // 'User-Agent': 'Mozilla/5.0 ( compatible )',
                                                                                                  "User-Agent": "animdl/1.5.84",
                                                                                              };
                                                                                            }
                                                                                          } catch (e) {
                                                                                            print("error on headers parse: $e" );
                                                                                          }
                                          
                                                                                          if (!headers.containsKey('User-Agent')) {
                                                                                            Map<String, String> useragentheader = {
                                                                                              // 'User-Agent': 'Mozilla/5.0 ( compatible )'
                                                                                              "User-Agent": "animdl/1.5.84"
                                                                                            };
                                                                                            headers.addAll(useragentheader);
                                                                                          }
                                          
                                                                                          print('*******************headers: $headers');
                                                                                          //if (_items[index].task.downloadPagetype.trim() == MyCommonConstants.m3u8Downloader) {
                                                                                          VideoDownloader.startDownloadWithHeader(
                                                                                            _items[index].task.videoTaskItem!,
                                                                                            headers: headers,
                                                                                            /*{
                                                                                                // "Accept": "application/json",
                                                                                                // "Referer": "http://vidstreaming.io/",
                                                                                                // "X-Requested-With": "XMLHttpRequest",
                                                                                                // 'User-Agent': 'Mozilla/5.0 ( compatible )'
                                                                                              }*/
                                                                                          );
                                          
                                                                                          /*var finalstring =
                                                                                              _items[index].task.link.trim()+","
                                                                                              +_items[index].task.image+","
                                                                                              +_items[index].name.replaceAll('.mp4', "").replaceAll('m3u8', "").trim()+","
                                                                                              +'Accept&&&application/json|||Referer&&&http://vidstreaming.io/|||X-Requested-With&&&XMLHttpRequest'+","
                                                                                        
                                                                                              +"isgrabbedtrue";
                                          
                                                                                          _showDownloadSlideDialog(finalstring);*/
                                          
                                                                                          //}
                                                                                          /*else {
                                                                                              VideoDownloader.startDownload(_items[index].task.videoTaskItem);
                                                                                            }*/
                                                                                            Future.delayed(const Duration(seconds: 2), () {
                                          
                                                                                              MyCommonConstants().showCenterFlash(
                                                                                                context: context,
                                                                                                alignment: Alignment.center,
                                                                                                duration: 5,
                                                                                                width: w - 80,
                                                                                                height: 120,
                                                                                                backgroundColor: MyColors.primary3,
                                                                                                childwidget: Center(
                                                                                              child: Column(
                                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                                children: <Widget>[
                                                                                                  //Icon(FontAwesomeIcons.check, color: Colors.red, size: 50,),
                                                                                                  RichText(
                                                                                                    softWrap: true,
                                                                                                    textAlign: TextAlign.center,
                                                                                                    text: TextSpan(style: MyTexStyle.menu, children: <TextSpan>[
                                                                                                      TextSpan(text: 'Added ',),
                                                                                                      TextSpan(text: (_items[index].task.isGrabbed!) ? MyCommonConstants().getTitleName(_items[index].task.name!) + " " + MyCommonConstants().getEpisodeNumber(_items[index].task.name!) : _items[index].task.name.toString(), style: TextStyle(color: MyColors.reddy)),
                                                                                                      TextSpan(text: ' to download queue'),
                                                                                                      TextSpan(text: "\n\n If download doesn't start in a few seconds, clear from RAM and restart the app " ,style: TextStyle(color: MyColors.primary1.withOpacity(1), fontSize: 12, backgroundColor: Colors.yellow, fontWeight: FontWeight.w600)),
                                                                                                    ]),
                                                                                                  ),
                                                                                                  /*Text('\nAdded '
                                                                        + _items[index].task.name.toString().replaceAll(_items[index].task.name.toString().split("_")[_items[index].task.name.toString().split("_").length - 1], "").replaceAll("_", " ").trim()
                                                                        + " " + _items[index].task.name.toString().split("_")[_items[index].task.name.toString().split("_").length - 1].split("(")[1].split(")")[0].replaceAll("-", " ").trim()
                                                                        + ' to download queue',
                                                                        textAlign: TextAlign.center),*/
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                                );
                                                                                            
                                                                                          Future.delayed(const Duration(seconds: 9), () {
                                                                                            setState(() {
                                                                                              MyCommonConstants().setSystemUI();
                                                                                            });
                                                                                          });
                                                                                          });
                                                                                          
                                          
                                                                                          //Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Downloader(platform: Theme.of(context).platform, title: "Downloads",), ));
                                          
                                                                                          }
                                                                                          else{
                                                                              MyCommonConstants().showCenterFlash(
                                                                                    context: context,
                                                                                    alignment: Alignment.center,
                                                                                    duration: 1,
                                                                                    width: 150,
                                                                                    height: 45,
                                                                                    backgroundColor: MyColors.primary3,
                                                                                    // borderColor: MyColors.primary3,
                                                                                    childwidget: Center(
                                                                                      child: Row(
                                                                                            crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, 
                                                                                            children: [
                                                                                              Text('Get more', 
                                                                                              style: TextStyle(
                                                                                                fontSize: 18,
                                                                                                color: MyColors.opp1,
                                                                                                fontWeight: FontWeight.w400,
                                                                                                ),
                                                                                                textAlign: TextAlign.center,
                                                                                                ),
                                                                                              Icon(FontAwesomeIcons.bolt, color: Colors.orange, size: 23,),
                                                                                            ],
                                                                                          ),
                                                                                          ),
                                                                                          );                                                                                        }
                                                                                        },
                                                                                        child: Container(
                                                                                          height: 80,
                                                                                          width: 80,
                                                                                          decoration: BoxDecoration(
                                                                                            borderRadius: const BorderRadius.all(Radius.circular(15)),
                                                                                          ),
                                                                                          child: (_items[index].task.status == MyCommonConstants.downloadError)
                                                                                              ? Icon(
                                                                                                  EvaIcons.closeCircleOutline,
                                                                                                  color: Colors.red,
                                                                                                )
                                                                                              : (_items[index].task.status == MyCommonConstants.downloadDefault)
                                                                                                  ? Icon(
                                                                                                      EvaIcons.arrowCircleDownOutline,
                                                                                                      size: 30,
                                                                                                      color: Colors.blue,
                                                                                                    )
                                                                                                  : (_items[index].task.videoTaskItem!.taskStateString() == MyCommonConstants.downloadPending || _items[index].task.videoTaskItem!.taskStateString() == MyCommonConstants.downloadStart)
                                                                                                      ? Icon(
                                                                                                          FontAwesomeIcons.spinner,
                                                                                                          color: Colors.blue,
                                                                                                        )
                                                                                                      : (_items[index].task.videoTaskItem!.taskStateString() == MyCommonConstants.downloadPause)
                                                                                                          ? Icon(
                                                                                                              EvaIcons.pauseCircle,
                                                                                                              color: Colors.blue,
                                                                                                            )
                                                                                                          : null,
                                                                                          padding: EdgeInsets.all(2.0),
                                                                                          //decoration: BoxDecoration(boxShadow:<BoxShadow>[new BoxShadow(color: const Color.fromARGB(50, 0, 0, 0),offset: new Offset(0.0, 0.0),blurRadius: 0.0)]),
                                                                                        ),
                                                                                      )
                                                                                    : Container(),
                                                                                    // : Padding(
                                                                                    //     padding: EdgeInsets.all(0),
                                                                                    //     child: Text(_items[index].task.videoTaskItem!.taskStateString(), style: MyTexStyle.menu,),
                                                                                    //   ),
                                                                                //(_items[index].task.status == MyCommonConstants.downloadDownloading || _items[index].task.status == MyCommonConstants.downloadPause) ?
                                                                                (_items[index].task.videoTaskItem!.taskState == VideoTaskState.DOWNLOADING || _items[index].task.videoTaskItem!.taskState == VideoTaskState.PAUSE)
                                                                                    ? Container(
                                                                                        height: 80,
                                                                                        width: 80,
                                                                                        decoration: BoxDecoration(
                                                                                          borderRadius: const BorderRadius.all(Radius.circular(15)),
                                                                                        ),
                                                                                        child: Column(
                                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                          children: <Widget>[
                                                                                            /*Text((
                                                                    (downloadStatusString.trim() != "TaskID=ABC") ? 
                                                                          ((downloadStatusString.split(",")[1].toString() == _items[index].task.name.toString()) 
                                                                          ? int.parse(downloadStatusString.split(",")[2])
                                                                          : 0 )
                                                                          : 0)
                                                                          .toString() + "%", style: new TextStyle(fontSize: 14, color: MyColors.opp1,  fontWeight: FontWeight.w500, ),),*/
                                                                                            //Text(_items[index].task.progress.toString()+ "%", style: new TextStyle(fontSize: 14, color: MyColors.opp1,  fontWeight: FontWeight.w500, ),),
                                                                                            Text(
                                                                                              _items[index].task.videoTaskItem!.percent!.toInt().round().toString() + "%",
                                                                                              style: TextStyle(
                                                                                                fontSize: 14,
                                                                                                color: MyColors.opp1,
                                                                                                fontWeight: FontWeight.w500,
                                                                                              ),
                                                                                            ),
                                                                                            Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                                                                                            LinearPercentIndicator(
                                                                                              //width: 140.0,
                                                                                              lineHeight: 7.0,
                                                                                              percent: /*(
                                                                              (downloadStatusString.trim() != "TaskID=ABC") ? 
                                                                                ((downloadStatusString.split(",")[5].toString() == _items[index].task.link.toString() ) 
                                                                                ? int.parse(downloadStatusString.split(",")[2])/100
                                                                                : 0 )
                                                                                : 0
                                                                                )*/
                                                                                                  (_items[index].task.videoTaskItem!.percent!) / 100,
                                                                                              backgroundColor: Colors.white,
                                                                                              progressColor: Colors.blue,
                                                                                            ),
                                                                                            Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                                                                                          ],
                                                                                        ),
                                                                                        padding: EdgeInsets.all(5.0),
                                                                                      ) : Container()
                                                                                    // : Padding(padding: EdgeInsets.all(2),
                                                                                    // child: Text(_items[index].task.videoTaskItem!.taskState.toString(), style: MyTexStyle.menu,),
                                                                                    // ),
                                                                              ],
                                                                            ),
                                                                            //Text('hebb'),
                                                                            Padding(padding:EdgeInsets.symmetric(horizontal: 5),),
                                                                            Expanded(
                                                                              flex:3,
                                                                              child:Column(
                                                                                children: <Widget>[
                                                                                  Container(
                                                                                    //height: 80,
                                                                                    //padding: EdgeInsets.all(5),
                                                                                    //decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(6)),color: MyColors.opp1.withOpacity(0.01),),
                                                                                    alignment: const Alignment(-1, -1),
                                                                                    child: Container(
                                                                                      child: Text(
                                                                                        // MyCommonConstants().getTitleName(_items[index].task.name!),
                                                                                        (_items[index].task.isGrabbed!) ? MyCommonConstants().getTitleName(_items[index].task.name!) : _items[index].task.name.toString(),
                                                                                        //index.toString(),
                                                                                        softWrap: true,
                                                                                        textAlign: TextAlign.left,
                                                                                        overflow: TextOverflow.ellipsis,
                                                                                        maxLines: 2,
                                                                                        style: TextStyle(
                                                                                          fontSize: 18,
                                                                                          color: MyColors.opp1,
                                                                                          fontWeight: FontWeight.w600,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: EdgeInsets.symmetric(vertical: 4),
                                                                                  ),
                                                                                  Row(
                                                                                    children: <Widget>[
                                                                                      if (_items[index].task.isGrabbed!) ...[
                                                                                        (MyCommonConstants().getEpisodeNumber(_items[index].task.name!) == '') ? Container() : Container(
                                                                                          alignment: const Alignment(-1, -1),
                                                                                          child: Container(
                                                                                            //width: 200,
                                                                                            padding: EdgeInsets.all(2.0),
                                                                                            decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(2)), color: MyColors.reddy
                                                                                                //gradient: new LinearGradient(colors: [ Colors.red.withOpacity(0.7) ,Colors.transparent],begin: FractionalOffset.centerLeft,end: FractionalOffset.centerRight,stops: [0.5, 1.5],)
                                                                                                ),
                                                                                            child: Text(
                                                                                              // _items[index].task.name!,
                                                                                              MyCommonConstants().getEpisodeNumber(_items[index].task.name!),
                                                                                              softWrap: true,
                                                                                              overflow: TextOverflow.ellipsis,
                                                                                              maxLines: 1,
                                                                                              style: MyTexStyle.infobutton,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        Padding(padding: EdgeInsets.symmetric(horizontal: 2),),
                                                                                        (MyCommonConstants().getQuality(_items[index].task.name!) == '') ? Container() : Container(
                                                                                          alignment: const Alignment(-1, -1),
                                                                                          child: Container(
                                                                                            //width: 200,
                                                                                            padding: EdgeInsets.all(2.0),
                                                                                            decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(2)), color: MyColors.purp
                                                                                                //gradient: new LinearGradient(colors: [ Colors.red.withOpacity(0.7) ,Colors.transparent],begin: FractionalOffset.centerLeft,end: FractionalOffset.centerRight,stops: [0.5, 1.5],)
                                                                                                ),
                                                                                            child: Text(
                                                                                              // _items[index].task.name!,
                                                                                              MyCommonConstants().getQuality(_items[index].task.name!),
                                                                                              softWrap: true,
                                                                                              overflow: TextOverflow.ellipsis,
                                                                                              maxLines: 1,
                                                                                              style: MyTexStyle.infobutton,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        Padding(padding: EdgeInsets.symmetric(horizontal: 2),),
                                                                                      ],
                                                                                      if (_items[index].task.status != MyCommonConstants.downloadDefault && _items[index].task.status != MyCommonConstants.downloadError && _items[index].task.status != MyCommonConstants.downloadSuccess) ...[
                                                                                        Expanded(
                                                                                          child: Row(
                                                                                            crossAxisAlignment: CrossAxisAlignment.end,
                                                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                                                            children: [
                                                                                              GestureDetector(
                                                                                                  onTap: () {
                                                                                                    setState(() {
                                                                                                      _items[index].isExpanded = !_items[index].isExpanded;
                                                                                                    });
                                                                                                  },
                                                                                                  //color: Colors.red,
                                                                                                  child: Icon(EvaIcons.chevronDownOutline, color: Colors.yellow.withOpacity(0.5), size: 22))
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                        Padding(padding: EdgeInsets.symmetric(horizontal: 2),),
                                                                                      ],
                                                                                      Padding(padding: EdgeInsets.symmetric(horizontal: 2),),
                                                                                      (_items[index].task.isComp == true)
                                                                                          ? Container(
                                                                                              alignment: Alignment(1, 1),
                                                                                              decoration: BoxDecoration(
                                                                                                borderRadius: const BorderRadius.all(Radius.circular(15)),
                                                                                              ),
                                                                                              child: Icon(
                                                                                                EvaIcons.doneAll,
                                                                                                color: Colors.blue,
                                                                                              ),
                                                                                              padding: EdgeInsets.all(2.0),
                                                                                              //decoration: BoxDecoration(boxShadow:<BoxShadow>[new BoxShadow(color: const Color.fromARGB(50, 0, 0, 0),offset: new Offset(0.0, 0.0),blurRadius: 0.0)]),
                                                                                            )
                                                                                          : Padding(
                                                                                              padding: EdgeInsets.all(0),
                                                                                            )
                                                                                    ],
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Padding(padding:EdgeInsets.symmetric(horizontal: 5),),
                                                                          ],
                                                                        ),
                                                                        Padding(padding: EdgeInsets.symmetric(vertical:5),),
                                                                        if (_items[index].isExpanded) ...[
                                                                          //if (true)...[
                                                                          if (_items[index].task.videoTaskItem!.taskState ==VideoTaskState.DOWNLOADING ||_items[index].task.videoTaskItem!.taskState ==VideoTaskState.PAUSE) ...[
                                                                            Row(
                                                                              //crossAxisAlignment: CrossAxisAlignment.stretch,
                                                                              mainAxisAlignment:
                                                                                  MainAxisAlignment.spaceAround,
                                                                              children: [
                                                                                //Padding(padding: EdgeInsets.only(left: 5),),
                                                                                Row(
                                                                                  children: [
                                                                                    Icon(FontAwesomeIcons.video, color: Colors.blue, size: 22),
                                                                                    if (_items[index].task.videoTaskItem!.mimeType.toString() != 'null') ...[
                                                                                      if (_items[index].task.videoTaskItem!.mimeType.toString() == 'm3u8') ...[
                                                                                        Container(
                                                                                          // padding: EdgeInsets.all(2),
                                                                                          // decoration: BoxDecoration(borderRadius:new BorderRadius.all(Radius.circular(2)),color: Colors.deepOrange),
                                                                                          child: Text(
                                                                                            ' M3U8',
                                                                                            style: MyTexStyle.menu,
                                                                                          ),
                                                                                        )
                                                                                      ] else ...[
                                                                                        Container(
                                                                                          // padding: EdgeInsets.all(2),
                                                                                          // decoration: BoxDecoration(borderRadius:new BorderRadius.all(Radius.circular(2)),color: Colors.green),
                                                                                          child: Text(
                                                                                            ' MP4',
                                                                                            style: MyTexStyle.menu,
                                                                                          ),
                                                                                        )
                                                                                      ]
                                                                                    ]
                                                                                  ],
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                                                                ),
                                                                                Row(
                                                                                  children: [
                                                                                    Icon(FontAwesomeIcons.file, color: Colors.blue, size: 22),
                                                                                    Text(" " + _items[index].task.videoTaskItem!.downloadSizeString() + "/" + _items[index].task.videoTaskItem!.totalSizeString(), style: MyTexStyle.menu)
                                                                                  ],
                                                                                ),
                                                                                //Padding(padding: EdgeInsets.symmetric(horizontal: 5),),
                                                                              ],
                                                                            ),
                                                                            Container(
                                                                              padding:
                                                                                  const EdgeInsets.all(8.0),
                                                                              child:
                                                                                  Stack(
                                                                                alignment:
                                                                                    Alignment.topRight,
                                                                                children: [
                                                                                  LineChartSample(videoTaskItem: _items[index].task.videoTaskItem!),
                                                                                  Container(
                                                                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                                                    child: Row(
                                                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                                                      children: [
                                                                                        Icon(
                                                                                          FontAwesomeIcons.tachographDigital,
                                                                                          color: Colors.blue,
                                                                                          size: 22,
                                                                                        ),
                                                                                        Text(_items[index].task.videoTaskItem!.speedString(), style: MyTexStyle.menu)
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                          /*Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Container(
                                                                color: Colors.blueAccent,
                                                                child: Padding(
                                                                      padding: EdgeInsets.all(8),
                                                                      child: Column(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text("*url: " + _items[index].task.videoTaskItem.url),
                                                                              Text('*State: ${_items[index].task.videoTaskItem.taskStateString()}'),
                                                                              Text('*Mime: ${_items[index].task.videoTaskItem.mimeType}'),
                                          
                                                                              // Text('*Speed : ${_items[index].task.videoTaskItem.speedString()}'),
                                                                              //   Text('*percentString : ' + _items[index].task.videoTaskItem.percentString()),
                                                                                 Text('*fileName : ' + _items[index].task.videoTaskItem.fileName.toString()),
                                                                                 Text('*filePath : ' + _items[index].task.videoTaskItem.filePath.toString()),
                                                                              //   Text('*saveDir : ' + _items[index].task.videoTaskItem.saveDir),
                                                                              //   Text('*downloadSize : ' + _items[index].task.videoTaskItem.downloadSize.toString()),
                                                                              //   Text('*Downloaded: ${_items[index].task.videoTaskItem.downloadSizeString()} / ${_items[index].task.videoTaskItem.totalSizeString()}'),
                                                                                
                                          
                                          
                                          
                                                                              if (_items[index].task.videoTaskItem.taskState == VideoTaskState.DOWNLOADING ||
                                                                                  _items[index].task.videoTaskItem.taskState == VideoTaskState.PAUSE) ...[
                                                                                Text('*Speed : ' + _items[index].task.videoTaskItem.speedString()),
                                                                                Text('*speendlist.legth ' + _items[index].task.videoTaskItem.speedDataList.length.toString()),
                                                                                Text('*speedDouble : ' + _items[index].task.videoTaskItem.speedDouble().toString()),
                                                                                Text('*percentString : ' + _items[index].task.videoTaskItem.percentString()),
                                                                                Text('*fileName : ' + _items[index].task.videoTaskItem.fileName.toString()),
                                                                                Text('*filePath : ' + _items[index].task.videoTaskItem.filePath.toString()),
                                                                                Text('*saveDir : ' + _items[index].task.videoTaskItem.saveDir),
                                                                                Text('*downloadSize : ' + _items[index].task.videoTaskItem.downloadSize.toString()),
                                                                                Text(
                                              '*Downloaded: ${_items[index].task.videoTaskItem.downloadSizeString()} / ${_items[index].task.videoTaskItem.totalSizeString()}'),
                                                                                RaisedButton(
                                              child: Text(
                                                  _items[index].task.videoTaskItem.taskState == VideoTaskState.DOWNLOADING
                                                      ? 'Pause'
                                                      : 'Resume'),
                                              onPressed: () {
                                                if (_items[index].task.videoTaskItem.taskState == VideoTaskState.DOWNLOADING)
                                                  VideoDownloader.pause(_items[index].task.videoTaskItem);
                                                else
                                                  VideoDownloader.resume(_items[index].task.videoTaskItem);
                                              }),
                                              RaisedButton(
                                              child: Text("Cancel and delete"),
                                              onPressed: () {
                                                VideoDownloader.delete(_items[index].task.videoTaskItem, deleteSourceFile: true);
                                              }),
                                          
                                                                              ],
                                                                              if (_items[index].task.videoTaskItem.taskState == VideoTaskState.DEFAULT)
                                                                                RaisedButton(
                                                                                  child: Text('Start download'),
                                                                                  onPressed: () {
                                              VideoDownloader.startDownload(_items[index].task.videoTaskItem);
                                                                                  },
                                                                                ),
                                                                              if (_items[index].task.videoTaskItem.taskState == VideoTaskState.SUCCESS &&
                                                                                  _items[index].task.videoTaskItem.mimeType != "m3u8")
                                                                                RaisedButton(
                                                                                  child: Text('Play'),
                                                                                  onPressed: () {
                                              //Navigator.push(context,MaterialPageRoute(builder: (_) =>PagePlayer(e.filePath)));
                                                                                  },
                                                                                ),
                                                                              if (_items[index].task.videoTaskItem.taskState == VideoTaskState.ERROR)
                                                                                Text(
                                                                                  'Error Code: ${_items[index].task.videoTaskItem.errorCode}',
                                                                                  style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red),
                                                                                ),
                                                                            ],
                                                                      ),
                                                                ),
                                                              ),
                                                            ),*/
                                                                        ]
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                               /*dismissal: SlidableDismissal(
                                                child: SlidableDrawerDismissal(),
                                                onDismissed: (actionType) {
                                                  print("-------onDismissed");
                                                  setState(() {
                                                    _items.removeAt(index);
                                                  });
                                                },
                                              ),*/
                                                                key: Key(_items[index].task.name!),
                                                                secondaryActions: <
                                                                    Widget>[
                                                                  /* if(_items[index].task.isComp) IconSlideAction(
                                                  caption: 'Open in VLC',
                                                  color: MyColors.primary3,
                                                  foregroundColor: Colors.white,
                                                  icon: GroovinMaterialIcons.vlc,
                                                  closeOnTap: true,
                                                  key: Key(_items[index].task.name),
                                                  onTap: () async {
                                                    MyCommonConstants().videoAd(0);
                                                    print("--External Player: " + _tasks[index].localnametask.trim());
                                                    //OpenFile.open(_tasks[index].localnametask);
                                                    await PlayerPlugin.openWithVlcPlayer("/storage/emulated/0/Download/ssshls/local.m3u8");
                                                    //OpenFile.open(_items[index].task.localnametask.trim(), type: "audio/x-mpegurl");
                                                    },
                                                ),
                                          */
                                                                  if (_items[index].task.downloadPagetype ==MyCommonConstants.downloadManagerNormal)
                                                                    //if(true)
                                                                    IconSlideAction(
                                                                      caption:
                                                                          'Direct Link',
                                                                      color: MyColors
                                                                          .primary3,
                                                                      foregroundColor:
                                                                          Colors
                                                                              .white,
                                                                      icon: FontAwesomeIcons
                                                                          .download,
                                                                      closeOnTap:
                                                                          true,
                                                                      key: Key(_items[index].task.name!),
                                                                      onTap: () {
                                                                        //MyCommonConstants().videoAd(0);
                                                                        //_gotoDirectLinkPage(Directdownloadpage(eplink:_items[index].task.link,));
                                                                      },
                                                                    ),
                                                                   IconSlideAction(
                                                                    caption:
                                                                        'Delete',
                                                                    color: MyColors
                                                                        .reddy,
                                                                    foregroundColor:
                                                                        Colors
                                                                            .white,
                                                                    icon: FontAwesomeIcons
                                                                        .trash,
                                                                    closeOnTap:
                                                                        true,
                                                                    key: Key(_items[
                                                                            index]
                                                                        .task
                                                                        .name!),
                                                                    onTap: () {
                                                                      onRemovePressed(_items[index].task,index);
                                                                      
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        // } catch (e) {
                                                        //   print(
                                                        //       "------------------------ERRRRRROR: " +e.toString());
                                                        // }
                                                      },
                                                      childCount: _items.length,
                                                    ),
                                                  ),
                                                  _sliverspace(100),
                                                ],
                                              )
                                            
                                          
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(10),
                                              //color: MyColors.primary2,
                                              child: Transform.scale(
                                                scale: 0.8,
                                                child: GestureDetector(
                                                    onTap: () {
                                                      _myhomepagescafoldkey
                                                          .currentState!
                                                          .openDrawer();
                                                      //Navigator.pop(context);
                                                      //eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError, cancelOnError: true).cancel();
                                                    },
                                                    child: Icon(
                                                      FeatherIcons.menu,
                                                      color: MyColors.opp1
                                                          .withOpacity(1),
                                                      size: 30,
                                                    )),
                                              ),
                                            ),
                                            Transform.scale(
                                              scale: 0.4,
                                              child: FloatingActionButton(
                                                elevation: 0,
                                                onPressed: () {
                                                  AdCel.showInterstitialAdZone(AdCelAdType.REWARDED,"Menu");
                                                },
                                                child: Icon(
                                                  EvaIcons.video,
                                                  color: Colors.white,
                                                  size: 35,
                                                ),
                                                backgroundColor: Colors.pink,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            CupertinoButton(
                                                child: Text('Refresh',
                                                    style: MyTexStyle.normal),
                                                onPressed: () {
                                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Downloader(title: 'Downloads',),),(Route<dynamic> route) => false);
                                                  // Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) =>Downloader(title: "Downloads",),));
                                                  MyCommonConstants().setSystemUI();
                                                })
                                          ],
                                        ),
                                      ],
                                    ),
                                  )),
                              Container(
                                color: Colors.black,
                                padding: EdgeInsets.all(5),
                                height: 45,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, 
                                  children: [
                                    Expanded( flex:1,
                                      child: CupertinoButton(
                                        onPressed: (){
                                          print("_isRewardButtonDisabled: $_isRewardButtonDisabled");
                                          _internetChecker().then((value) {
                                            if(interneticc != ConnectivityResult.none){
                                            getADDrewboltdowns(15);
                                            AdCel.showInterstitialAdZone(AdCelAdType.REWARDED,"Menu");
                                            }
                                            else {
                                              toast.Fluttertoast.showToast(
                                              msg: 'No Internet Connection',
                                              toastLength: toast.Toast.LENGTH_LONG,
                                              gravity: toast.ToastGravity.BOTTOM);
                                            }

                                          });
                                          
                                          
                                        },
                                        child: FittedBox(
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, 
                                            children: [
                                              Icon(
                                                EvaIcons.gift,
                                                color: MyColors.primary1,
                                                size: 16,),
                                              Text(" Get +5 Downloads ", 
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: MyColors.primary1,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              textAlign: TextAlign.center,),
                                            ],
                                          ),
                                        ),
                                        color: (interneticc == ConnectivityResult.none) ? Colors.white.withOpacity(0.5) : Colors.orange,
                                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),

                                        ),
                                    ),
                                    Padding(padding: EdgeInsets.all(2.5)), 
                                    Expanded( flex:1,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          LiquidLinearProgressIndicator(
                                            value: boltdowncnt/10, // Defaults to 0.5.
                                            valueColor: AlwaysStoppedAnimation((boltdowncnt >= 10) ? Color.fromARGB(255, 48, 17, 152) : Colors.blueAccent), // Defaults to the current Theme's accentColor.
                                            backgroundColor: MyColors.opp1.withOpacity(0.15), // Defaults to the current Theme's backgroundColor.
                                            borderColor: MyColors.opp1.withOpacity(0.03),
                                            borderWidth: 1,
                                            borderRadius: 8.0,
                                            direction: Axis.horizontal, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
                                            //center: Text("Loading..."),
                                          ),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, 
                                            children: [
                                              Icon(FontAwesomeIcons.bolt, color: Colors.orange, size: 23,),
                                              Text(boltdowncnt.toString(), 
                                              style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.orange,
                                                fontWeight: FontWeight.w900,
                                                ),
                                                textAlign: TextAlign.center,
                                                ),
                                        
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(padding: EdgeInsets.all(2.5)), 
                                    Expanded( flex:1,
                                      child: CupertinoButton(
                                        onPressed: () async {
                                          await Get.to(DownloadFromShareInPage(
                                    intentString: '',
                                    isDirectdownfile: true,
                                  ));
                                        },
                                        child: FittedBox(
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, 
                                            children: [
                                              Icon(
                                                EvaIcons.arrowCircleDownOutline,
                                                color: MyColors.primary1,
                                                size: 16,
                                              ),
                                              Text(
                                                ' New Download',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: MyColors.primary1,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                        color: Colors.red,
                                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),

                                        ),
                                    ),
                                  ],
                                ),
                              ), 

                              Container(
                                  width: w,
                                   height: 125 - 55  ,
                                  alignment: Alignment.center,
                                  color: Colors.black,
                                  child: MyAdsOnVideoPage()),
                              
                              /*GestureDetector(
                                onTap: () async {
                                  // var arguments = DownloadsArguments('', '', '', '', '');
                                  await Get.to(DownloadFromShareInPage(
                                    intentString: '',
                                    isDirectdownfile: true,
                                  ));
                                },
                                child: Container(
                                  width: w,
                                  height: 30,
                                  alignment: Alignment.center,
                                  color: Colors.red,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        EvaIcons.arrowCircleDownOutline,
                                        color: MyColors.primary1,
                                        size: 16,
                                      ),
                                      Text(
                                        ' New Download',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: MyColors.primary1,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),*/
                              // Container(
                              //     width: w,
                              //     height: 125 ,
                              //     alignment: Alignment.center,
                              //     color: Colors.black,
                              //     child: MyAdsOnVideoPage())
                            ],
                          ),
                  )
                : Container(
                    color: MyColors.primary1,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Text(
                              'Please grant accessing storage permission to continue -_-',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 18.0),
                            ),
                          ),
                          SizedBox(
                            height: 32.0,
                          ),
                          CupertinoButton(
                              onPressed: () {
                                _checkPermission().then((hasGranted) {
                                  setState(() {
                                    _permissisonReady = hasGranted;
                                  });
                                });
                              },
                              child: Text(
                                'Retry',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ))
                        ],
                      ),
                    ),
                  ));
  }

  /* @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video downloader'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: _items == null
              ? []
              : _items.map((e) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.blueAccent,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(e.task.videoTaskItem.url),
                            Text('State: ${e.task.videoTaskItem.taskStateString()}'),
                            Text('Mime: ${e.task.videoTaskItem.mimeType}'),
                            if (e.task.videoTaskItem.taskState == VideoTaskState.DOWNLOADING ||
                                e.task.videoTaskItem.taskState == VideoTaskState.PAUSE) ...[
                              Text('Speed : ${e.task.videoTaskItem.speedString()}'),
                              Text('Progress : ${e.task.videoTaskItem.percentString()}'),
                              Text(
                                  'Downloaded: ${e.task.videoTaskItem.downloadSizeString()} / ${e.task.videoTaskItem.totalSizeString()}'),
                              RaisedButton(
                                  child: Text(
                                      e.task.videoTaskItem.taskState == VideoTaskState.DOWNLOADING
                                          ? 'Pause'
                                          : 'Resume'),
                                  onPressed: () {
                                    if (e.task.videoTaskItem.taskState == VideoTaskState.DOWNLOADING)
                                      VideoDownloader.pause(e.task.videoTaskItem);
                                    else
                                      VideoDownloader.resume(e.task.videoTaskItem);
                                  }),
                                  RaisedButton(
                                  child: Text("Canel and delete"),
                                  onPressed: () {
                                    VideoDownloader.deleteVideoTask(e.task.videoTaskItem);
                                  }),

                            ],
                            if (e.task.videoTaskItem.taskState == VideoTaskState.DEFAULT)
                              RaisedButton(
                                child: Text('Start download'),
                                onPressed: () {
                                  VideoDownloader.startDownload(e.task.videoTaskItem);
                                },
                              ),
                            if (e.task.videoTaskItem.taskState == VideoTaskState.SUCCESS &&
                                e.task.videoTaskItem.mimeType != "m3u8")
                              RaisedButton(
                                child: Text('Play'),
                                onPressed: () {
                                  //Navigator.push(context,MaterialPageRoute(builder: (_) =>PagePlayer(e.filePath)));
                                },
                              ),
                            if (e.task.videoTaskItem.taskState == VideoTaskState.ERROR)
                              Text(
                                'Error Code: ${e.task.videoTaskItem.errorCode}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
        ),
      ),
    );
  }
*/

}

class _TaskInfo {
  final String? name;
  final String? link;
  VideoTaskItem? videoTaskItem;
  final String? downloadPagetype;
  final String? headerString;
  String? localnametask;
  final String? image;

  String? taskId;
  int progress = 0;
  //DownloadTaskStatus status = DownloadTaskStatus.undefined;
  String status = MyCommonConstants.downloadDefault;
  bool? isGrabbed;
  bool? isComp;

  _TaskInfo({
    this.name,
    this.link,
    this.videoTaskItem,
    this.localnametask,
    this.taskId,
    this.isGrabbed,
    this.isComp,
    this.image,
    this.downloadPagetype,
    this.headerString,
  });
}

class _ItemHolder {
  final String name;
  final _TaskInfo task;
  bool isExpanded = false;

  _ItemHolder({required this.name, required this.task, this.isExpanded = false});
}
