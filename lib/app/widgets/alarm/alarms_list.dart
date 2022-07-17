import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../context/alarm_context.dart';
import '../../../domain/models/alarms_model.dart';
import 'alarm_card.dart';

class AlarmsList extends StatefulWidget {
  const AlarmsList({
    Key? key,
  }) : super(key: key);

  @override
  State<AlarmsList> createState() => _AlarmsListState();
}

class _AlarmsListState extends State<AlarmsList> {
  late AlarmContext _alarmContext;

  late List<AlarmsModel> _alarms;
  final Tween<Offset> _offset = Tween<Offset>(
    begin: const Offset(-1, 0),
    end: Offset.zero,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      Future<dynamic> future = Future<dynamic>(() {});

      for (final AlarmsModel alarm in _alarms) {
        future = future.then(
          (dynamic value) => Future<dynamic>.delayed(
            const Duration(milliseconds: 90),
            () {
              _alarmContext.listKey.currentState!
                  .insertItem(_alarms.indexOf(alarm));
            },
          ),
        );
      }
    });
  }

  @override
  void didChangeDependencies() {
    _alarmContext = Provider.of<AlarmContext>(context);
    _alarms = _alarmContext.alarms;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      padding: const EdgeInsets.all(8.0),
      key: _alarmContext.listKey,
      itemBuilder:
          (BuildContext context, int index, Animation<double> animation) {
        return SlideTransition(
          position: _offset.animate(
              CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
          child: AlarmCard(
            model: _alarms[index],
          ),
        );
      },
    );
  }
}
