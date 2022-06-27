import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:stopwatch/app/widgets/alarm/alarm_card.dart';
import 'package:stopwatch/context/alarm_context.dart';
import 'package:stopwatch/domain/models/alarms_model.dart';

class AlarmsList extends StatefulWidget {
  const AlarmsList({
    Key? key,
  }) : super(key: key);

  @override
  State<AlarmsList> createState() => _AlarmsListState();
}

class _AlarmsListState extends State<AlarmsList> {
  late AlarmContext _alarmContext;
  final Tween<Offset> _offset = Tween<Offset>(
    begin: const Offset(-1, 0),
    end: const Offset(0, 0),
  );

  late List<AlarmsModel> _alarms;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future future = Future(() {});

      for (AlarmsModel alarm in _alarms) {
        future = future.then(
            (value) => Future.delayed(const Duration(milliseconds: 90), () {
                  _alarmContext.listKey.currentState!
                      .insertItem(_alarms.indexOf(alarm));
                }));
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
        itemBuilder: (context, index, animation) {
          return SlideTransition(
            position: animation.drive(_offset),
            child: AlarmCard(
              index: index,
              model: _alarms[index],
            ),
          );
        });
  }
}
