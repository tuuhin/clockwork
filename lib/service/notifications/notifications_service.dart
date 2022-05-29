import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future _notificationDetails() async => const NotificationDetails(
        android: AndroidNotificationDetails(
          'clockwork',
          'clockwork',
          'clockwork',
          importance: Importance.max,
        ),
      );

  static Future init() async {
    InitializationSettings settings = const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
    await _notifications.initialize(
      settings,
      onSelectNotification: (payload) async {
        print(payload);
      },
    );
  }

  static Future showNotification(
          {int id = 0, String? title, String? body, String? payload}) async =>
      _notifications.show(id, title, body, await _notificationDetails());
}
