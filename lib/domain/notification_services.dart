import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future init() async {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
            onDidReceiveLocalNotification: (id, title, body, payload) => null);
    const LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) => null,
    );
  }

  /// SHOW A SIMPLE NOTIFICATION

static Future showSimpleNotifications({required String title, required String body, required String payload})async{
    const AndroidNotificationDetails androidNotificationDetails=AndroidNotificationDetails('your channel id', 'your channel name',channelDescription: 'your channel description',
    importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker'
    );
    const NotificationDetails notificationDetails=NotificationDetails(android: androidNotificationDetails);
  await flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails,payload: payload);
}
static Future showPeriodicNotification({required String title, required String body, required String payload})async{
    const AndroidNotificationDetails androidNotificationDetails=AndroidNotificationDetails('channel 2', 'your channel name',channelDescription: 'your channel description',
    importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker'
    );
    const NotificationDetails notificationDetails=NotificationDetails(android: androidNotificationDetails);
    debugPrint('ok');
  await flutterLocalNotificationsPlugin.periodicallyShow(1, title, body,RepeatInterval.everyMinute, notificationDetails,);
}
}
