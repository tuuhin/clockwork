import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static const String portName = 'conversation';

  static final FlutterLocalNotificationsPlugin _notificationBase =
      FlutterLocalNotificationsPlugin();

  static final FlutterLocalNotificationsPlugin _notificationStatic =
      FlutterLocalNotificationsPlugin();

  static Future<NotificationDetails?> _staticNotificationDetails() async =>
      const NotificationDetails(
        android: AndroidNotificationDetails(
          '02',
          'static_notification',
          channelDescription: 'non removable notificaions',
          importance: Importance.high,
          priority: Priority.high,
          ongoing: true,
          autoCancel: false,
          fullScreenIntent: true,
          visibility: NotificationVisibility.public,
        ),
      );

  static Future<NotificationDetails?> _baseNotificationDetails() async =>
      const NotificationDetails(
        android: AndroidNotificationDetails(
          '01',
          'base_notifications',
          channelDescription: 'this is for base notifications',
          visibility: NotificationVisibility.public,
        ),
      );

  static void init() {
    _notificationBase.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onSelectNotification: (String? payload) async {
        debugPrint(payload);
      },
    );

    _notificationStatic.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onSelectNotification: (String? payload) async {
        IsolateNameServer.lookupPortByName(portName)?.send('stop');
        if (payload != null && int.tryParse(payload) != null) {
          final int id = int.parse(payload);

          _notificationStatic.cancel(id);
        }
      },
    );
  }

  static Future<void> showStaticNotification(
      {required int id, String? title, String? body}) async {
    _notificationStatic.show(
        id, title, body, await _staticNotificationDetails(),
        payload: id.toString());
  }

  Future<void> cancelBaseNotification(int id) async =>
      _notificationBase.cancel(id);

  Future<void> showBaseNotification(
          {required int id,
          String? title,
          String? body,
          String? payload}) async =>
      _notificationBase.show(id, title, body, await _baseNotificationDetails(),
          payload: id.toString());
}
