import 'package:hive_flutter/hive_flutter.dart';
import 'package:stopwatch/domain/models/models.dart';

class TimeZoneData {
  static Box<TimeZoneModel>? _box;
  static Box<DetailedTimeZoneModel>? _details;

  static Future<void> init() async {
    _box = await Hive.openBox<TimeZoneModel>('time_zones');
    _details = await Hive.openBox<DetailedTimeZoneModel>('detailed_time_zones');
  }

  void addZone(TimeZoneModel timeZone) async => await _box!.add(timeZone);

  void addDetailedZone(DetailedTimeZoneModel timeZone) async =>
      await _details!.add(timeZone);

  List<TimeZoneModel> getAllZones() => _box!.values.toList();

  List<DetailedTimeZoneModel> getAllDetailedZones() =>
      _details!.values.toList().reversed.toList();

  bool checkIfDetailedModelExists(TimeZoneModel zone) => _details!.values
      .where((DetailedTimeZoneModel element) =>
          element.location == zone.location ||
          element.location == zone.region && element.area == element.area)
      .isNotEmpty;

  Future<void> clearDetailedModels() async => await _details!.clear();

  Future<void> removeIndividualModel(DetailedTimeZoneModel zone) async {
    for (var key in _details!.keys) {
      if (_details!.get(key) == zone) {
        await _details!.delete(key);
      }
    }
  }

  int getIndex(zone) => _details!.values.toList().indexOf(zone);
}
