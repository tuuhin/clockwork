import 'dart:isolate';
import 'dart:ui';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:stopwatch/domain/enums/enums.dart';
import 'package:stopwatch/domain/models/models.dart';
import 'package:stopwatch/service/services.dart';
import 'package:stopwatch/utils/time_formatter.dart';

class AlarmService {
  static const double _volume = 1;
  static LazyBox<AlarmsModel>? _alarmsBox;
  final NotificationService _notificationService = NotificationService();

  static Future init() async => await AndroidAlarmManager.initialize();

  static void _nonRepeatingAlarm(int id) async {
    print('enerting a new thread');
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0) && !Hive.isAdapterRegistered(3)) {
      Hive
        ..registerAdapter(RepeatEnumAdapter())
        ..registerAdapter(AlarmsModelAdapter());
    }

    _alarmsBox = await Hive.openLazyBox<AlarmsModel>('alarm');

    print('initialaization done');

    AlarmsModel? _model = await _alarmsBox!.get(id);

    if (_model != null) {
      print('running the notification and alarm');
      NotificationService.showStaticNotification(
          id: id,
          title: alarmFormat(_model.at),
          body: 'Tap to turn off the alarm');

      if (_model.vibrate) {
        Vibrate.feedback(FeedbackType.heavy);
        await Vibrate.vibrate();
      }

      print('active is changed');
      _model.setIsActive = false;
      await _model.save();

      if (_model.deleteAfterDone) {
        await _alarmsBox!.delete(id);
        print('deleted');
      }

      await _alarmsBox!.close();
      FlutterRingtonePlayer.playAlarm(volume: _volume);

      // Conversation between the isolates
      ReceivePort receiver = ReceivePort();
      bool _isRegister = IsolateNameServer.registerPortWithName(
          receiver.sendPort, NotificationService.portName);
      if (!_isRegister) {
        IsolateNameServer.removePortNameMapping(NotificationService.portName);
        IsolateNameServer.registerPortWithName(
            receiver.sendPort, NotificationService.portName);
      }

      receiver.listen(
        (message) async {
          if (message == 'stop') {
            print('stoping the rigntone player');
            await FlutterRingtonePlayer.stop();
            receiver.close();
          }
        },
        onDone: () => IsolateNameServer.removePortNameMapping(
            NotificationService.portName),
      );
    }
  }

  static _repeatingAlarm(int id) async {
    print('enerting a new thread');
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0) && !Hive.isAdapterRegistered(3)) {
      Hive
        ..registerAdapter(RepeatEnumAdapter())
        ..registerAdapter(AlarmsModelAdapter());
    }

    _alarmsBox = await Hive.openLazyBox<AlarmsModel>('alarm');

    print('initialaization done');

    AlarmsModel? _model = await _alarmsBox!.get(id);

    if (_model != null) {
      print('running the notification and alarm');
      NotificationService.showStaticNotification(
          id: id,
          title: ' Regular alarm at ${alarmFormat(_model.at)}',
          body: 'Tap to turn off the alarm');

      if (_model.vibrate) {
        Vibrate.feedback(FeedbackType.heavy);
        await Vibrate.vibrate();
      }

      await _alarmsBox!.close();
      FlutterRingtonePlayer.playAlarm(volume: _volume);

      // Conversation between the isolates
      ReceivePort receiver = ReceivePort();
      bool _isRegister = IsolateNameServer.registerPortWithName(
          receiver.sendPort, NotificationService.portName);
      if (!_isRegister) {
        IsolateNameServer.removePortNameMapping(NotificationService.portName);
        IsolateNameServer.registerPortWithName(
            receiver.sendPort, NotificationService.portName);
      }

      receiver.listen(
        (message) async {
          if (message == 'stop') {
            print('stoping the rigntone player');
            await FlutterRingtonePlayer.stop();
            receiver.close();
          }
        },
        onDone: () => IsolateNameServer.removePortNameMapping(
            NotificationService.portName),
      );
    }
  }

  Future<void> cancelAlarm(int id) async {
    bool _success = await AndroidAlarmManager.cancel(id);
    print(_success ? 'deleted successfully' : 'failed to cancel the alarm');
  }

  void createAlarm(AlarmsModel model) async {
    print(model.at);

    if (model.repeat == RepeatEnum.once) {
      bool _isCreated = await AndroidAlarmManager.oneShotAt(
          model.at, model.id, _nonRepeatingAlarm,
          alarmClock: true, wakeup: true, exact: true);

      if (_isCreated) {
        await _notificationService.showBaseNotification(
          id: model.id,
          title: 'Upcoming alarm at ${alarmFormat(model.at)}',
          body: model.label,
        );
      }
    } else if (model.repeat == RepeatEnum.daily) {
      print('a daily alarm has benn registerd');

      bool _isCreated = await AndroidAlarmManager.periodic(
        const Duration(days: 1),
        model.id,
        _repeatingAlarm,
        startAt: model.at,
        wakeup: true,
        exact: true,
      );
      if (_isCreated) {
        _notificationService.showBaseNotification(
          id: model.id,
          title: 'Daily alarm scheduled at ${alarmFormat(model.at)}',
          body: model.label,
        );
      }
    }
  }
}
