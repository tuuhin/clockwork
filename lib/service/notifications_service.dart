import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:ui';

class NotificationService {
  static const String portName = 'conversation';

  static final FlutterLocalNotificationsPlugin _notificationBase =
      FlutterLocalNotificationsPlugin();

  static final FlutterLocalNotificationsPlugin _notificationStatic =
      FlutterLocalNotificationsPlugin();

  static Future _staticNotificationDetails() async => const NotificationDetails(
        android: AndroidNotificationDetails(
          '02',
          'static_notification',
          'non removable notificaions',
          importance: Importance.high,
          priority: Priority.high,
          ongoing: true,
          autoCancel: false,
          fullScreenIntent: true,
          visibility: NotificationVisibility.public,
        ),
      );

  static Future _baseNotificationDetails() async => const NotificationDetails(
        android: AndroidNotificationDetails(
          '01',
          'base_notifications',
          'this is for base notifications',
          importance: Importance.defaultImportance,
          visibility: NotificationVisibility.public,
        ),
      );

  static Future init() async {
    await _notificationBase.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onSelectNotification: (payload) async {
        print('printing the payload');
        print(payload);
      },
    );

    await _notificationStatic.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onSelectNotification: (payload) async {
        IsolateNameServer.lookupPortByName(portName)?.send('stop');
        if (payload != null && int.tryParse(payload) != null) {
          int id = int.parse(payload);
          print('i got clicked');
          _notificationStatic.cancel(id);
        }
      },
    );
  }

  static Future showStaticNotification(
      {required int id, String? title, String? body}) async {
    _notificationStatic.show(
        id, title, body, await _staticNotificationDetails(),
        payload: id.toString());
  }

  Future cancelBaseNotification(int id) async => _notificationBase.cancel(id);

  Future showBaseNotification(
          {required int id,
          String? title,
          String? body,
          String? payload}) async =>
      _notificationBase.show(id, title, body, await _baseNotificationDetails(),
          payload: id.toString());
}
