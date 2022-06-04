import 'package:hive_flutter/hive_flutter.dart';
import 'package:stopwatch/domain/models/models.dart';

class TimeZoneData {
  static Box<TimeZoneModel>? _box;
  static Future<void> init() async {
    _box = await Hive.openBox<TimeZoneModel>('time_zones');
  }

  void addZone(TimeZoneModel timeZone) => _box!.add(timeZone);

  List<TimeZoneModel?> getZones() => _box!.values.toList();
}
