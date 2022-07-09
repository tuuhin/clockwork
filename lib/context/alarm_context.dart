import 'package:flutter/material.dart';
import 'package:stopwatch/data/data.dart';
import 'package:stopwatch/domain/models/alarms_model.dart';
import 'package:stopwatch/service/services.dart';

class AlarmContext extends ChangeNotifier {
  static final AlarmData _alarmData = AlarmData();
  static final AlarmService _alarmService = AlarmService();
  static final NotificationService _notificationService = NotificationService();
  final GlobalKey<AnimatedListState> _key = GlobalKey<AnimatedListState>();

  GlobalKey<AnimatedListState> get listKey => _key;

  List<AlarmsModel> get alarms => _alarmData.getAlarms();

  void addAlarms(AlarmsModel alarm) async {
    // _alarms.add(alarmsModel);
    await _alarmData.addAlarm(alarm);
    notifyListeners();
    _alarmService.createAlarm(alarm);
    int index = _alarmData.getIndex(alarm);
    if (_key.currentState != null) {
      _key.currentState!.insertItem(index);
    }
  }

  void removeAlarm(AlarmsModel alarm) async {
    int index = _alarmData.getIndex(alarm);
    if (_key.currentState != null) {
      _key.currentState!.removeItem(
        index,
        (context, animation) => const SizedBox(),
      );
    }
    _alarmData.removeAlarm(alarm);
    await _alarmService.cancelAlarm(alarm.id);
    notifyListeners();
  }

  void removeAllAlarms() {
    for (AlarmsModel alarm in _alarmData.getAlarms()) {
      removeAlarm(alarm);
    }
  }

  bool isAlarmAlreadyExists(AlarmsModel alarm) =>
      _alarmData.isAlarmAlreadyExists(alarm);

  void changeAlarmMode(AlarmsModel alarm, bool active) async {
    alarm.setIsActive = active;
    await alarm.save();
    if (alarm.isActive) {
      _alarmService.createAlarm(alarm);
      print('alarm created');
    } else {
      await _alarmService.cancelAlarm(alarm.id);
      await _notificationService.cancelBaseNotification(alarm.id);
      print('alarm canceled');
    }
    notifyListeners();
  }
}
