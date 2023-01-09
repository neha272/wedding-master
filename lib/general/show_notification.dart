import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ShowNotification {
  static final _notification = FlutterLocalNotificationsPlugin();

  static initialize() {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOS = IOSInitializationSettings();
    const initSettings = InitializationSettings(android: android, iOS: iOS);
    _notification.initialize(
      initSettings,
    );
  }

  static void requestPermissions() {
    _notification
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    _notification
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  static Future _notificationDetail() async {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
          "channel id",
          "channel name",
          importance: Importance.max,
        ),
        iOS: IOSNotificationDetails());
  }

  static Future showNoification(
          {String? title, String? body, String? payload}) async =>
      _notification.show(0, title, body, await _notificationDetail(),
          payload: payload);
}
