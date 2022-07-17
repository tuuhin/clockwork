import 'package:flutter/material.dart';
import '../data/data.dart';
import '../domain/models/models.dart';
import '../service/services.dart';

class AlarmContext extends ChangeNotifier {
  final AlarmData _alarmData = AlarmData();
  final AlarmService _alarmService = AlarmService();
  final NotificationService _notificationService = NotificationService();
  final GlobalKey<AnimatedListState> _key = GlobalKey<AnimatedListState>();

  GlobalKey<AnimatedListState> get listKey => _key;

  List<AlarmsModel> get alarms => _alarmData.getAlarms();

  Future<void> addAlarms(AlarmsModel alarm) async {
    await _alarmData.addAlarm(alarm);
    notifyListeners();
    _alarmService.createAlarm(alarm);
    final int index = _alarmData.getIndex(alarm);
    // ignore: always_put_control_body_on_new_line
    if (_key.currentState == null) return;
    _key.currentState!.insertItem(index);
  }

  Future<void> removeAlarm(AlarmsModel alarm) async {
    // ignore: always_put_control_body_on_new_line
    if (_key.currentState == null) return;
    final int index = _alarmData.getIndex(alarm);
    _key.currentState!.removeItem(
      index,
      (BuildContext context, Animation<double> animation) => const SizedBox(),
    );

    _alarmData.removeAlarm(alarm);
    await _alarmService.cancelAlarm(alarm.id);
    notifyListeners();
  }

  void removeAllAlarms() => _alarmData
      .getAlarms()
      .forEach((AlarmsModel element) => removeAlarm(element));

  bool isAlarmAlreadyExists(AlarmsModel alarm) =>
      _alarmData.isAlarmAlreadyExists(alarm);

  Future<void> changeAlarmMode(AlarmsModel alarm, bool active) async {
    if (DateTime.now().day > alarm.at.day) {
      alarm.setAt =
          alarm.at.add(Duration(days: DateTime.now().day - alarm.at.day));
    }

    if (alarm.at.hour < DateTime.now().hour ||
        alarm.at.minute < DateTime.now().minute &&
            DateTime.now().day == alarm.at.day) {
      alarm.setAt = alarm.at.add(const Duration(days: 1));
    }

    alarm.setIsActive = active;
    await alarm.save();
    debugPrint(alarm.toString());
    if (alarm.isActive) {
      _alarmService.createAlarm(alarm);
      debugPrint('alarm created');
    } else {
      await _alarmService.cancelAlarm(alarm.id);
      await _notificationService.cancelBaseNotification(alarm.id);
      debugPrint('alarm canceled');
    }
    notifyListeners();
  }
}
