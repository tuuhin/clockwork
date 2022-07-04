import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stopwatch/app/routes/clock_locations.dart';
import 'package:stopwatch/app/widgets/app_widgets.dart';
import 'package:stopwatch/context/context.dart';
import 'package:stopwatch/utils/time_formatter.dart' show clockFormat;

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
        child: Column(children: [
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

Route clockLocations() => PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 400),
      pageBuilder: ((context, animation, secondaryAnimation) {
        Animation<double> _opacity =
            Tween<double>(begin: 0.0, end: 1.0).animate(animation);
        Animation<Offset> _offset = Tween<Offset>(
                begin: const Offset(1, 0), end: const Offset(0, 0))
            .animate(
                CurvedAnimation(parent: animation, curve: Curves.decelerate));

        return SlideTransition(
          position: _offset,
          child: FadeTransition(
            opacity: _opacity,
            child: const ClockLocations(),
          ),
        );
      }),
    );
