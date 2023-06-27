import 'package:flutter/material.dart';

// ignore_for_file: sort_child_properties_last

//import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;
import 'dart:math' as math;
import 'package:path_provider/path_provider.dart';
// import 'package:media_storage/media_storage.dart';
import 'package:external_path/external_path.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:videodown/data/model/download.model.dart';
import 'package:videodown/data/repository/local/download_db.dart';
import 'package:videodown/infrastructure/constant.dart';
import 'package:videodown/infrastructure/styles.dart';
import 'package:videodown/infrastructure/themes.dart';
import 'package:videodown/presentation/widgets/ads.widget.dart';
import 'package:videodown/presentation/widgets/line_chart_simple.widget.dart';
import 'package:videodown/utils/directory_downloads.dart';
import 'package:videodownloader/videodownloader.dart';
import 'package:open_file/open_file.dart';
//import 'package:simple_permissions/simple_permissions.dart';
//import 'package:file_utils/file_utils.dart';
import 'package:fluttertoast/fluttertoast.dart' as toast;
import 'package:external_video_player_launcher/external_video_player_launcher.dart';
import 'dart:math';
import 'dart:io';
import 'package:flutter/cupertino.dart';
// import 'package:open_app/open_app.dart';
import 'package:videodown/presentation/widgets/customdrawer.dart';

import 'package:videodown/presentation/download.page.dart';
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
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:percent_indicator/percent_indicator.dart';
// import 'package:intent/intent.dart' as android_intent;
// import 'package:intent/extra.dart' as android_extra;
// import 'package:intent/typedExtra.dart' as android_typedExtra;
// import 'package:intent/action.dart' as android_action;
// import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:get/get.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:ndialog/ndialog.dart';

import '../utils/local_notification_init.use.dart';

class Downloader extends StatefulWidget {
  const Downloader({
    Key? key,
    required this.title,
    this.nointent_previousintent = 'Empty',
  }) : super(key: key);
  final String title;
  final String nointent_previousintent;
  @override
  DownloaderState createState() => DownloaderState();
}

class DownloaderState extends State<Downloader> with WidgetsBindingObserver {
  List<DownloadEpisodelist> filteredEpisodes = [];

  List<DownloadEpisodelist> movieCache = [];

  late StreamSubscription _intentDataStreamSubscription;

  late List<_TaskInfo> _tasks;
  late List<_ItemHolder> _items;
  late bool _isLoading;
  late bool _permissisonReady;
  late String _localPath;
  late Directory _appDocsDir;
  final _myhomepagescafoldkey = GlobalKey<ScaffoldState>();
  final PublishSubject subject = PublishSubject<String>();
  final _listscafoldkey = GlobalKey<ScaffoldState>();
  //var _slidablekey = new GlobalKey<SlidableState>();

  late int boltdowncnt;
  late SharedPreferences preferences;

  String downloadStatusString = "zzzzzzzz";
  String downloadpersistentString = "aaaaaaaa";
  static const MethodChannel channel = MethodChannel('IronSourceAdBridge');
  static const EventChannel eventChannel = EventChannel('DOWNLOADING_CHANNEL');

  bool isFullIntent = false;

  _refresh() async {
    setState(() {});
  }

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
  }

  DownloadDatabase db = DownloadDatabase();

  Future<void> _prepare() async {
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
          filteredEpisodes[i].localurl =
              _tasks[i].videoTaskItem!.filePath ?? "No Path";
          print("////////////////////filteredEpisodes[i].videoname: " +
              filteredEpisodes[i].videoname +
              " | " +
              "filteredEpisodes[i].localurl: " +
              filteredEpisodes[i].localurl);
          db.updateMovie(filteredEpisodes[i]);
          _prepare();
        }
        FlutterNotification.pushDownloadedNotification(
            _tasks[i].videoTaskItem!.fileName ?? "NO DATA", i.toString());
        if (mounted) setState(() {});
      };
      item?.onDownloadProgress = () {
        print(i.toString() +
            ")downloaded ITEM +>   ----VideoDownloader-----item: " +
            item.toString() +
            "     *onDownloadProgress*     " +
            item.taskStateString());
        _tasks[i].status = MyCommonConstants.downloadDownloading;
        FlutterNotification.pushUpdatedNotification(item.percent!.floor(),
            _tasks[i].videoTaskItem?.fileName ?? "<< No Name >>", i.toString());
        if (mounted) setState(() {});
      };
      item?.onDownloadSpeed = () {
        print(i.toString() +
            ")   ----VideoDownloader-----item: " +
            item.toString() +
            "     *onDownloadSpeed*     " +
            item.taskStateString());
        if (mounted) setState(() {});
      };
      item?.onDownloadError = () {
        print(i.toString() +
            ")   ----VideoDownloader-----item: " +
            item.toString() +
            "     *onDownloadError*     " +
            item.taskStateString());
        _tasks[i].status = MyCommonConstants.downloadError;
        if (mounted) setState(() {});
      };
      item?.onDownloadPause = () {
        // print(i.toString() +")   ----VideoDownloader-----item: " +item.toString() +"     *onDownloadPause*     " +item.taskStateString());
        _tasks[i].status = MyCommonConstants.downloadPause;
        if (mounted) setState(() {});
      };
      item?.onDownloadPending = () {
        print(i.toString() +
            ") >>>>>>> ASTHI  ----VideoDownloader-----item: " +
            item.toString() +
            "     *onDownloadPending*     " +
            item.taskStateString());
        _tasks[i].status = MyCommonConstants.downloadPending;
        FlutterNotification.pushUpdatedNotification(item.percent!.floor(),
            _tasks[i].videoTaskItem?.fileName ?? "<< No Name >>", i.toString());
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

    _permissisonReady = await _checkPermission();

    _appDocsDir = await getApplicationDocumentsDirectory();
    // print('_appDocsDir = $_appDocsDir');

    setState(() {
      _isLoading = false;
    });

    //_persistantStatus();
  }

  File fileFromDocsDir(String filename) {
    String pathName = p.join(_appDocsDir.path, filename);
    print("//////////fffffffffffffff/////////pathName: $pathName");
    return File(pathName);
  }

  Future<String> _setVideoSaveDirectory(String str) async {
    const folderName = "VDM Downloads";
    final path = Directory("$str/$folderName");
    if ((await path.exists())) {
      print("_setVideoSaveDirectory ****exist**** $path");
    } else {
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

    FlutterNotification.askPermission();

    _internetChecker();
    //_refresh();

    initUniLinks();

    localPath.then((value) {
      _setVideoSaveDirectory(value).then((val) {
        VideoDownloader.init(
            config: VideoDownloadConfig(
          concurrentCount: 2,
          cacheDirectoryPath: val,
        ));
      });
    });

    // ExternalPath.getExternalStoragePublicDirectory(
    //         ExternalPath.DIRECTORY_DOWNLOADS)
    //     .then((value) {

    // });

    getboltdownloadscount();

    // ExternalPath.getExternalStorageDirectories().then((value) {});

    //BackButtonInterceptor.add(myInterceptor);
    //MyCommonConstants().videoAd(0);
    filteredEpisodes = [];
    movieCache = [];
    //subject.stream.listen(searchDataList);
    //setupList();
    _prepare();

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
  void onRewardedCompleted(
      String adProvider, String currencyName, String currencyValue) {
    print(
        'MAIN.DART >>>> onRewardedCompleted: $adProvider, $currencyName, $currencyValue');
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
  Future<void> initUniLinks() async {
    try {
      String initialLink;

      _appLinks.getLatestAppLink().then((value) async {
        setState(() {
          initialLink = value.toString();
          print(
              '----------tmp_initialLink: $initialLink  ---widget:${widget.nointent_previousintent} ----${(widget.nointent_previousintent.trim() != value.toString().trim()) && ((widget.nointent_previousintent).toString() != '')}');
          if (value != null) {
            if ((widget.nointent_previousintent.trim() !=
                    value.toString().trim()) &&
                ((widget.nointent_previousintent).toString() != '')) {
              // if(true) {
              setState(() {
                tmp_initialLink = initialLink;
              });
              Get.to(DownloadFromShareInPage(
                intentString: value.toString(),
                isDirectdownfile: false,
              ));
            }
          }
        });
      });
    } on PlatformException {}
  }

  void setupList() async {}

  @override
  void dispose() {
    subject.close();
    WidgetsBinding.instance.removeObserver(this);
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
            .contains(RegExp(r'' + query.toLowerCase().trim())))
        .toList();
    setState(() {});
  }

  void onRemovePressed(_TaskInfo task, int index) {
    print(
        "onRemovePressed----------task: ${task.name!} ----------index: $index");

    setState(() {});
    VideoDownloader.delete(task.videoTaskItem!, deleteSourceFile: true);
    DownloadDatabase db = DownloadDatabase();
    print("deleting----------------");
    print(filteredEpisodes.length);
    print(filteredEpisodes[index].videoname);
    print(index);
    print(filteredEpisodes.length);
    db.deleteMovie(filteredEpisodes[index].videoname);

    setState(() {
      print("removing----------------");
      print(filteredEpisodes[index].videoname);
      print(index);
      print(filteredEpisodes.length);
      filteredEpisodes.remove(filteredEpisodes[index]);
    });

    try {
      if (task.downloadPagetype == MyCommonConstants.m3u8Downloader) {
        File videoFile = File(task.localnametask!
            .replaceAll(
                "/${task.localnametask!.split("/")[task.localnametask!.split("/").length - 1]}",
                "")
            .trim());
        videoFile.delete(recursive: true);
        print("${task.downloadPagetype!} ///// deleted: ${videoFile.path}");
      } else if (task.downloadPagetype ==
          MyCommonConstants.downloadManagerNormal) {
        File videoFile = File(task.localnametask!.trim());
        videoFile.delete(recursive: true);
        print("${task.downloadPagetype!} ///// deleted: ${videoFile.path}");
      }
    } catch (e) {
      print("onRemovePressed ERROR: $e");
    }
    _prepare();
    //initState();
  }

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
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: MyColors.primary3,
                    ),
                    child: Column(
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                        ),
                        Row(
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                  alignment: const Alignment(-1, 0),
                                  child: Container(
                                    //width: 200,
                                    //padding: EdgeInsets.all(5.0),
                                    decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(2)),
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
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                        ),
                        const LinearProgressIndicator(),
                        const Padding(
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
            const Padding(
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
                decoration: const BoxDecoration(
                  //image: DecorationImage(image: NetworkImage('https://ya-webdesign.com/images/paint-brush-stroke-png.png')),
                  borderRadius: BorderRadius.all(Radius.circular(2)),
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
              ));
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
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                prefixIcon: Icon(EvaIcons.search,
                    color: MyColors.reddy.withOpacity(0.4)),
                hintText: "Search",
                hintStyle: TextStyle(
                    fontSize: 16,
                    color: MyColors.reddy.withOpacity(0.4),
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.none),
                enabledBorder: const OutlineInputBorder(
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
                  borderRadius: const BorderRadius.all(
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
        },
        child: Icon(
          FontAwesomeIcons.download,
          color: MyColors.reddy,
          size: 18,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        color: Colors.white,
      );
    } else if (task.status == MyCommonConstants.downloadSuccess) {
      return const Row(
        children: [
          Text(
            'Completed',
            style: TextStyle(color: Colors.purple),
          ),
        ],
      );
    } else {
      return const Text(
        'ELSE CONDIION',
        style: TextStyle(color: Colors.purple),
      );
    }
  }

  void _showDownloadSlideDialog(String finalstring) async {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    await NAlertDialog(
      //title: Text("Test"),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              //width: w,
              //height: 85.0 + 10,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                /*boxShadow: <BoxShadow>[
                                      new BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        offset: new Offset(0.0, 2.0),
                                        blurRadius: 10.0,
                                      )
                                    ],*/
                borderRadius: const BorderRadius.all(Radius.circular(20)),
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
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        image: DecorationImage(
                            image: AssetImage('assets/vlclogo.png'),
                            fit: BoxFit.fill)),
                  ),
                  Expanded(
                      flex: 2,
                      child: Center(
                        child: CupertinoButton(
                          onPressed: () {
                            launch(
                                "https://play.google.com/store/apps/details?id=org.videolan.vlc");
                          },
                          child: Text("Get it on Play Store➚",
                              style: MyTexStyle.menu),
                          color: MyColors.primary1,
                          minSize: 3,
                          padding: const EdgeInsets.all(5),
                        ),
                      )),
                ],
              )),
            ),
            const Padding(padding: EdgeInsets.all(2.5)),
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: CupertinoButton(
                    onPressed: () async {
                      Clipboard.setData(ClipboardData(text: finalstring));
                      toast.Fluttertoast.showToast(
                          msg: finalstring,
                          toastLength: toast.Toast.LENGTH_LONG,
                          gravity: toast.ToastGravity.BOTTOM);
                      // await PlayerPlugin.openWithVlcPlayer(finalstring);
                      ExternalVideoPlayerLauncher.launchVlcPlayer(
                          finalstring.trim(), MIME.applicationXMpegURL, {
                        "title": "",
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Play in VLC',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(1),
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.none),
                        ),
                        //Icon(LineIcons.download,size: 30, color: MyColors.opp1,),
                      ],
                    ),
                    color: const Color(0xFF695dfc),
                    //borderRadius: BorderRadius.all(Radius.circular(15)),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: CupertinoButton(
                    onPressed: () async {
                      await OpenFile.open(finalstring, type: "audio/x-mpegurl");
                    },
                    child: Icon(FeatherIcons.share,
                        size: 18, color: MyColors.opp1),
                    //color: Colors.black.withOpacity(1),
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    padding: const EdgeInsets.symmetric(
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
        backgroundColor: Colors.transparent, elevation: 0,
      ),
      blur: 15,
    ).show(context);
  }

  getboltdownloadscount() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    boltdowncnt = preferences.getInt("boltdownloadscount") ?? 2;
    print("getboltdownloadscount : $boltdowncnt");
    setState(() {
      boltdowncnt = boltdowncnt;
    });
  }

  getADDrewboltdowns(int sec) async {
    ////Add +5

    var internetcc = await (Connectivity().checkConnectivity());
    if (internetcc.toString() != 'ConnectivityResult.none') {
      // String resavailavle = await MyCommonConstants().videoAd(5555); ////check if ads avilable
      String resavailavle = ''; ////check if ads avilable
      print('resavailavle : $resavailavle');
      if (true
          // resavailavle == 'ads_available'
          ) {
        // String res = await MyCommonConstants().videoAd(1);
        String res = '';
        if (true
            // res == 'rewardAd_COMPLETED' || res == 'interstitialAd_COMPLETED'
            ) {
          print("sucesssssss");
        }

        shownumberboltdownsflash('+5');

        Future.delayed(Duration(seconds: sec), () async {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          int boltdowncnttmp = boltdowncnt + 5;
          await preferences.setInt("boltdownloadscount", boltdowncnttmp);
          getboltdownloadscount();
        });
      }
    } else {
      print('NOT CONNECTED TO INTERNET internetcc : $internetcc');
    }
  }

  use1boltdowns() async {
    //// -1
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int boltdowncnttmp = boltdowncnt - 1;
    await preferences.setInt("boltdownloadscount", boltdowncnttmp);
    getboltdownloadscount();
    shownumberboltdownsflash('-1');
  }

  shownumberboltdownsflash(String x) {
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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                x,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.orange,
                  fontWeight: FontWeight.w900,
                ),
                textAlign: TextAlign.center,
              ),
              const Icon(
                FontAwesomeIcons.bolt,
                color: Colors.orange,
                size: 23,
              ),
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
          var begin = const Offset(0.0, 1.0);
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
        transitionDuration: const Duration(seconds: 1)));
    //imageCache.clear();
  }

  int speed = 30000;

  int random(min, max) {
    var rn = Random();
    return min + rn.nextInt(max - min);
  }

  Widget videothumb(String theme) {
    return const SizedBox(
      height: 80,
      width: 80,
    );
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
        drawer: const CustomDrawer(
          isReviewFinal: false,
        ),
        key: _myhomepagescafoldkey,
        body: _isLoading
            ? Container(
                color: MyColors.primary1,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : _permissisonReady
                ? LiquidPullToRefresh(
                    showChildOpacityTransition: false,
                    color: Colors.blue,
                    onRefresh: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Downloader(
                              title: "Downloads",
                            ),
                          ));
                      MyCommonConstants().setSystemUI();
                      throw 'throwed';
                    },
                    child: Column(
                      children: [
                        Container(
                            height: h - 125 - 30 - 40 + 30 + 55 - 5,
                            width: w,
                            color: MyColors.primary1,
                            child: SafeArea(
                              child: Stack(
                                children: <Widget>[
                                  SizedBox(
                                      height: h,
                                      width: w,
                                      child: CustomScrollView(
                                        slivers: <Widget>[
                                          _sliverspace(5),
                                          _sliverheading("Downloads"),
                                          _sliverspace(5),
                                          SliverList(
                                            delegate:
                                                SliverChildBuilderDelegate(
                                              (context, index) {
                                                for (var i = 0;
                                                    i < _items.length;
                                                    i++) {
                                                  // print('_items.length: + ${_items.length}');
                                                  // print(i.toString() +")    ---------_tasks.name: " +_items[i].task.name!);
                                                  // print(i.toString() +")    ---------_tasks.status: " +_items[i].task.status);
                                                }
                                                // try {
                                                return Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 5),
                                                    child: Slidable(
                                                      //key: _slidablekey,
                                                      actionPane:
                                                          const SlidableDrawerActionPane(),
                                                      actionExtentRatio: 0.25,
                                                      child: GestureDetector(
                                                        onTap: () async {
                                                          if (_items[index]
                                                              .task
                                                              .isComp!) {
                                                            print("--ontap: " +
                                                                _tasks[index]
                                                                    .localnametask! +
                                                                '\n_items[index].task.videoTaskItem.taskStateString(): ' +
                                                                _items[index]
                                                                    .task
                                                                    .videoTaskItem!
                                                                    .taskStateString());
                                                            _showDownloadSlideDialog(
                                                                _tasks[index]
                                                                    .localnametask!);
                                                          }
                                                        },
                                                        child: Container(
                                                          //height: 100,
                                                          decoration:
                                                              BoxDecoration(
                                                            boxShadow: <BoxShadow>[
                                                              BoxShadow(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.1),
                                                                offset:
                                                                    const Offset(
                                                                        0.0,
                                                                        2.0),
                                                                blurRadius:
                                                                    10.0,
                                                              )
                                                            ],
                                                            borderRadius:
                                                                const BorderRadius
                                                                        .all(
                                                                    Radius
                                                                        .circular(
                                                                            15)),
                                                            color: MyColors
                                                                .primary3,
                                                          ),
                                                          child: Column(
                                                            children: <Widget>[
                                                              const Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            5),
                                                              ),
                                                              Row(
                                                                children: <Widget>[
                                                                  const Padding(
                                                                    padding: EdgeInsets
                                                                        .symmetric(
                                                                            horizontal:
                                                                                5),
                                                                  ),
                                                                  Stack(
                                                                    children: <Widget>[
                                                                      Container(
                                                                          height:
                                                                              80,
                                                                          width:
                                                                              80,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                MyColors.opp1.withOpacity(0.05),
                                                                            borderRadius:
                                                                                const BorderRadius.all(Radius.circular(15)),
                                                                          ),
                                                                          // padding: EdgeInsets.all(5.0),
                                                                          child: const Icon(
                                                                              Ionicons.play,
                                                                              color: Colors.red,
                                                                              size: 35)),
                                                                      Container(
                                                                        height:
                                                                            80,
                                                                        width:
                                                                            80,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color: (MyColors.themename == "theme2")
                                                                              ? (_items[index].task.isComp == false)
                                                                                  ? MyColors.primary1.withOpacity(1)
                                                                                  : MyColors.primary1.withOpacity(0.0)
                                                                              : (_items[index].task.isComp == false)
                                                                                  ? MyColors.primary1.withOpacity(1)
                                                                                  : MyColors.primary1.withOpacity(0.0),
                                                                          // MyColors.opp1,
                                                                          borderRadius:
                                                                              const BorderRadius.all(Radius.circular(15)),
                                                                        ),
                                                                        // padding: EdgeInsets.all(5.0),
                                                                      ),
                                                                      ((_items[index].task.videoTaskItem!.taskStateString() == MyCommonConstants.downloadDefault || _items[index].task.videoTaskItem!.taskStateString() == MyCommonConstants.downloadStart || _items[index].task.videoTaskItem!.taskStateString() == MyCommonConstants.downloadPending || _items[index].task.status == MyCommonConstants.downloadError) &&
                                                                              _items[index].task.isComp == false)
                                                                          ? GestureDetector(
                                                                              onTap: () {
                                                                                if (boltdowncnt >= 1) {
                                                                                  use1boltdowns();
                                                                                  print(" ---------------------------------------------download pressed-------------\n${_items[index].task.videoTaskItem!.url}");

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
                                                                                          "User-Agent": "animdl/1.5.84",
                                                                                        };
                                                                                      }
                                                                                    } else {
                                                                                      headers = {
                                                                                        "User-Agent": "animdl/1.5.84",
                                                                                      };
                                                                                    }
                                                                                  } catch (e) {
                                                                                    print("error on headers parse: $e");
                                                                                  }

                                                                                  if (!headers.containsKey('User-Agent')) {
                                                                                    Map<String, String> useragentheader = {
                                                                                      // 'User-Agent': 'Mozilla/5.0 ( compatible )'
                                                                                      "User-Agent": "animdl/1.5.84"
                                                                                    };
                                                                                    headers.addAll(useragentheader);
                                                                                  }

                                                                                  print('*******************headers: $headers');
                                                                                  VideoDownloader.startDownloadWithHeader(
                                                                                    _items[index].task.videoTaskItem!,
                                                                                    headers: headers,
                                                                                  );

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
                                                                                                const TextSpan(
                                                                                                  text: 'Added ',
                                                                                                ),
                                                                                                TextSpan(text: (_items[index].task.isGrabbed!) ? "${MyCommonConstants().getTitleName(_items[index].task.name!)} ${MyCommonConstants().getEpisodeNumber(_items[index].task.name!)}" : _items[index].task.name.toString(), style: TextStyle(color: MyColors.reddy)),
                                                                                                const TextSpan(text: ' to download queue'),
                                                                                                TextSpan(text: "\n\n If download doesn't start in a few seconds, clear from RAM and restart the app ", style: TextStyle(color: MyColors.primary1.withOpacity(1), fontSize: 12, backgroundColor: Colors.yellow, fontWeight: FontWeight.w600)),
                                                                                              ]),
                                                                                            ),
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
                                                                                } else {
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
                                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                        children: [
                                                                                          Text(
                                                                                            'Get more',
                                                                                            style: TextStyle(
                                                                                              fontSize: 18,
                                                                                              color: MyColors.opp1,
                                                                                              fontWeight: FontWeight.w400,
                                                                                            ),
                                                                                            textAlign: TextAlign.center,
                                                                                          ),
                                                                                          const Icon(
                                                                                            FontAwesomeIcons.bolt,
                                                                                            color: Colors.orange,
                                                                                            size: 23,
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                }
                                                                              },
                                                                              child: Container(
                                                                                height: 80,
                                                                                width: 80,
                                                                                decoration: const BoxDecoration(
                                                                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                                                                ),
                                                                                child: (_items[index].task.status == MyCommonConstants.downloadError)
                                                                                    ? const Icon(
                                                                                        EvaIcons.closeCircleOutline,
                                                                                        color: Colors.red,
                                                                                      )
                                                                                    : (_items[index].task.status == MyCommonConstants.downloadDefault)
                                                                                        ? const Icon(
                                                                                            EvaIcons.arrowCircleDownOutline,
                                                                                            size: 30,
                                                                                            color: Colors.blue,
                                                                                          )
                                                                                        : (_items[index].task.videoTaskItem!.taskStateString() == MyCommonConstants.downloadPending || _items[index].task.videoTaskItem!.taskStateString() == MyCommonConstants.downloadStart)
                                                                                            ? const Icon(
                                                                                                FontAwesomeIcons.spinner,
                                                                                                color: Colors.blue,
                                                                                              )
                                                                                            : (_items[index].task.videoTaskItem!.taskStateString() == MyCommonConstants.downloadPause)
                                                                                                ? const Icon(
                                                                                                    EvaIcons.pauseCircle,
                                                                                                    color: Colors.blue,
                                                                                                  )
                                                                                                : null,
                                                                                padding: const EdgeInsets.all(2.0),
                                                                              ),
                                                                            )
                                                                          : Container(),
                                                                      (_items[index].task.videoTaskItem!.taskState == VideoTaskState.DOWNLOADING ||
                                                                              _items[index].task.videoTaskItem!.taskState == VideoTaskState.PAUSE)
                                                                          ? Container(
                                                                              height: 80,
                                                                              width: 80,
                                                                              decoration: const BoxDecoration(
                                                                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                                                              ),
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: <Widget>[
                                                                                  Text(
                                                                                    "${_items[index].task.videoTaskItem!.percent!.toInt().round()}%",
                                                                                    style: TextStyle(
                                                                                      fontSize: 14,
                                                                                      color: MyColors.opp1,
                                                                                      fontWeight: FontWeight.w500,
                                                                                    ),
                                                                                  ),
                                                                                  const Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                                                                                  LinearPercentIndicator(
                                                                                    //width: 140.0,
                                                                                    lineHeight: 7.0,
                                                                                    percent: (_items[index].task.videoTaskItem!.percent!) / 100,
                                                                                    backgroundColor: Colors.white,
                                                                                    progressColor: Colors.blue,
                                                                                  ),
                                                                                  const Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                                                                                ],
                                                                              ),
                                                                              padding: const EdgeInsets.all(5.0),
                                                                            )
                                                                          : Container()
                                                                    ],
                                                                  ),
                                                                  const Padding(
                                                                    padding: EdgeInsets
                                                                        .symmetric(
                                                                            horizontal:
                                                                                5),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 3,
                                                                    child:
                                                                        Column(
                                                                      children: <Widget>[
                                                                        Container(
                                                                          alignment: const Alignment(
                                                                              -1,
                                                                              -1),
                                                                          child:
                                                                              Container(
                                                                            child:
                                                                                Text(
                                                                              (_items[index].task.isGrabbed!) ? MyCommonConstants().getTitleName(_items[index].task.name!) : _items[index].task.name.toString(),
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
                                                                        const Padding(
                                                                          padding:
                                                                              EdgeInsets.symmetric(vertical: 4),
                                                                        ),
                                                                        Row(
                                                                          children: <Widget>[
                                                                            if (_items[index].task.isGrabbed!) ...[
                                                                              (MyCommonConstants().getEpisodeNumber(_items[index].task.name!) == '')
                                                                                  ? Container()
                                                                                  : Container(
                                                                                      alignment: const Alignment(-1, -1),
                                                                                      child: Container(
                                                                                        padding: const EdgeInsets.all(2.0),
                                                                                        decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(2)), color: MyColors.reddy),
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
                                                                              const Padding(
                                                                                padding: EdgeInsets.symmetric(horizontal: 2),
                                                                              ),
                                                                              (MyCommonConstants().getQuality(_items[index].task.name!) == '')
                                                                                  ? Container()
                                                                                  : Container(
                                                                                      alignment: const Alignment(-1, -1),
                                                                                      child: Container(
                                                                                        padding: const EdgeInsets.all(2.0),
                                                                                        decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(2)), color: MyColors.purp),
                                                                                        child: Text(
                                                                                          MyCommonConstants().getQuality(_items[index].task.name!),
                                                                                          softWrap: true,
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                          maxLines: 1,
                                                                                          style: MyTexStyle.infobutton,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                              const Padding(
                                                                                padding: EdgeInsets.symmetric(horizontal: 2),
                                                                              ),
                                                                            ],
                                                                            if (_items[index].task.status != MyCommonConstants.downloadDefault &&
                                                                                _items[index].task.status != MyCommonConstants.downloadError &&
                                                                                _items[index].task.status != MyCommonConstants.downloadSuccess) ...[
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
                                                                              const Padding(
                                                                                padding: EdgeInsets.symmetric(horizontal: 2),
                                                                              ),
                                                                            ],
                                                                            const Padding(
                                                                              padding: EdgeInsets.symmetric(horizontal: 2),
                                                                            ),
                                                                            (_items[index].task.isComp == true)
                                                                                ? Container(
                                                                                    alignment: const Alignment(1, 1),
                                                                                    decoration: const BoxDecoration(
                                                                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                                                                    ),
                                                                                    child: const Icon(
                                                                                      EvaIcons.doneAll,
                                                                                      color: Colors.blue,
                                                                                    ),
                                                                                    padding: const EdgeInsets.all(2.0),
                                                                                    //decoration: BoxDecoration(boxShadow:<BoxShadow>[new BoxShadow(color: const Color.fromARGB(50, 0, 0, 0),offset: new Offset(0.0, 0.0),blurRadius: 0.0)]),
                                                                                  )
                                                                                : const Padding(
                                                                                    padding: EdgeInsets.all(0),
                                                                                  )
                                                                          ],
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  const Padding(
                                                                    padding: EdgeInsets
                                                                        .symmetric(
                                                                            horizontal:
                                                                                5),
                                                                  ),
                                                                ],
                                                              ),
                                                              const Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            5),
                                                              ),
                                                              if (_items[index]
                                                                  .isExpanded) ...[
                                                                //if (true)...[
                                                                if (_items[index]
                                                                            .task
                                                                            .videoTaskItem!
                                                                            .taskState ==
                                                                        VideoTaskState
                                                                            .DOWNLOADING ||
                                                                    _items[index]
                                                                            .task
                                                                            .videoTaskItem!
                                                                            .taskState ==
                                                                        VideoTaskState
                                                                            .PAUSE) ...[
                                                                  Row(
                                                                    //crossAxisAlignment: CrossAxisAlignment.stretch,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceAround,
                                                                    children: [
                                                                      //Padding(padding: EdgeInsets.only(left: 5),),
                                                                      Row(
                                                                        children: [
                                                                          const Icon(
                                                                              FontAwesomeIcons.video,
                                                                              color: Colors.blue,
                                                                              size: 22),
                                                                          if (_items[index].task.videoTaskItem!.mimeType.toString() !=
                                                                              'null') ...[
                                                                            if (_items[index].task.videoTaskItem!.mimeType.toString() ==
                                                                                'm3u8') ...[
                                                                              Container(
                                                                                child: Text(
                                                                                  ' M3U8',
                                                                                  style: MyTexStyle.menu,
                                                                                ),
                                                                              )
                                                                            ] else ...[
                                                                              Container(
                                                                                child: Text(
                                                                                  ' MP4',
                                                                                  style: MyTexStyle.menu,
                                                                                ),
                                                                              )
                                                                            ]
                                                                          ]
                                                                        ],
                                                                      ),
                                                                      const Padding(
                                                                        padding:
                                                                            EdgeInsets.symmetric(horizontal: 5),
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          const Icon(
                                                                              FontAwesomeIcons.file,
                                                                              color: Colors.blue,
                                                                              size: 22),
                                                                          Text(
                                                                              " ${_items[index].task.videoTaskItem!.downloadSizeString()}/${_items[index].task.videoTaskItem!.totalSizeString()}",
                                                                              style: MyTexStyle.menu)
                                                                        ],
                                                                      ),
                                                                      //Padding(padding: EdgeInsets.symmetric(horizontal: 5),),
                                                                    ],
                                                                  ),
                                                                  Container(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child:
                                                                        Stack(
                                                                      alignment:
                                                                          Alignment
                                                                              .topRight,
                                                                      children: [
                                                                        LineChartSample(
                                                                            videoTaskItem:
                                                                                _items[index].task.videoTaskItem!),
                                                                        Container(
                                                                          padding: const EdgeInsets.symmetric(
                                                                              horizontal: 8,
                                                                              vertical: 2),
                                                                          child:
                                                                              Row(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.end,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.end,
                                                                            children: [
                                                                              const Icon(
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
                                                              ]
                                                            ],
                                                          ),
                                                        ),
                                                      ),

                                                      key: Key(_items[index]
                                                          .task
                                                          .name!),
                                                      secondaryActions: <Widget>[
                                                        if (_items[index]
                                                                .task
                                                                .downloadPagetype ==
                                                            MyCommonConstants
                                                                .downloadManagerNormal)
                                                          //if(true)
                                                          IconSlideAction(
                                                            caption:
                                                                'Direct Link',
                                                            color: MyColors
                                                                .primary3,
                                                            foregroundColor:
                                                                Colors.white,
                                                            icon:
                                                                FontAwesomeIcons
                                                                    .download,
                                                            closeOnTap: true,
                                                            key: Key(
                                                                _items[index]
                                                                    .task
                                                                    .name!),
                                                            onTap: () {},
                                                          ),
                                                        IconSlideAction(
                                                          caption: 'Delete',
                                                          color: MyColors.reddy,
                                                          foregroundColor:
                                                              Colors.white,
                                                          icon: FontAwesomeIcons
                                                              .trash,
                                                          closeOnTap: true,
                                                          key: Key(_items[index]
                                                              .task
                                                              .name!),
                                                          onTap: () {
                                                            onRemovePressed(
                                                                _items[index]
                                                                    .task,
                                                                index);
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                              childCount: _items.length,
                                            ),
                                          ),
                                          _sliverspace(100),
                                        ],
                                      )),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        //color: MyColors.primary2,
                                        child: Transform.scale(
                                          scale: 0.8,
                                          child: GestureDetector(
                                              onTap: () {
                                                _myhomepagescafoldkey
                                                    .currentState!
                                                    .openDrawer();
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
                                          onPressed: () {},
                                          child: const Icon(
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
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      CupertinoButton(
                                          child: Text('Refresh',
                                              style: MyTexStyle.normal),
                                          onPressed: () {
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const Downloader(
                                                    title: 'Downloads',
                                                  ),
                                                ),
                                                (Route<dynamic> route) =>
                                                    false);
                                            MyCommonConstants().setSystemUI();
                                          })
                                    ],
                                  ),
                                ],
                              ),
                            )),
                        Container(
                          color: Colors.black,
                          padding: const EdgeInsets.all(5),
                          height: 45,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 1,
                                child: CupertinoButton(
                                  onPressed: () {
                                    print(
                                        "_isRewardButtonDisabled: $_isRewardButtonDisabled");
                                    _internetChecker().then((value) {
                                      if (interneticc !=
                                          ConnectivityResult.none) {
                                        getADDrewboltdowns(15);
                                      } else {
                                        toast.Fluttertoast.showToast(
                                            msg: 'No Internet Connection',
                                            toastLength:
                                                toast.Toast.LENGTH_LONG,
                                            gravity: toast.ToastGravity.BOTTOM);
                                      }
                                    });
                                  },
                                  child: FittedBox(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          EvaIcons.gift,
                                          color: MyColors.primary1,
                                          size: 16,
                                        ),
                                        Text(
                                          " Get +5 Downloads ",
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
                                  color:
                                      (interneticc == ConnectivityResult.none)
                                          ? Colors.white.withOpacity(0.5)
                                          : Colors.orange,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 8),
                                ),
                              ),
                              const Padding(padding: EdgeInsets.all(2.5)),
                              Expanded(
                                flex: 1,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    LiquidLinearProgressIndicator(
                                      value:
                                          boltdowncnt / 10, // Defaults to 0.5.
                                      valueColor: AlwaysStoppedAnimation(
                                          (boltdowncnt >= 10)
                                              ? const Color.fromARGB(
                                                  255, 48, 17, 152)
                                              : Colors
                                                  .blueAccent), // Defaults to the current Theme's accentColor.
                                      backgroundColor: MyColors.opp1.withOpacity(
                                          0.15), // Defaults to the current Theme's backgroundColor.
                                      borderColor:
                                          MyColors.opp1.withOpacity(0.03),
                                      borderWidth: 1,
                                      borderRadius: 8.0,
                                      direction: Axis
                                          .horizontal, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
                                      //center: Text("Loading..."),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          FontAwesomeIcons.bolt,
                                          color: Colors.orange,
                                          size: 23,
                                        ),
                                        Text(
                                          boltdowncnt.toString(),
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
                              const Padding(padding: EdgeInsets.all(2.5)),
                              Expanded(
                                flex: 1,
                                child: CupertinoButton(
                                  onPressed: () async {
                                    await Get.to(const DownloadFromShareInPage(
                                      intentString: '',
                                      isDirectdownfile: false,
                                    ));
                                  },
                                  child: FittedBox(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                            width: w,
                            height: 125 - 55,
                            alignment: Alignment.center,
                            color: Colors.black,
                            child: const MyAdsOnVideoPage()),
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
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.0),
                            child: Text(
                              'Please grant accessing storage permission to continue -_-',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 18.0),
                            ),
                          ),
                          const SizedBox(
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
                              child: const Text(
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
    this.localnametask,
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

  _ItemHolder({required this.name, required this.task});
}
