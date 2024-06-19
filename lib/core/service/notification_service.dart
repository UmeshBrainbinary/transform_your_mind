import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz; // Add this line

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
            onDidReceiveLocalNotification: (id, title, body, payload) async {
      // Handle notification tapped logic here
    });

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // Handle notification tapped logic here
      },
    );
  }

  static Future<void> requestPermissions() async {
    PermissionStatus status = await Permission.notification.request();

    if (status.isGranted) {
      print(
          '--------------------------------------------------------------Notification permission granted.');
    } else if (status.isDenied) {
      print('Notification permission denied.');
    } else if (status.isPermanentlyDenied) {
      print(
          'Notification permission permanently denied. Go to settings to enable it.');
      await openAppSettings();
    }
  }

  static Future<void> showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Test Notification',
      'This is the body of the notification',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  static Future<void> scheduleNotification(DateTime scheduledDate,
      {String? title, String? description}) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      title ?? 'Scheduled Notification',
      description ?? 'This is the body of the scheduled notification',
      tz.TZDateTime.from(scheduledDate, tz.UTC),
      const NotificationDetails(
        android: AndroidNotificationDetails(
            'your_channel_id', 'your_channel_name',
            channelDescription: 'your_channel_description',
            importance: Importance.max,
            playSound: true,
            priority: Priority.max),
        iOS: DarwinNotificationDetails(),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents
          .time, // Adjust as needed for recurring notifications
    );
  }
}
