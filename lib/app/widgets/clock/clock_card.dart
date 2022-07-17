import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../context/context.dart';
import '../../../domain/models/detailed_timezone_model.dart';
import '../../../utils/time_formatter.dart';
import '../app_widgets.dart';
import 'small_clock_painter.dart';

class ClockCard extends StatefulWidget {
  const ClockCard({Key? key, required this.zone}) : super(key: key);
  final DetailedTimeZoneModel zone;

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
    final DateTime current = getime(widget.zone.offset);
    final bool isDay = current.hour >= 6 && current.hour <= 16;
    return Dismissible(
      confirmDismiss: (DismissDirection direction) async => true,
      direction: DismissDirection.endToStart,
      onDismissed: (DismissDirection direction) {
        _timeZoneContext.removeIndividualModel(widget.zone);
      },
      background: Card(
          color: Colors.black,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const <Widget>[
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
                  colors: isDay
                      ? <Color>[Colors.grey, Colors.white54]
                      : <Color>[Colors.black, Colors.black54],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
              shape: BoxShape.circle,
            ),
            child: CustomPaint(
              painter: SmallClockPainter(
                current: current,
                dialColor: isDay ? Colors.black : Colors.white,
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
