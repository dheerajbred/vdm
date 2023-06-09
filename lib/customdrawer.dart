import 'dart:async';
import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:get/get.dart';
// import 'package:line_icons/line_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:videodown/colors.dart';
import 'package:videodown/downloads.dart';
import 'package:videodown/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:videodown/bloc/mycolor_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key, this.themeNum, required this.isReviewFinal}) : super(key: key);
  final int? themeNum;
  final bool isReviewFinal;

  @override
  CustomDrawerState createState() {
    return CustomDrawerState();
  }
}

class CustomDrawerState extends State<CustomDrawer>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  late String themenow;

  @override
  Widget build(BuildContext context) {
    final MyColorBloc colorBloc = BlocProvider.of<MyColorBloc>(context);

    return BlocBuilder<MyColorBloc, MyThemeClass>(builder: (context, myTheme) {
      themenow = MyColors.themename;
      MyColors().init(myTheme);
      MyTexStyle().init(myTheme);

      debugPrint(
          "////////////////////////settings---themenow///////////***************" +
              themenow.toString());

      return Drawer(
        child: Container(
          decoration: BoxDecoration(color: MyColors.primary1),
          child: ListView(
            children: <Widget>[
                    Padding(padding: EdgeInsets.symmetric(vertical: 20)), 
              GestureDetector(
                      /*onTap: (){
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainFetchData(gotoUrl: 'normal',),),(Route<dynamic> route) => false);
                      },*/
                      child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Container(
                          height: 120,
                          child: MyNameLogo(),
                          padding: EdgeInsets.all(10),),
                    ),
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 20)), 
              /*new Transform.scale(
                      scale: 1,
                      //padding: EdgeInsets.all(8),
                      child: new TextField(
                      decoration: new InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                        hintText: "Search",
                        hintStyle: TextStyle(fontSize: 16, color:  MyColors.reddy.withOpacity(0.2), fontWeight: FontWeight.w500 ),
                        prefixIcon: Icon(EvaIcons.search,color: MyColors.reddy.withOpacity(0.4) ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent,),
                          borderRadius: BorderRadius.all(Radius.circular(0.0),),
                          ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: MyColors.reddy.withOpacity(0.4),width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(0.0),),
                          ),
                        filled: true,
                        fillColor: MyColors.opp1.withOpacity(0.04)
                        ),

                        style: new TextStyle(fontSize: 16, color:  MyColors.reddy.withOpacity(0.8), fontWeight: FontWeight.w500, decoration: TextDecoration.none ),
                        //controller: _texteditcontroller,
                        onSubmitted: (String str){
                          setState(() {
                            searchtext = str.replaceAll(" ", "%20");
                            String searchurl = 'https://gogoanimes.tv//search.html?keyword=' + searchtext;
                            print('Going to $searchurl');
                            Navigator.push(context,MaterialPageRoute(builder: (context) => CollectionsResultsFetch(url: searchurl, keyword: str,),),);
                          });
                          print('submitted : $str');
                        },

                        ),
                    ),*/

              /*Transform.scale(
                      scale: 1,
                      child: CupertinoButton(
                        onPressed: (){
                          Navigator.of(context).pop(true);
                          //Navigator.push(context,MaterialPageRoute(builder: (context) => Search()));
                        },
                        child: Row(
                          children: <Widget>[
                            Icon(EvaIcons.search,color: MyColors.reddy.withOpacity(1) ),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 5),),
                            Text('Search', style: TextStyle(fontSize: 15, color: MyColors.reddy.withOpacity(1),  fontWeight: FontWeight.w600,  ),),
                          ],
                        ),
                        color: MyColors.opp1.withOpacity(.1),
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                        // needsExtraPaddingOnFocus: false,
                        // borderRadius: 0,
                        //pressedOpacity: 1,
                        //borderRadius: BorderRadius.circular(0),
                      ),
                    ),*/
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, 
                  children: [
                    Text((themenow == MyColorsTheme1.themename) ? 'Dark Mode' : 'Light Mode', style: MyTexStyle.menu,),
                    Padding(padding: EdgeInsets.all(5)),
                    CupertinoSwitch(value: (themenow == MyColorsTheme1.themename) ? true : false, onChanged: (value){
                      if (themenow == MyColorsTheme1.themename) {
                        colorBloc.add(MyColorEvent.Theme2); 
                                              Future.delayed(const Duration(seconds: 1), () {
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Downloader(title: 'Downloads'),),(Route<dynamic> route) => false);
                                                            setState(() {
                                                              MyCommonConstants().setSystemUI();
                                                            });
                                                          });
                      }
                      else if (themenow == MyColorsTheme2.themename) {
                        colorBloc.add(MyColorEvent.Theme1); 
                                              Future.delayed(const Duration(seconds: 1), () {
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Downloader(title: 'Downloads'),),(Route<dynamic> route) => false);
                                                            setState(() {
                                                              MyCommonConstants().setSystemUI();
                                                            });
                                                          });
                      }

                    }),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
              ),
              /*Container(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: CupertinoButton(
                        // needsExtraPaddingOnFocus: false,
                        // borderRadius: 8,
                        color: MyColors.primary3.withOpacity(1),
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 7),
                        onPressed: () {
                          //Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => MainFetchData(gotoUrl: 'normal',),),(Route<dynamic> route) => false);
                        },
                        child: Icon(
                          EvaIcons.home,
                          color: MyColors.opp1,
                          size: 18,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                    ),
                    Expanded(
                      flex: 1,
                      child: CupertinoButton(
                        // needsExtraPaddingOnFocus: false,
                        // borderRadius: 8,
                        color: MyColors.primary3.withOpacity(1),
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 7),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                          //Navigator.push(context,MaterialPageRoute(builder: (context) => Favorites(), ));
                        },
                        child: Icon(
                          EvaIcons.star,
                          color: MyColors.opp1,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              new Padding(
                padding: EdgeInsets.symmetric(vertical: 6),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 25,
                ),
                child: CupertinoButton(
                    // needsExtraPaddingOnFocus: false,
                    // borderRadius: 8,
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      //Navigator.push(context,MaterialPageRoute(builder: (context) => CollectionsResultsFetch(url: MyCommonConstants.defaultBaseURL + 'new-season.html',keyword: 'New Season',)));
                    },
                    child: Text(
                      'New Season',
                      style: MyTexStyle.menubuttonstyle,
                    ),
                    color: MyColors.primary3.withOpacity(1),
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 7)),
              ),
              new Padding(
                padding: EdgeInsets.symmetric(vertical: 6),
              ),
              new Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
              ),*/
              Container(
                      //color: MyColors.primary3.withOpacity(0.5),
                      child: Column(
                      children: <Widget>[
                        /*Padding(padding: EdgeInsets.symmetric(vertical: 5),),
                      Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(EvaIcons.star, color: Color.fromRGBO(238, 180, 9, 1),size: 15,),
                        Icon(EvaIcons.star, color: Color.fromRGBO(238, 180, 9, 1),size: 15,),
                        Icon(EvaIcons.star, color: Color.fromRGBO(238, 180, 9, 1),size: 15,),
                        Icon(EvaIcons.star, color: Color.fromRGBO(238, 180, 9, 1),size: 15,),
                        Icon(EvaIcons.star, color: Color.fromRGBO(238, 180, 9, 1),size: 15,),
                      ],
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 5),),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment(0, 0),
                      child: Text('Please rate to encourage us to add more amazing features and improve the app', style: TextStyle(fontSize: 10, color: MyColors.opp1.withOpacity(0.8),  fontWeight: FontWeight.w300,),textAlign: TextAlign.center,)
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 5),),
                    Transform.scale(
                      scale: 0.7,
                      child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      child: CupertinoButton(
                        onPressed: (){
                        Navigator.of(context).pop(true);
                        MyCommonConstants().launchRateUs();
                      },child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Rate us  ', style: MyTexStyle.menubuttonstyle,),
                          Icon(FeatherIcons.externalLink, size:15, color: MyColors.opp1,)
                        ],
                      ),color: MyColors.opp1.withOpacity(0.04),padding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),),
                    ),
                    ),*/
                    Padding(padding: EdgeInsets.symmetric(vertical: 40),),
                      ],
                    ),
                    ),
            ],
          ),
        ),
      );
    });
  }
}
