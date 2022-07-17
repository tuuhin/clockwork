import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../context/context.dart';
import 'lap_cards.dart';

class StopWatchLaps extends StatefulWidget {
  const StopWatchLaps({Key? key}) : super(key: key);

  @override
  State<StopWatchLaps> createState() => _StopWatchLapsState();
}

class _StopWatchLapsState extends State<StopWatchLaps> {
  late StopWatchContext _stopWatchContext;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      Future<dynamic> future = Future<dynamic>(() {});

      for (final Duration lap in _stopWatchContext.laps) {
        future = future.then(
          (dynamic value) => Future<dynamic>.delayed(
            const Duration(milliseconds: 90),
            () {
              _stopWatchContext.key.currentState!
                  .insertItem(_stopWatchContext.laps.indexOf(lap));
            },
          ),
        );
      }
    });
  }

  @override
  void didChangeDependencies() {
    _stopWatchContext = Provider.of<StopWatchContext>(context);
    super.didChangeDependencies();
  }

  final Tween<Offset> _offset =
      Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero);
  final Tween<double> _opacity = Tween<double>(begin: 0, end: 1);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: AnimatedList(
            key: _stopWatchContext.key,
            physics: const BouncingScrollPhysics(),
            itemBuilder:
                (BuildContext context, int index, Animation<double> animation) {
              return FadeTransition(
                opacity: animation.drive(_opacity),
                child: SlideTransition(
                  position: animation.drive(_offset),
                  child: StopWatchLapsCard(
                    lapNumber: index,
                    time: _stopWatchContext.laps[index],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
