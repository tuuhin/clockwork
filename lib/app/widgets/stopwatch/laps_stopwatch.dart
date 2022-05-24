import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stopwatch/app/widgets/stopwatch/lap_cards.dart';
import 'package:stopwatch/context/context.dart';

class StopWatchLaps extends StatefulWidget {
  const StopWatchLaps({Key? key}) : super(key: key);

  @override
  State<StopWatchLaps> createState() => _StopWatchLapsState();
}

class _StopWatchLapsState extends State<StopWatchLaps> {
  @override
  Widget build(BuildContext context) {
    final StopWatchContext stopWatchContext =
        Provider.of<StopWatchContext>(context);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: GridView.builder(
              itemCount: stopWatchContext.laps.length,
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1.5, crossAxisCount: 2),
              itemBuilder: (context, i) {
                return StopWatchLapsCard(
                  lapNumber: i,
                  time: stopWatchContext.laps[i],
                );
              }),
        ),
      ),
    );
  }
}
