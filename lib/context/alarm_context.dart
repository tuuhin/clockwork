import 'package:flutter/material.dart';
import 'package:stopwatch/data/data.dart';
import 'package:stopwatch/domain/models/alarms_model.dart';
import 'package:stopwatch/service/services.dart';

class AlarmContext extends ChangeNotifier {
  static final AlarmData _alarmData = AlarmData();
  static final AlarmService _alarmService = AlarmService();
  final GlobalKey<AnimatedListState> _key = GlobalKey<AnimatedListState>();

  GlobalKey<AnimatedListState> get listKey => _key;

  List<AlarmsModel> get alarms => _alarmData.getAlarms();

  void addAlarms(AlarmsModel alarm) {
    // _alarms.add(alarmsModel);
    _alarmData.addAlarm(alarm);
    notifyListeners();
    _alarmService.createNonRepeatingAlarm(alarm);

    int index = _alarmData.getIndex(alarm);
    _key.currentState!.insertItem(index);
  }

  void removeAlarm(AlarmsModel alarm) {
    int index = _alarmData.getIndex(alarm);
    _key.currentState!
        .removeItem(index, (context, animation) => const SizedBox());
    _alarmData.removeAlarm(alarm);
    _alarmService.cancelAlarm(alarm.id);
    notifyListeners();
  }
}
