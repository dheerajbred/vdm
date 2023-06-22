import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:line_icons/line_icons.dart';
import 'package:videodown/infrastructure/constant.dart';
import 'package:videodown/infrastructure/styles.dart';
import 'package:videodown/infrastructure/themes.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:videodown/bloc/mycolor_bloc.dart';
import 'package:videodown/presentation/home.page.dart';
import 'package:videodown/presentation/widgets/common.widgets.dart';

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
          "////////////////////////settings---themenow///////////***************$themenow");

      return Drawer(
        child: Container(
          decoration: BoxDecoration(color: MyColors.primary1),
          child: ListView(
            children: <Widget>[
                    const Padding(padding: EdgeInsets.symmetric(vertical: 20)), 
              GestureDetector(
                      /*onTap: (){
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainFetchData(gotoUrl: 'normal',),),(Route<dynamic> route) => false);
                      },*/
                      child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Container(
                          height: 120,
                          padding: const EdgeInsets.all(10),
                          child: const MyNameLogo(),),
                    ),
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 20)), 
             
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, 
                  children: [
                    Text((themenow == MyColorsTheme1.themename) ? 'Dark Mode' : 'Light Mode', style: MyTexStyle.menu,),
                    const Padding(padding: EdgeInsets.all(5)),
                    CupertinoSwitch(value: (themenow == MyColorsTheme1.themename) ? true : false, onChanged: (value){
                      if (themenow == MyColorsTheme1.themename) {
                        colorBloc.add(MyColorEvent.Theme2); 
                                              Future.delayed(const Duration(seconds: 1), () {
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const Downloader(title: 'Downloads'),),(Route<dynamic> route) => false);
                                                            setState(() {
                                                              MyCommonConstants().setSystemUI();
                                                            });
                                                          });
                      }
                      else if (themenow == MyColorsTheme2.themename) {
                        colorBloc.add(MyColorEvent.Theme1); 
                                              Future.delayed(const Duration(seconds: 1), () {
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const Downloader(title: 'Downloads'),),(Route<dynamic> route) => false);
                                                            setState(() {
                                                              MyCommonConstants().setSystemUI();
                                                            });
                                                          });
                      }

                    }),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
              ),
             
              Container(
                      //color: MyColors.primary3.withOpacity(0.5),
                      child: const Column(
                      children: <Widget>[
                     
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
