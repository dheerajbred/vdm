import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:videodown/data/model/download.model.dart';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart' as toast;

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

import 'package:videodown/infrastructure/constant.dart';
import 'package:videodown/infrastructure/styles.dart';
import 'package:videodown/infrastructure/themes.dart';
import 'package:videodown/presentation/home.page.dart';
import 'package:videodown/presentation/widgets/ads.widget.dart';
import 'package:videodown/utils/pick_folder.util.dart';

class DownloadFromShareInPage extends StatefulWidget {
  final String intentString;
  final bool isDirectdownfile;

  const DownloadFromShareInPage(
      {Key? key, required this.intentString, this.isDirectdownfile = false})
      : super(key: key);

  @override
  _DownloadFromShareInPageState createState() =>
      _DownloadFromShareInPageState();
}

class _DownloadFromShareInPageState extends State<DownloadFromShareInPage> {
  late TextEditingController _urlController;
  late TextEditingController _thumbUrlController;
  late TextEditingController _nameController;
  late TextEditingController _headerController;
  late TextEditingController _isgrabbedController;
  late FocusNode _videoUrlFocusNode;
  late FocusNode _thumbUrlFocusNode;
  late FocusNode _nameFocusNode;
  late FocusNode _headersFocusNode;
  bool isDownloading = false;
  Map qualities = {};
  late String quality;
  final bool _permissionReady = false;

  String videoUrl = '';
  String thumbUrl = '';
  String name = '';
  String headers = '';
  String isgrabbed = '';

  _navigateToDownloadPage(String val) async {
    String slpitstring = '***8***';
    String value = val.trim().split('magicvdmstring=').last.trim();
    print("_navigateToDownloadPage value: $value");

    setState(() {
      videoUrl = value.toString().trim().split(slpitstring).first.trim();
    });
    // String thumbUrl = 'Empty';
    // String name = 'Empty';
    // String headers = 'Empty';
    // String isgrabbed = 'Empty';

    if (value.toString().trim().contains('isCustomVdm')) {
      var cus = value.toString().trim().split(slpitstring);
      var cu = cus
          .firstWhere((element) => element.contains('isCustomVdm'))
          .trim()
          .split('===')
          .last
          .trim();
      if (cu == '1') {
        setState(() {
          isgrabbed = 'isgrabbedtrue';
        });
      }
    }
    if (value.toString().trim().contains('customVdmVideoImg')) {
      var cut = value.toString().trim().split(slpitstring);
      var cur = cut
          .firstWhere((element) => element.contains('customVdmVideoImg'))
          .trim()
          .split('===')
          .last
          .trim();
      if ((cur != 'empty') || (cur != '') || (cur != null)) {
        setState(() {
          thumbUrl = cur.trim();
        });
      }
    }
    if (value.toString().trim().contains('customVdmTitle')) {
      var cut = value.toString().trim().split(slpitstring);
      var cur = cut
          .firstWhere((element) => element.contains('customVdmTitle'))
          .trim()
          .split('===')
          .last
          .trim();
      if ((cur != 'empty') || (cur != '') || (cur != null)) {
        setState(() {
          name = cur.trim().removeClutter();
        });
      }
    }
    if (value.toString().trim().contains('customVdmHeaders')) {
      var cut = value.toString().trim().split(slpitstring);
      var cur = cut
          .firstWhere((element) => element.contains('customVdmHeaders'))
          .trim()
          .split('===')
          .last
          .trim();
      if ((cur != 'empty') || (cur != '') || (cur != null)) {
        setState(() {
          headers = cur.trim();
        });
      }
    }

    print(
        '_navigateToDownloadPage videoUrl: $videoUrl thumbUrl: $thumbUrl name: $name headers: $headers isgrabbed: $isgrabbed');

    // var arguments = DownloadsArguments(videoUrl, thumbUrl, name, headers, isgrabbed);

    // await Get.toNamed('/download', arguments: arguments);
    return true;
  }

  @override
  void initState() {
    super.initState();
    _navigateToDownloadPage(widget.intentString);

    //MyCommonConstants().videoAd(9999);

    _urlController = TextEditingController();
    _thumbUrlController = TextEditingController();
    _nameController = TextEditingController();
    _headerController = TextEditingController();
    _isgrabbedController = TextEditingController();
    _videoUrlFocusNode = FocusNode();
    _thumbUrlFocusNode = FocusNode();
    _nameFocusNode = FocusNode();
    _headersFocusNode = FocusNode();
    // checkPermission();
  }

  // checkPermission() async {
  //   _permissionReady = await _checkPermission();
  // }

  @override
  void dispose() {
    _urlController.dispose();
    _thumbUrlController.dispose();
    _nameController.dispose();
    _headerController.dispose();
    _isgrabbedController.dispose();
    _videoUrlFocusNode.dispose();
    _thumbUrlFocusNode.dispose();
    _nameFocusNode.dispose();
    _headersFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final db = Provider.of<AppDatabase>(context);
    if ((widget.intentString != null) && (widget.intentString != 'Empty')) {
      _urlController.text = videoUrl;
      _thumbUrlController.text = thumbUrl;
      _nameController.text = name;
      _headerController.text = headers;
      _isgrabbedController.text = isgrabbed;
    }
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: !isDownloading
          ? Scaffold(
              appBar: AppBar(
                backgroundColor: MyColors.primary3,
                title: Text('Add to Downloads', style: MyTexStyle.tile),
                automaticallyImplyLeading: false,
                titleSpacing: 0,
                leading: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(EvaIcons.arrowBackOutline)),
              ),
              body: Container(
                color: MyColors.primary3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    (_isgrabbedController.text.trim() == 'isgrabbedtrue')
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 25, horizontal: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    FontAwesomeIcons.check,
                                    color: MyColors.purp,
                                  ),
                                  const Padding(padding: EdgeInsets.all(4)),
                                  Container(
                                    height: 200,
                                    width: 140,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5)),
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            offset: const Offset(0, 5.0),
                                            blurRadius: 20.0)
                                      ],

                                      color: Colors.black12,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                            _thumbUrlController.text,
                                          ),
                                          fit: BoxFit.cover),
                                      //color: Colors.blue,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    child: Text(
                                      _nameController.text,
                                      textAlign: TextAlign.center,
                                      style: MyTexStyle.normal,
                                    ),
                                  ),
                                  const MyAdsOnVideoPage(),
                                ],
                              ),
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(padding: EdgeInsets.all(10)),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: TextField(
                                  controller: _urlController,
                                  focusNode: _videoUrlFocusNode,
                                  style: MyTexStyle.normal,
                                  decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 0),
                                      prefixIcon: Icon(EvaIcons.link,
                                          color: MyColors.reddy.withOpacity(1)),
                                      hintText: "Video Url",
                                      hintStyle: TextStyle(
                                          fontSize: 16,
                                          color: MyColors.reddy.withOpacity(1),
                                          fontWeight: FontWeight.w500,
                                          decoration: TextDecoration.none),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                              MyColors.opp1.withOpacity(0.05),
                                        ),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                MyColors.reddy.withOpacity(1),
                                            width: 3),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      filled: true,
                                      fillColor:
                                          MyColors.opp1.withOpacity(0.04)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: TextField(
                                  controller: _nameController,
                                  focusNode: _nameFocusNode,
                                  style: MyTexStyle.normal,
                                  decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 0),
                                      prefixIcon: Icon(EvaIcons.filmOutline,
                                          color: MyColors.reddy.withOpacity(1)),
                                      hintText: "Video Name",
                                      hintStyle: TextStyle(
                                          fontSize: 16,
                                          color: MyColors.reddy.withOpacity(1),
                                          fontWeight: FontWeight.w500,
                                          decoration: TextDecoration.none),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                              MyColors.opp1.withOpacity(0.05),
                                        ),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                MyColors.reddy.withOpacity(1),
                                            width: 3),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      filled: true,
                                      fillColor:
                                          MyColors.opp1.withOpacity(0.04)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: TextField(
                                  controller: _thumbUrlController,
                                  focusNode: _thumbUrlFocusNode,
                                  style: MyTexStyle.normal,
                                  decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 0),
                                      prefixIcon: Icon(EvaIcons.imageOutline,
                                          color: MyColors.reddy.withOpacity(1)),
                                      hintText: "Thumbnail",
                                      hintStyle: TextStyle(
                                          fontSize: 16,
                                          color: MyColors.reddy.withOpacity(1),
                                          fontWeight: FontWeight.w500,
                                          decoration: TextDecoration.none),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                              MyColors.opp1.withOpacity(0.05),
                                        ),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                MyColors.reddy.withOpacity(1),
                                            width: 3),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      filled: true,
                                      fillColor:
                                          MyColors.opp1.withOpacity(0.04)),
                                ),
                              ),
                            ],
                          ),
                    Padding(
                      padding: const EdgeInsets.all(
                        NavigationToolbar.kMiddleSpacing,
                      ),
                      child: SizedBox(
                          width: double.infinity,
                          child:
                              /*quality == null
                            ? */
                              CupertinoButton(
                            color: Colors.red,
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            onPressed: () async {
                              if (_urlController.text == '') {
                              } else {
                                openFolderPicker().then((value) {
                                  MyCommonConstants()
                                      .addToVideoToDatabase(
                                          _nameController.text,
                                          _urlController.text,
                                          _thumbUrlController.text,
                                          _isgrabbedController.text,
                                          _headerController.text,
                                          value)
                                      .then((value) {
                                    if (widget.isDirectdownfile) {
                                      toast.Fluttertoast.showToast(
                                          backgroundColor:
                                              Colors.blueAccent[700],
                                          msg:
                                              'Clear from RAM & restart the app',
                                          toastLength: toast.Toast.LENGTH_LONG,
                                          gravity: toast.ToastGravity.BOTTOM);
                                    }
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Downloader(
                                              title: "Downloads",
                                              nointent_previousintent:
                                                  widget.intentString),
                                        ),
                                        (Route<dynamic> route) => false);
                                  });
                                });
                              }
                            },
                            child: Text('Add Video',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: MyColorsTheme1.primary1,
                                  fontWeight: FontWeight.w600,
                                )),
                          )),
                    ),
                  ],
                ),
              ),
            )
          : Scaffold(
              body: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text('Downloading...')
                  ],
                ),
              ),
            ),
    );
  }
}
