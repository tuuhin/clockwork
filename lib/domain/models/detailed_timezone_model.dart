import 'package:hive/hive.dart';

part 'detailed_timezone_model.g.dart';

@HiveType(typeId: 02)
class DetailedTimeZoneModel extends HiveObject {
  DetailedTimeZoneModel({
    required this.location,
    required this.area,
    required this.offset,
    this.isSelected = false,
  });
  @HiveField(0)
  String location;

  @HiveField(1)
  String area;

  @HiveField(2)
  int offset;

  @HiveField(3)
  bool isSelected;

  // ignore: avoid_setters_without_getters
  set changeSelectMode(bool mode) => isSelected = mode;

  @override
  String toString() => location;
}
