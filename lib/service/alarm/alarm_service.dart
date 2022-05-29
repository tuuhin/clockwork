import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

class AlarmService {
  static Future init() async {
    await AndroidAlarmManager.initialize();
  }
}
