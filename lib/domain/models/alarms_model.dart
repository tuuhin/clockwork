import 'package:hive/hive.dart';

part 'alarms_model.g.dart';

@HiveType(typeId: 0)
class AlarmsModel extends HiveObject {
  @HiveField(0)
  DateTime at;

  @HiveField(1)
  bool repeat;

  @HiveField(2)
  bool vibrate;

  @HiveField(3)
  String? label;

  @HiveField(4)
  bool deleteAfterDone;

  AlarmsModel({
    required this.at,
    required this.repeat,
    required this.vibrate,
    this.label,
    required this.deleteAfterDone,
  });
}
