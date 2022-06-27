import 'package:hive_flutter/hive_flutter.dart';
import 'package:stopwatch/data/data.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:stopwatch/data/local/time_zone_data.dart';
import 'package:stopwatch/domain/enums/repeat_enum.dart';
import 'package:stopwatch/domain/models/models.dart';

class LocalStorage {
  static Future init() async {
    /// initilizing [Hive]
    Directory dir = await getApplicationDocumentsDirectory();
    Hive
      ..init(dir.path)
      ..registerAdapter(AlarmsModelAdapter())
      ..registerAdapter(TimeZoneModelAdapter())
      ..registerAdapter(DetailedTimeZoneModelAdapter())
      ..registerAdapter(RepeatEnumAdapter());
    await AlarmData.init();
    await TimeZoneData.init();
  }
}
