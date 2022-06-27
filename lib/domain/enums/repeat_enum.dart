import 'package:hive/hive.dart';
part 'repeat_enum.g.dart';

@HiveType(typeId: 03)
enum RepeatEnum {
  @HiveField(0)
  daily,

  @HiveField(1)
  once,
}
