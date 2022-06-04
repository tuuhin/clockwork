import 'package:hive_flutter/hive_flutter.dart';
import 'package:stopwatch/domain/models/alarms_model.dart';

class AlarmData {
  static Box<AlarmsModel>? _box;
  static Future<void> init() async {
    _box = await Hive.openBox<AlarmsModel>('alarm');
  }

  void addAlarm(AlarmsModel alarm) => _box!.add(alarm);

  List<AlarmsModel?> getAlarms() => _box!.values.toList();
}
