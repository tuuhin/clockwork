import 'package:hive_flutter/adapters.dart';

part 'timezone_model.g.dart';

@HiveType(typeId: 01)
class TimeZoneModel {
  @HiveField(0)
  String area;

  @HiveField(1)
  String location;

  @HiveField(2)
  String? region;

  @HiveField(3)
  String endpoint;

  TimeZoneModel({
    this.region,
    required this.area,
    required this.location,
    required this.endpoint,
  });

  @override
  String toString() => '$area:$location';
}
