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
    DateTime _current = getime(zone.offset);
    bool _isDay = _current.hour > 6 && _current.hour < 16;
    return Card(
      child: ListTile(
        minVerticalPadding: 4,
        leading: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: _isDay
                    ? [Colors.grey, Colors.white54]
                    : [Colors.black, Colors.black54],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
            shape: BoxShape.circle,
          ),
          child: CustomPaint(
            painter: SmallClockPainter(
              current: _current,
              dialColor: _isDay ? Colors.black : Colors.white,
            ),
          ),
        ),
        title: Text(zone.location),
        subtitle: zone.area != 'Etc' ? Text(zone.area) : null,
        trailing: Text(
          getTimeFromOffset(zone.offset),
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
      ),
    );
  }
}
