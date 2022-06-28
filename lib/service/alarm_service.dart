import 'dart:isolate';
import 'dart:ui';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stopwatch/data/data.dart';
import 'package:stopwatch/domain/models/models.dart';
import 'package:stopwatch/service/notifications_service.dart';
import 'package:stopwatch/utils/time_formatter.dart';

class AlarmService {
  static LazyBox<AlarmsModel>? _alarmsBox;
  static Future init() async {
    await AndroidAlarmManager.initialize();
  }

  static void nonRepeatingAlarm(int id) async {
    print(DateTime.now().toIso8601String());
    print('enerting a new thread');
    await LocalStorage.init();

    _alarmsBox = await Hive.openLazyBox<AlarmsModel>('alarm');

    // print('initialaization done');
    AlarmsModel? _model = await _alarmsBox!.getAt(id);

    if (_model != null) {
      // print('running the notification and alarm');
      NotificationService.showStaticNotification(
          id: id,
          title: alarmFormat(_model.at),
          body: 'Tap to turn off the alarm');
      FlutterRingtonePlayer.playAlarm(volume: 0.2);

      // Conversation between the isolates
      ReceivePort receiver = ReceivePort();
      IsolateNameServer.registerPortWithName(
          receiver.sendPort, NotificationService.portName);

      receiver.listen((message) async {
        if (message == 'stop') {
          print('stoping the rigntone player');
          await FlutterRingtonePlayer.stop();
        }
      });

      if (_model.vibrate) {
        Vibrate.vibrate();
      }

      if (_model.deleteAfterDone) {
        _alarmsBox!.deleteAt(id);
        // }
      }
      _model.setIsActive = false;
      await _model.save();

      await _alarmsBox!.close();
      print('closed');
    }
  }

  void createNonRepeatingAlarm(AlarmsModel model) async {
    print('alarms are set');
    print(model.at);
    AndroidAlarmManager.oneShotAt(
      model.at,
      model.id,
      nonRepeatingAlarm,
      alarmClock: true,
      wakeup: true,
      exact: true,
    );
    NotificationService.showBaseNotification(
        id: model.id,
        title: 'Upcoming alarm at ${alarmFormat(model.at)}',
        body: model.label);

    //   await AndroidAlarmManager.oneShot(
    //     const Duration(seconds: 5),
    //     0,
    //     callBack,
    //     alarmClock: true,
    //     wakeup: true,
    //   );
    //   print('ready');
  }
}
