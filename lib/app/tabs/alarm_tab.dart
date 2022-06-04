import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stopwatch/app/routes/add_alarms.dart';
import 'package:stopwatch/context/context.dart';
import 'package:stopwatch/service/notifications/notifications_service.dart';
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

  void onPressed() {
    NotificationService.showNotification(title: 'cat', body: 'none');
  }

  void addAlarm() => Navigator.of(context).push(alarmRoute());

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Scaffold(
        body: _alarmContext.alarms.isNotEmpty
            ? Column(
                children: [
                  const Text('alarms'),
                  ElevatedButton(onPressed: onPressed, child: Text('data')),
                ],
              )
            : SizedBox.expand(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox.square(
                        dimension: _size.width * .4, child: alarmImage),
                    const SizedBox(height: 20),
                    Text('No alarms',
                        style: Theme.of(context).textTheme.subtitle1)
                  ],
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

Route alarmRoute() => PageRouteBuilder(
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
            child: const AddAlarm(),
          ),
        );
      }),
    );
