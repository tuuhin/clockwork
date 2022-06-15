import 'package:hive_flutter/hive_flutter.dart';
import 'package:stopwatch/domain/models/models.dart';

class TimeZoneData {
  static Box<TimeZoneModel>? _box;
  static Box<DetailedTimeZoneModel>? _details;

  static Future<void> init() async {
    _box = await Hive.openBox<TimeZoneModel>('time_zones');
    _details = await Hive.openBox<DetailedTimeZoneModel>('detailed_time_zones');
  }

  void addZone(TimeZoneModel timeZone) => _box!.add(timeZone);

  void addDetailedZone(DetailedTimeZoneModel timeZone) =>
      _details!.add(timeZone);

  List<TimeZoneModel> getAllZones() => _box!.values.toList();

  List<DetailedTimeZoneModel> getAllDetailedZones() =>
      _details!.values.toList();

  bool checkIfDetailedModelExists(TimeZoneModel zone) => _details!.values
      .where((DetailedTimeZoneModel element) =>
          element.location == zone.location ||
          element.location == zone.region && element.area == element.area)
      .isNotEmpty;
}
