import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stopwatch/context/context.dart';
import 'package:stopwatch/utils/utils.dart' show clockFormat;

class StopWatchLapsCard extends StatefulWidget {
  final int lapNumber;
  final StopWatchTime time;
  const StopWatchLapsCard({
    Key? key,
    required this.lapNumber,
    required this.time,
  }) : super(key: key);

  @override
  State<StopWatchLapsCard> createState() => _StopWatchLapsCardState();
}

class _StopWatchLapsCardState extends State<StopWatchLapsCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final StopWatchContext _stopWatchContext =
        Provider.of<StopWatchContext>(context);
    return FadeTransition(
      opacity: _opacity,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // if you need this
          side: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 0.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              dense: true,
              title: Text('LAP ${widget.lapNumber + 1} ',
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                      fontWeight: FontWeight.w700, letterSpacing: 1.2)),
              trailing: IconButton(
                  onPressed: () async {
                    _animationController.reverse();
                    await Future.delayed(
                        _animationController.duration ?? const Duration());
                    _stopWatchContext.removeLap(widget.lapNumber);
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.black,
                  )),
            ),
            ListTile(
              title: Text(clockFormat(widget.time),
                  style: const TextStyle(
                      fontSize: 25,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Technology',
                      color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
