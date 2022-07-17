import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/models/alarms_model.dart';

class AlarmData {
  static Box<AlarmsModel>? _alarmsBox;

  static Future<void> init() async {
    _alarmsBox = await Hive.openBox<AlarmsModel>('alarm');
  }

  static Box<AlarmsModel>? get alarmBox => _alarmsBox;

  Future<void> addAlarm(AlarmsModel alarm) async {
    final int id = await _alarmsBox!.add(alarm);
    alarm.setId = id;
    await alarm.save();
  }

  List<AlarmsModel> getAlarms() => _alarmsBox!.values.toList();

  void removeAlarm(AlarmsModel alarm) {
    final int id = alarm.id;
    final AlarmsModel? oldAlarm = _alarmsBox!.get(id);
    if (oldAlarm != null) {
      _alarmsBox!.delete(id);
    }
  }

  int getIndex(AlarmsModel zone) => _alarmsBox!.values.toList().indexOf(zone);

  bool isAlarmAlreadyExists(AlarmsModel model) => _alarmsBox!.values
      .toList()
      .where((AlarmsModel element) => element.at == model.at)
      .isNotEmpty;
}
