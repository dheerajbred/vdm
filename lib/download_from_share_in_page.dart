import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:videodown/downloads.dart';
import 'package:videodown/downloads_database.dart';
import 'package:videodown/colors.dart';
import 'package:provider/provider.dart';
import 'package:typeweight/typeweight.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart' as toast;

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
// import 'package:line_icons/line_icons.dart';
// import 'package:groovin_material_icons/groovin_material_icons.dart';
// import 'package:flutter_easyrefresh/bezier_hour_glass_header.dart';
// import 'package:flutter_easyrefresh/easy_refresh.dart';
// import 'package:mx_player_plugin/mx_player_plugin.dart';
// import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;
import 'package:url_launcher/url_launcher.dart';

// import 'package:line_icons/line_icons.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:expandable/expandable.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadFromShareInPage extends StatefulWidget {
  final String intentString;
  final bool isDirectdownfile;

  DownloadFromShareInPage({Key? key, required this.intentString, this.isDirectdownfile = false}): super(key: key);

  @override
  _DownloadFromShareInPageState createState() =>_DownloadFromShareInPageState();
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
  bool _permissionReady = false;


      String videoUrl = '';
      String thumbUrl = '';
      String name = '';
      String headers = '';
      String isgrabbed = '';



    _navigateToDownloadPage(String val) async {
    
    String slpitstring = '***8***';
    if (val != null) {
      // var split = val.split(slpitstring);
      // final values = {for (int i = 0; i < split.length; i++) i: split[i]};

      // var videoUrl = values[0].toString();
      // var thumbUrl = values[1].toString();
      // var name = values[2].toString();
      // var headers = values[3].toString();
      // var isgrabbed = values[4].toString();

                String value =val.trim().split('magicvdmstring=').last.trim();
          print("_navigateToDownloadPage value: " + value);
      
      setState(() {videoUrl = value.toString().trim().split(slpitstring).first.trim();});
      // String thumbUrl = 'Empty';
      // String name = 'Empty';
      // String headers = 'Empty';
      // String isgrabbed = 'Empty';

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
                    name = cur.trim().removeClutter();
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

      // var arguments = DownloadsArguments(videoUrl, thumbUrl, name, headers, isgrabbed);
      
      // await Get.toNamed('/download', arguments: arguments);
      return true;
    }
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
                    icon: Icon(EvaIcons.arrowBackOutline)),
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
                                  Padding(padding: EdgeInsets.all(4)),
                                  Container(
                                    height: 200,
                                    width: 140,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5)),
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            offset: Offset(0, 5.0),
                                            blurRadius: 20.0)
                                      ],
                                      /*boxShadow: [
                                          BoxShadow(color: Colors.white.withOpacity(0.1),offset: new Offset(-5, -5),blurRadius: 15.0, spreadRadius: 1),
                                          BoxShadow(color: Colors.black.withOpacity(0.8),offset: new Offset(5,5),blurRadius: 15.0, spreadRadius: 1),
                                          ],*/
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
                                  /*Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: IconButton(
                                      icon: Icon(
                                        GroovinMaterialIcons.content_copy,
                                        color: MyColors.opp1.withOpacity(0.2),
                                      ),
                                      onPressed: () {
                                        Clipboard.setData(new ClipboardData(
                                            text: _urlController.text));
                                      },
                                      splashColor:
                                          Colors.black.withOpacity(0.1),
                                    ),
                                  ),*/
                                  //const MyAdmostBanner(),
                                  MyAdsOnVideoPage(),
                                ],
                              ),
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(padding: EdgeInsets.all(10)),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: TextField(
                                  controller: _urlController,
                                  focusNode: _videoUrlFocusNode,
                                  style: MyTexStyle.normal,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
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
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                MyColors.reddy.withOpacity(1),
                                            width: 3),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      filled: true,
                                      fillColor:
                                          MyColors.opp1.withOpacity(0.04)),
                                ),
                              ),
                              /*Padding(
                                padding: const EdgeInsets.all(
                                  NavigationToolbar.kMiddleSpacing,
                                ),
                                child: TextField(
                                  controller: _headerController,
                                  focusNode: _headersFocusNode,
                                  decoration:
                                      InputDecoration(hintText: "Enter Header"),
                                ),
                              ),*/
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: TextField(
                                  controller: _nameController,
                                  focusNode: _nameFocusNode,
                                  style: MyTexStyle.normal,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
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
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                MyColors.reddy.withOpacity(1),
                                            width: 3),
                                        borderRadius: BorderRadius.all(
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
                                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
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
                                        borderRadius: BorderRadius.all(Radius.circular(10),),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                MyColors.reddy.withOpacity(1),
                                            width: 3),
                                        borderRadius: BorderRadius.all(
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
                              // MyCommonConstants().videoAd(9999);
                              // MyCommonConstants().videoAd(0);

                              if (_urlController.text == '') {
                              } else {
                                MyCommonConstants().addToVideoToDatabase(
                                  _nameController.text,
                                  _urlController.text,
                                  _thumbUrlController.text,
                                  _isgrabbedController.text,
                                  _headerController.text,
                                ).then((value) {
                                  if(widget.isDirectdownfile){
                                    toast.Fluttertoast.showToast(
                                      backgroundColor: Colors.blueAccent[700],
                                              msg: 'Clear from RAM & restart the app',
                                              toastLength: toast.Toast.LENGTH_LONG,
                                              gravity: toast.ToastGravity.BOTTOM);
                                  }
                                  Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => Downloader(title: "Downloads", nointent_previousintent: widget.intentString),),(Route<dynamic> route) => false);
                                });
                                  //MyCommonConstants().videoAd(0);
                                // if (widget.isIntent) {
                                //   print("---isIntent4");
                                //   // Get.back();
                                // } else {
                                //   Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => Downloader(title: "Downloads",),),(Route<dynamic> route) => false);
                                // }
                              }
                            },
                            child: Text('Add Video',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: MyColorsTheme1.primary1,
                                  fontWeight: FontWeight.w600,
                                )),
                          )
                          /*: RaisedButton(
                                color: Colors.yellow,
                                padding: const EdgeInsets.symmetric(
                                  vertical:
                                      NavigationToolbar.kMiddleSpacing / 1.5,
                                ),
                                elevation: 10,
                                highlightElevation: 1,
                                onPressed: () async {
                                  // if(!_permissionReady) {
                                  //   _buildNoPermissionWarning();
                                  //
                                  // } else {

                                  /*final url = quality;
                                  final name = _nameController.text;
                                  final thumbnail = _thumbUrlController.text;
                                  final headersInput = _headerController.text;
                                  Map<String, String> headers;
                                  if (headersInput.isNotEmpty) {
                                    try {
                                      var splitHeaders =
                                          headersInput.split('|||');
                                      for (var i = 0;
                                          i < splitHeaders.length;
                                          i++) {
                                        var singleEntries =
                                            splitHeaders[i].split('&&&');
                                        headers[singleEntries[0]] =
                                            singleEntries[1];
                                      }
                                    } catch (e) {
                                      headers = {};
                                    }
                                  } else {
                                    headers = {};
                                  }

                                  var currentRecord = (await db.getAllRecord())
                                      .where((r) => r.url == url);

                                  if (currentRecord.isEmpty) {
                                    int id = await db.insertNewRecord(
                                      Record(
                                          url: url,
                                          name: name,
                                          thumbnail: thumbnail,
                                          headers: json.encode(headers),
                                          downloaded: 0),
                                    );

                                    // await load(id, url, headers, (progress) async {
                                    //   // await db.updateRecord(
                                    //   //   Record(id: id, downloaded: progress),
                                    //   // );
                                    // });

                                    DownloadQueue.add(() async {
                                      await load(id, url, headers,
                                          (progress) async {
                                        await db.updateRecord(
                                          Record(id: id, downloaded: progress),
                                        );
                                      });
                                    });
                                  }
                                  Get.back();

                                  // }*/
                                },
                                child: Text(
                                  'Download',
                                  style: GoogleFonts.ubuntuMono(
                                    fontWeight: TypeWeight.bold,
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .fontSize,
                                  ),
                                ),
                              ),*/
                          ),
                    ),
                  ],
                ),
              ),
            )
          : Scaffold(
              body: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
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

  // Widget _buildNoPermissionWarning() => Container(
  //   child: Center(
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 24.0),
  //           child: Text(
  //             'Please grant accessing storage permission to continue -_-',
  //             textAlign: TextAlign.center,
  //             style: TextStyle(color: Colors.blueGrey, fontSize: 18.0),
  //           ),
  //         ),
  //         SizedBox(
  //           height: 32.0,
  //         ),
  //         FlatButton(
  //             onPressed: () {
  //               _checkPermission().then((hasGranted) {
  //                 setState(() {
  //                   _permissionReady = hasGranted;
  //                 });
  //               });
  //             },
  //             child: Text(
  //               'Retry',
  //               style: TextStyle(
  //                   color: Colors.blue,
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 20.0),
  //             ))
  //       ],
  //     ),
  //   ),
  // );

  // Future<bool> _checkPermission() async {
  //   if (TaskManager().platform == TargetPlatform.android) {
  //     final status = await Permission.storage.status;
  //     if (status != PermissionStatus.granted) {
  //       final result = await Permission.storage.request();
  //       if (result == PermissionStatus.granted) {
  //         return true;
  //       }
  //     } else {
  //       return true;
  //     }
  //   } else {
  //     return true;
  //   }
  //   return false;
  // }

}
