import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:stopwatch/app/routes/clock_locations.dart';
import 'package:stopwatch/app/widgets/clock/analog_clock.dart';
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
        const AnalogClock(),
        Text(
          clocFormat(_clck),
          style: Theme.of(context).textTheme.headline4!.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
              fontFamily: GoogleFonts.openSans().fontFamily),
        ),
        Text('Current:  ${_clck.day}/${_clck.month}/${_clck.year} '),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(_size.width * .9, 50),
              ),
              onPressed: () => Navigator.of(context).push(clockLocations()),
              child: Text('Add City',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.white))),
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
