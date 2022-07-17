import 'dart:isolate';
import 'dart:ui';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../domain/enums/enums.dart';
import '../domain/models/models.dart';
import '../utils/time_formatter.dart';
import 'services.dart';

class AlarmService {
  static const double _volume = 1;
  static LazyBox<AlarmsModel>? alarmsBox;
  final NotificationService _notificationService = NotificationService();

  static Future<void> init() async => AndroidAlarmManager.initialize();

  static Future<void> _nonRepeatingAlarm(int id) async {
    debugPrint('enerting a new thread');
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0) && !Hive.isAdapterRegistered(3)) {
      Hive
        ..registerAdapter(RepeatEnumAdapter())
        ..registerAdapter(AlarmsModelAdapter());
    }

    alarmsBox = await Hive.openLazyBox<AlarmsModel>('alarm');

    final AlarmsModel? model = await alarmsBox!.get(id);

    if (model != null) {
      debugPrint('running the notification and alarm');
      NotificationService.showStaticNotification(
          id: id,
          title: alarmFormat(model.at),
          body: 'Tap to turn off the alarm');

      if (model.vibrate) {
        Vibrate.feedback(FeedbackType.heavy);
        await Vibrate.vibrate();
      }

      debugPrint('active is changed');
      model.setIsActive = false;
      await model.save();

      if (model.deleteAfterDone) {
        await alarmsBox!.delete(id);
        debugPrint('deleted');
      }

      await alarmsBox!.close();
      FlutterRingtonePlayer.playAlarm(volume: _volume);

      // Conversation between the isolates
      final ReceivePort receiver = ReceivePort();
      final bool isRegister = IsolateNameServer.registerPortWithName(
          receiver.sendPort, NotificationService.portName);
      if (!isRegister) {
        IsolateNameServer.removePortNameMapping(NotificationService.portName);
        IsolateNameServer.registerPortWithName(
            receiver.sendPort, NotificationService.portName);
      }

      receiver.listen(
        (dynamic message) async {
          if (message == 'stop') {
            debugPrint('stoping the rigntone player');
            await FlutterRingtonePlayer.stop();
            receiver.close();
          }
        },
        onDone: () => IsolateNameServer.removePortNameMapping(
            NotificationService.portName),
      );
    }
  }

  static Future<void> _repeatingAlarm(int id) async {
    debugPrint('enerting a new thread');
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0) && !Hive.isAdapterRegistered(3)) {
      Hive
        ..registerAdapter(RepeatEnumAdapter())
        ..registerAdapter(AlarmsModelAdapter());
    }

    alarmsBox = await Hive.openLazyBox<AlarmsModel>('alarm');

    final AlarmsModel? model = await alarmsBox!.get(id);

    if (model != null) {
      debugPrint('running the notification and alarm');
      NotificationService.showStaticNotification(
          id: id,
          title: ' Regular alarm at ${alarmFormat(model.at)}',
          body: 'Tap to turn off the alarm');

      if (model.vibrate) {
        Vibrate.feedback(FeedbackType.heavy);
        await Vibrate.vibrate();
      }

      model.setAt = model.at.add(const Duration(days: 1));

      await alarmsBox!.close();
      FlutterRingtonePlayer.playAlarm(volume: _volume);

      // Conversation between the isolates
      final ReceivePort receiver = ReceivePort();
      final bool isRegister = IsolateNameServer.registerPortWithName(
          receiver.sendPort, NotificationService.portName);
      if (!isRegister) {
        IsolateNameServer.removePortNameMapping(NotificationService.portName);
        IsolateNameServer.registerPortWithName(
            receiver.sendPort, NotificationService.portName);
      }

      receiver.listen(
        (dynamic message) async {
          if (message == 'stop') {
            debugPrint('stoping the rigntone player');
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
    final bool success = await AndroidAlarmManager.cancel(id);
    debugPrint(success ? 'deleted successfully' : 'failed to cancel the alarm');
  }

  Future<void> createAlarm(AlarmsModel model) async {
    debugPrint(model.at.toString());

    if (model.repeat == RepeatEnum.once) {
      final bool isCreated = await AndroidAlarmManager.oneShotAt(
          model.at, model.id, _nonRepeatingAlarm,
          alarmClock: true, wakeup: true, exact: true);

      if (isCreated) {
        await _notificationService.showBaseNotification(
          id: model.id,
          title: 'Upcoming alarm at ${alarmFormat(model.at)}',
          body: model.label,
        );
      }
    } else if (model.repeat == RepeatEnum.daily) {
      debugPrint('a daily alarm has benn registerd');

      final bool isCreated = await AndroidAlarmManager.periodic(
        const Duration(days: 1),
        model.id,
        _repeatingAlarm,
        startAt: model.at,
        wakeup: true,
        exact: true,
      );
      if (isCreated) {
        _notificationService.showBaseNotification(
          id: model.id,
          title: 'Daily alarm scheduled at ${alarmFormat(model.at)}',
          body: model.label,
        );
      }
    }
  }
}
