import 'package:flutter/material.dart';
import 'package:lit_relative_date_time/lit_relative_date_time.dart';
import 'package:provider/provider.dart';
import '../../../context/context.dart';
import '../../../domain/enums/enums.dart';
import '../../../domain/models/models.dart';
import '../../../utils/time_formatter.dart';

class AlarmCard extends StatefulWidget {
  const AlarmCard({
    Key? key,
    required this.model,
  }) : super(key: key);
  final AlarmsModel model;

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
      confirmDismiss: (DismissDirection direction) async => true,
      onDismissed: (DismissDirection direction) =>
          _alarmContext.removeAlarm(widget.model),
      background: Card(
        color: Colors.black,
        child: Row(
          children: const <Widget>[
            SizedBox(width: 20),
            Icon(Icons.delete_outline, color: Colors.white),
          ],
        ),
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text.rich(TextSpan(
                text: alarmFormat(widget.model.at),
                style: Theme.of(context)
                    .textTheme
                    .headline5!
                    .copyWith(fontWeight: FontWeight.w600),
                children: widget.model.label != null
                    ? <InlineSpan>[
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
                    : <InlineSpan>[])),
            subtitle: !widget.model.isActive
                ? Text(
                    widget.model.repeat == RepeatEnum.daily ? 'Daily' : 'Once',
                  )
                : AnimatedRelativeDateTimeBuilder(
                    date: widget.model.at,
                    builder: (RelativeDateTime time, String str) {
                      return Text(str);
                    }),
            trailing: Switch(
                value: widget.model.isActive,
                onChanged: (bool ch) {
                  _alarmContext.changeAlarmMode(widget.model, ch);
                }),
          ),
        ),
      ),
    );
  }
}
