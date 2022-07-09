import 'package:hive_flutter/hive_flutter.dart';
import 'package:stopwatch/domain/models/alarms_model.dart';

class AlarmData {
  static Box<AlarmsModel>? _alarmsBox;

  static Future<void> init() async {
    _alarmsBox = await Hive.openBox<AlarmsModel>('alarm');
  }

  static Box<AlarmsModel>? get alarmBox => _alarmsBox;

  Future<void> addAlarm(AlarmsModel alarm) async {
    int _id = await _alarmsBox!.add(alarm);
    alarm.setId = _id;

    await alarm.save();
  }

  List<AlarmsModel> getAlarms() => _alarmsBox!.values.toList();

  void removeAlarm(AlarmsModel alarm) {
    int id = alarm.id;
    AlarmsModel? _oldAlarm = _alarmsBox!.get(id);
    if (_oldAlarm != null) {
      _alarmsBox!.delete(id);
    }
  }

  int getIndex(zone) => _alarmsBox!.values.toList().indexOf(zone);

  bool isAlarmAlreadyExists(AlarmsModel model) => _alarmsBox!.values
      .toList()
      .where((element) => element.at == model.at)
      .isNotEmpty;
}
