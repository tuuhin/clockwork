import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stopwatch/context/context.dart';
import 'package:stopwatch/domain/enums/enums.dart';
import 'package:stopwatch/domain/models/models.dart';
import 'package:stopwatch/utils/time_formatter.dart';

class AlarmCard extends StatefulWidget {
  final int index;
  final AlarmsModel model;
  const AlarmCard({
    Key? key,
    required this.index,
    required this.model,
  }) : super(key: key);

  @override
  State<AlarmCard> createState() => _AlarmCardState();
}

class _AlarmCardState extends State<AlarmCard> {
  late AlarmContext _alarmContext;

  @override
  void didChangeDependencies() {
    _alarmContext = Provider.of<AlarmContext>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ObjectKey(widget.model),
      direction: DismissDirection.startToEnd,
      confirmDismiss: (direction) async {
        return true;
      },
      onDismissed: (direction) => _alarmContext.removeAlarm(widget.model),
      background: Card(
          color: Colors.black,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              SizedBox(width: 20),
              Icon(Icons.delete_outline, color: Colors.white),
            ],
          )),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Alarm ${widget.index + 1}'.toUpperCase(),
                style: const TextStyle(
                    color: Colors.black26,
                    wordSpacing: 1.5,
                    fontWeight: FontWeight.w600),
              ),
              ListTile(
                onLongPress: () {
                  print('long press');
                },
                title: Text.rich(TextSpan(
                    text: alarmFormat(widget.model.at),
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(fontWeight: FontWeight.w600),
                    children: widget.model.label != null
                        ? [
                            TextSpan(
                              text: '|',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5!
                                  .copyWith(fontWeight: FontWeight.w400),
                            ),
                            TextSpan(
                              text: widget.model.label,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(fontWeight: FontWeight.w400),
                            )
                          ]
                        : [])),
                subtitle: Text(
                  widget.model.repeat == RepeatEnum.daily ? 'Daily' : 'Once',
                ),
                trailing: Switch(value: true, onChanged: (bool ch) {}),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
