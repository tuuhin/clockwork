import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../context/context.dart';
import '../../../domain/models/models.dart';
import '../app_widgets.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      Future<dynamic> future = Future<dynamic>(() {});
      for (final DetailedTimeZoneModel entry in _zones) {
        future = future.then((_) =>
            Future<dynamic>.delayed(const Duration(milliseconds: 50), () {
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

    super.didChangeDependencies();
  }

  final Tween<Offset> _offset = Tween<Offset>(
    begin: const Offset(0, -1),
    end: Offset.zero,
  );

  final Tween<double> _opacity = Tween<double>(
    begin: 0.0,
    end: 1.0,
  );

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
        physics: const BouncingScrollPhysics(),
        key: _timeZoneContext.zonesListKey,
        itemBuilder:
            (BuildContext context, int index, Animation<double> animation) {
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
