import 'package:flutter/material.dart';
import 'package:stopwatch/app/widgets/stopwatch/lap_cards.dart';

class StopWatchLaps extends StatefulWidget {
  const StopWatchLaps({Key? key}) : super(key: key);

  @override
  State<StopWatchLaps> createState() => _StopWatchLapsState();
}

class _StopWatchLapsState extends State<StopWatchLaps> {
  late ScrollController _scrollController;
  double _scrollPostion = 0.0;

  double _opacity = 0.0;

  _scrollListener() {
    setState(() {
      _scrollPostion = _scrollController.position.pixels;
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(initialScrollOffset: _scrollPostion);
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    _opacity = _scrollPostion < (_size.height * .1)
        ? _scrollPostion / (_size.height * .3)
        : 1;
    print(_opacity);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: GridView.builder(
              itemCount: 20,
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1.5, crossAxisCount: 2),
              itemBuilder: (context, i) {
                return AnimatedOpacity(
                    duration: const Duration(milliseconds: 400),
                    opacity: _opacity,
                    child: StopWatchLapsCard(lapNumber: i));
              }),
        ),
      ),
    );
  }
}
