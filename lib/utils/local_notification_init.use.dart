import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class FlutterNotification {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static init() async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static void askPermission() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    final result = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
    print(result);
  }

  static pushUpdatedNotification(int progress, String name) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'download_manager',
      'Download Progress of $name',
      importance: Importance.low,
      priority: Priority.low,
      onlyAlertOnce: true,
      showProgress: true,
      maxProgress: 100,
      progress: progress,
      ongoing:
          true, // Ensures the notification stays ongoing in the notification panel
      ticker:
          'Download in progress', // Shows a ticker text for the ongoing notification
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'Download Progress',
      '$progress%',
      platformChannelSpecifics,
    );
  }

  static pushDownloadedNotification(String name) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'download_manager_done',
      'Download Complete',
      importance: Importance.max,
      priority: Priority.high,
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'Download Done',
      '$name is downloaded successfully',
      platformChannelSpecifics,
    );
  }
}
