import 'package:hive_flutter/adapters.dart';

part 'timezone_model.g.dart';

@HiveType(typeId: 01)
class TimeZoneModel extends HiveObject {
  @HiveField(0)
  String area;

  @HiveField(1)
  String location;

  @HiveField(2)
  String? region;

  @HiveField(3)
  String endpoint;

  @HiveField(4)
  bool isSelected;

  @HiveField(5)
  int offset;

  TimeZoneModel(
      {this.region,
      required this.area,
      required this.location,
      required this.endpoint,
      this.offset = 0,
      this.isSelected = false});

  set changeSelectMode(bool isSelected) {
    isSelected = isSelected;
  }

  set newOffset(int offset) {
    offset = offset;
  }

  @override
  String toString() => '$area:$location';
}
