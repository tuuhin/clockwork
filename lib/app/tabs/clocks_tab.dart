import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stopwatch/app/routes/clock_locations.dart';
import 'package:stopwatch/app/widgets/clock/clock_painter.dart';
import 'package:stopwatch/context/context.dart';
import 'package:stopwatch/utils/formatter.dart' show clocFormat;

class ClocksTab extends StatelessWidget {
  const ClocksTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final ClockTime _clck = Provider.of<ClockTime>(context);

    return Scaffold(
      body: Column(children: [
        Builder(builder: (context) {
          return Container(
            height: _size.height * 0.45,
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox.square(
                  dimension: _size.width * 0.45,
                  child: CustomPaint(
                    painter: ClockPainterDial(),
                  ),
                ),
                SizedBox.square(
                  dimension: _size.width * 0.43,
                  child: CustomPaint(
                    painter: ClockMainPainter(current: _clck),
                  ),
                ),
              ],
            ),
          );
        }),
        Text(
          clocFormat(_clck),
          style: Theme.of(context)
              .textTheme
              .headline4!
              .copyWith(color: Colors.black),
        ),
        Text('Current:  ${_clck.day}/${_clck.month}/${_clck.year} '),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(_size.width * .8, 60),
              ),
              onPressed: () {
                Navigator.of(context).push(clockLocations());
              },
              child: const Text('Add City')),
        )
      ]),
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
