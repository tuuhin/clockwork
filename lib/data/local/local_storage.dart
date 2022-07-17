import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/enums/repeat_enum.dart';
import '../../domain/models/models.dart';
import '../data.dart';
import 'time_zone_data.dart';

// ignore: avoid_classes_with_only_static_members
class LocalStorage {
  static Future<dynamic> init() async {
    await Hive.initFlutter();
    Hive
      ..registerAdapter(AlarmsModelAdapter())
      ..registerAdapter(TimeZoneModelAdapter())
      ..registerAdapter(DetailedTimeZoneModelAdapter())
      ..registerAdapter(RepeatEnumAdapter());
    await AlarmData.init();
    await TimeZoneData.init();
  }
}
