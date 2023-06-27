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

  static pushUpdatedNotification(int progress, String name, String id) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'download_manager_$id$name',
      'Download Progress of $name',
      importance: Importance.min,
      priority: Priority.low,
      onlyAlertOnce: true,
      showProgress: true,
      maxProgress: 100,
      progress: progress,
      ongoing:
          true, // Ensures the notification stays ongoing in the notification panel
      ticker:
          'Download in progress of $name', // Shows a ticker text for the ongoing notification
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'Download Progress of $name',
      '$progress%',
      platformChannelSpecifics,
    );
  }

  static pushDownloadedNotification(String name, String id) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'download_manager_done$id',
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
