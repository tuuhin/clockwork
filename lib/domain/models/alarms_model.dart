import 'package:hive/hive.dart';
import 'package:stopwatch/domain/enums/enums.dart';
part 'alarms_model.g.dart';

@HiveType(typeId: 0)
class AlarmsModel extends HiveObject {
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

  AlarmsModel({
    this.id = 0,
    required this.at,
    this.repeat = RepeatEnum.once,
    this.vibrate = true,
    this.label,
    this.deleteAfterDone = false,
    this.isActive = true,
  });

  set setId(int id) => id = id;
}
