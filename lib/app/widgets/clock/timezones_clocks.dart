import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stopwatch/app/widgets/app_widgets.dart';
import 'package:stopwatch/context/context.dart';
import 'package:stopwatch/domain/models/models.dart';

class TimeZonesClock extends StatefulWidget {
  const TimeZonesClock({Key? key}) : super(key: key);

  @override
  State<TimeZonesClock> createState() => _TimeZonesClockState();
}

class _TimeZonesClockState extends State<TimeZonesClock> {
  late TimeZoneContext _timeZoneContext;
  late List<DetailedTimeZoneModel> _zones;
  // final List<DetailedTimeZoneModel> _zones = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future future = Future(() {});
      for (DetailedTimeZoneModel entry in _zones) {
        future = future
            .then((_) => Future.delayed(const Duration(milliseconds: 50), () {
                  // _zones.add(entry);
                  _timeZoneContext.zonesListKey.currentState!
                      .insertItem(_zones.indexOf(entry));
                }));
      }
    });
  }

  @override
  void didChangeDependencies() {
    _timeZoneContext = Provider.of<TimeZoneContext>(context);
    _zones = _timeZoneContext.getAllDetailedModels();
    print('called');

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
        physics: const BouncingScrollPhysics(),
        key: _timeZoneContext.zonesListKey,
        itemBuilder: (context, index, animation) {
          final Tween<Offset> _offset = Tween<Offset>(
            begin: const Offset(-1, 0),
            end: const Offset(0, 0),
          );

          final Tween<double> _opacity = Tween<double>(
            begin: 0.0,
            end: 1.0,
          );

          print(index);
          return FadeTransition(
            opacity: animation.drive(_opacity),
            child: SlideTransition(
              position: animation.drive(_offset),
              child: ClockCard(
                zone: _zones[index],
              ),
            ),
          );
        });
  }
}
