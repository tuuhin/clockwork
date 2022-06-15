import 'package:flutter/material.dart';
import 'package:stopwatch/app/widgets/app_widgets.dart';
import 'package:stopwatch/app/widgets/clock/small_clock_painter.dart';
import 'package:stopwatch/domain/models/detailed_timezone_model.dart';
import 'package:stopwatch/utils/time_formatter.dart';

class ClockCard extends StatelessWidget {
  final DetailedTimeZoneModel zone;
  const ClockCard({Key? key, required this.zone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        minVerticalPadding: 4,
        leading: Container(
          height: 50,
          width: 50,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.white, Colors.grey],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
            shape: BoxShape.circle,
          ),
          child: CustomPaint(
            painter: SmallClockPainter(current: getime(zone.offset)),
          ),
        ),
        title: Text(zone.location),
        subtitle: Text(zone.area),
        trailing: Text(getTimeFromOffset(zone.offset)),
      ),
    );
  }
}
