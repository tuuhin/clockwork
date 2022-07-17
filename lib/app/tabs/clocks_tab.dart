import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../context/context.dart';
import '../../utils/time_formatter.dart' show clockFormat;
import '../routes/clock_locations.dart';
import '../widgets/app_widgets.dart';

class ClocksTab extends StatefulWidget {
  const ClocksTab({Key? key}) : super(key: key);

  @override
  State<ClocksTab> createState() => _ClocksTabState();
}

class _ClocksTabState extends State<ClocksTab> {
  late ClockTime _clck;

  @override
  void didChangeDependencies() {
    _clck = Provider.of<ClockTime>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: <Widget>[
          const AnalogClock(),
          Text('Current:  ${_clck.day}/${_clck.month}/${_clck.year} '),
          Text(
            clockFormat(_clck),
            style: Theme.of(context).textTheme.headline4!.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
          ),
          const Expanded(child: TimeZonesClock())
        ]),
      ),
      bottomNavigationBar: BottomAppBar(
          child: SizedBox(
        height: 64,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              onPressed: () => Navigator.of(context).push(clockLocations()),
              label: const Text('Add City')),
        ),
      )),
    );
  }
}

Route<dynamic> clockLocations() {
  final Tween<Offset> offset =
      Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero);
  final Tween<double> opacity = Tween<double>(begin: 0.0, end: 1.0);
  return PageRouteBuilder<dynamic>(
    transitionDuration: const Duration(milliseconds: 500),
    reverseTransitionDuration: const Duration(milliseconds: 500),
    pageBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return FadeTransition(
        opacity: animation.drive(opacity),
        child: SlideTransition(
          position: animation.drive(offset),
          child: const ClockLocations(),
        ),
      );
    },
  );
}
