import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/models/models.dart';

class TimeZoneData {
  static Box<TimeZoneModel>? box;
  static Box<DetailedTimeZoneModel>? details;

  static Future<void> init() async {
    box = await Hive.openBox<TimeZoneModel>('time_zones');
    details = await Hive.openBox<DetailedTimeZoneModel>('detailed_time_zones');
  }

  Future<void> addZone(TimeZoneModel timeZone) async => box!.add(timeZone);

  Future<void> addDetailedZone(DetailedTimeZoneModel timeZone) async =>
      details!.add(timeZone);

  List<TimeZoneModel> getAllZones() => box!.values.toList();

  List<DetailedTimeZoneModel> getAllDetailedZones() =>
      details!.values.toList().reversed.toList();

  bool checkIfDetailedModelExists(TimeZoneModel zone) => details!.values
      .where((DetailedTimeZoneModel element) =>
          element.location == zone.location ||
          element.location == zone.region && element.area == element.area)
      .isNotEmpty;

  Future<void> clearDetailedModels() async => details!.clear();

  Future<void> removeIndividualModel(DetailedTimeZoneModel zone) async {
    for (final dynamic key in details!.keys) {
      if (details!.get(key) == zone) {
        await details!.delete(key);
      }
    }
  }

  int getIndex(DetailedTimeZoneModel zone) =>
      details!.values.toList().indexOf(zone);
}
