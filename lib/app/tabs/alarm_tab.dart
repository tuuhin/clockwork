import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../context/context.dart';
import '../../utils/utils.dart';
import '../routes/routes.dart';
import '../widgets/alarm/alarms_list.dart';

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

  Future<void> addAlarm() async => Navigator.of(context).push(alarmRoute());

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          child: _alarmContext.alarms.isNotEmpty
              ? const AlarmsList()
              : SizedBox.expand(
                  child: TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 400),
                    tween: Tween<double>(begin: 0, end: 1),
                    builder: (BuildContext context, double animation,
                        Widget? child) {
                      return AnimatedOpacity(
                        opacity: animation,
                        duration: const Duration(milliseconds: 400),
                        child: child,
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox.square(
                            dimension: size.width * .4, child: alarmImage),
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

Route<dynamic> alarmRoute() {
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
          child: const AddAlarm(),
        ),
      );
    },
  );
}
