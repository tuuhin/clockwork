import 'package:hive/hive.dart';
import '../enums/enums.dart';
part 'alarms_model.g.dart';

@HiveType(typeId: 0)
class AlarmsModel extends HiveObject {
  AlarmsModel({
    this.id = 0,
    required this.at,
    this.repeat = RepeatEnum.once,
    this.vibrate = true,
    this.label,
    this.deleteAfterDone = false,
    this.isActive = true,
  });
  @HiveField(0)
  int id;

  @HiveField(1)
  DateTime at;

  @HiveField(2)
  RepeatEnum repeat;

  @HiveField(3)
  bool vibrate;

  @HiveField(4)
  String? label;

  @HiveField(5)
  bool deleteAfterDone;

  @HiveField(6)
  bool isActive;

  // ignore: avoid_setters_without_getters
  set setId(int id) => this.id = id;
  // ignore: avoid_setters_without_getters
  set setIsActive(bool active) => isActive = active;
  // ignore: avoid_setters_without_getters
  set setAt(DateTime datetime) => at = datetime;

  @override
  String toString() => '$id. Alarm at ${at.toIso8601String()}';
}
