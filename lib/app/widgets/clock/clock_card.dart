import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stopwatch/app/widgets/app_widgets.dart';
import 'package:stopwatch/app/widgets/clock/small_clock_painter.dart';
import 'package:stopwatch/context/context.dart';
import 'package:stopwatch/domain/models/detailed_timezone_model.dart';
import 'package:stopwatch/utils/time_formatter.dart';

class ClockCard extends StatefulWidget {
  final DetailedTimeZoneModel zone;
  const ClockCard({Key? key, required this.zone}) : super(key: key);

  @override
  State<ClockCard> createState() => _ClockCardState();
}

class _ClockCardState extends State<ClockCard> {
  late TimeZoneContext _timeZoneContext;

  @override
  void didChangeDependencies() {
    _timeZoneContext = Provider.of<TimeZoneContext>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ClockTime>(context);
    DateTime _current = getime(widget.zone.offset);
    bool _isDay = _current.hour > 6 && _current.hour < 16;
    return Dismissible(
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return true;
      },
      onDismissed: (direction) {
        _timeZoneContext.removeIndividualModel(widget.zone);
      },
      background: Card(
          color: Colors.black,
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: const [
            Icon(
              Icons.delete_outline,
              color: Colors.white,
            ),
            SizedBox(width: 20)
          ])),
      key: ObjectKey(widget.zone),
      child: Card(
        borderOnForeground: false,
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
          title: Text(widget.zone.location),
          subtitle: widget.zone.area != 'Etc' ? Text(widget.zone.area) : null,
          trailing: Text(
            getTimeFromOffset(widget.zone.offset),
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
        ),
      ),
    );
  }
}
