import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stopwatch/app/routes/routes.dart';
import 'package:stopwatch/app/widgets/alarm/alarms_list.dart';
import 'package:stopwatch/context/context.dart';
import 'package:stopwatch/utils/utils.dart';

class AlarmTab extends StatefulWidget {
  const AlarmTab({Key? key}) : super(key: key);

  @override
  State<AlarmTab> createState() => _AlarmTabState();
}

class _AlarmTabState extends State<AlarmTab> {
  late AlarmContext _alarmContext;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _alarmContext = Provider.of<AlarmContext>(context);
  }

  void addAlarm() async => await Navigator.of(context).push(alarmRoute());

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;

    return Scaffold(
        body: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          child: _alarmContext.alarms.isNotEmpty
              ? const AlarmsList()
              : SizedBox.expand(
                  child: TweenAnimationBuilder(
                    duration: const Duration(milliseconds: 400),
                    tween: Tween<double>(begin: 0, end: 1),
                    builder: (context, double animation, child) {
                      return AnimatedOpacity(
                        opacity: animation,
                        duration: const Duration(milliseconds: 400),
                        child: child,
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox.square(
                            dimension: _size.width * .4, child: alarmImage),
                        const SizedBox(height: 20),
                        Text('No alarms'.toUpperCase(),
                            style: Theme.of(context).textTheme.subtitle1)
                      ],
                    ),
                  ),
                ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: SizedBox(
            height: 64,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                onPressed: addAlarm,
                icon: const Icon(Icons.add),
                label: const Text('New Alarm'),
              ),
            ),
          ),
        ));
  }
}

Route alarmRoute() {
  final Tween<Offset> _offset =
      Tween<Offset>(begin: const Offset(1, 0), end: const Offset(0, 0));
  final Tween<double> _opacity = Tween<double>(begin: 0.0, end: 1.0);
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 500),
    reverseTransitionDuration: const Duration(milliseconds: 500),
    pageBuilder: (context, animation, secondaryAnimation) {
      return FadeTransition(
        opacity: animation.drive(_opacity),
        child: SlideTransition(
          position: animation.drive(_offset),
          child: const AddAlarm(),
        ),
      );
    },
  );
}
