import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:videodown/infrastructure/styles.dart';
import 'package:videodown/infrastructure/themes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:videodown/bloc/mycolor_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:videodown/presentation/home.page.dart';
import 'package:videodown/utils/local_notification_init.use.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  FlutterNotification.init();

  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  await OneSignal.shared.setAppId('08f46e11-9212-4109-947e-38c7c4b0a83d');

  _runTheApp();
}

_runTheApp() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  MyThemeClass initial = MyThemeClass(
    themename: preferences.getString("themename") ?? MyColorsTheme1.themename,
  );

  MyTexStyle().init(initial);
  MyColors().init(initial);

  runApp(BlocProvider<MyColorBloc>(
      create: (context) {
        return MyColorBloc();
      },
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Video Download Manager (VDM)',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const Downloader(
        title: "Downloads",
      ),
    );
  }
}
