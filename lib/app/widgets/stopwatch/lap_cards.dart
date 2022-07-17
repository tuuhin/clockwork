import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../context/context.dart';
import '../../../utils/time_formatter.dart';
import '../../../utils/utils.dart';

class StopWatchLapsCard extends StatefulWidget {
  const StopWatchLapsCard({
    Key? key,
    required this.lapNumber,
    required this.time,
  }) : super(key: key);
  final int lapNumber;
  final Duration time;

  @override
  State<StopWatchLapsCard> createState() => _StopWatchLapsCardState();
}

class _StopWatchLapsCardState extends State<StopWatchLapsCard> {
  late StopWatchContext _context;
  @override
  void didChangeDependencies() {
    _context = Provider.of<StopWatchContext>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('LAP ${widget.lapNumber + 1} ',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w600, letterSpacing: 1.2)),
                const SizedBox(height: 10),
                Text(stopWatchFormat(widget.time),
                    style: Theme.of(context).textTheme.headline6),
              ],
            ),
            IconButton(
                onPressed: () => _context.removeLap(widget.lapNumber),
                icon: const Icon(Icons.delete_forever_outlined))
          ],
        ),
      ),
    );
  }
}
