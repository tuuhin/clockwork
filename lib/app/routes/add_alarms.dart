import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:lit_relative_date_time/lit_relative_date_time.dart';
import 'package:provider/provider.dart';

import '../../context/alarm_context.dart';
import '../../domain/enums/repeat_enum.dart';
import '../../domain/models/models.dart';
import '../widgets/app_widgets.dart';

class AddAlarm extends StatefulWidget {
  const AddAlarm({Key? key}) : super(key: key);

  @override
  State<AddAlarm> createState() => _AddAlarmState();
}

class _AddAlarmState extends State<AddAlarm> {
  late AlarmContext _alarmContext;
  late TextEditingController _labelController;

  bool _isVibrate = false;
  bool _isDelete = true;
  RepeatEnum _repeat = RepeatEnum.once;

  DateTime at = DateTime.now().add(const Duration(minutes: 1));

  String _relative = 'now';

  void _onTimeChange(DateTime time) {
    at = time.subtract(Duration(seconds: time.second, days: 5));

    setState(() => _relative =
        RelativeDateFormat(Localizations.localeOf(context))
            .format(RelativeDateTime(dateTime: DateTime.now(), other: time)));
  }

  void _addAlarm() {
    if (DateTime.now().hour > at.hour) {
      at = at.add(const Duration(days: 1));
    } else if (DateTime.now().hour == at.hour &&
        DateTime.now().minute >= at.minute) {
      at = at.add(const Duration(days: 1));
    }
    final AlarmsModel alarm = AlarmsModel(
      at: at,
      repeat: _repeat,
      vibrate: _isVibrate,
      label: _labelController.text.isNotEmpty ? _labelController.text : null,
      deleteAfterDone: _isDelete,
    );
    final bool itExists = _alarmContext.isAlarmAlreadyExists(alarm);

    if (!itExists) {
      _alarmContext.addAlarms(alarm);
      return Navigator.of(context).pop();
    }
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Failed to create an alarm'),
        content: const Text(
            'There is a alarm already assigned to this  particular time'),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () => Navigator.of(context)
              ..pop()
              ..pop(),
            child: const Text('OK I got it !'),
          )
        ],
      ),
    );
  }

  void selectRepeatMode(RepeatEnum value) {
    setState(() => _repeat = value);
    if (_repeat == RepeatEnum.daily) {
      _isDelete = false;
    }
    Navigator.of(context).pop();
  }

  void _showRepeatBottomSheet() => showModalBottomSheet(
        context: context,
        builder: (BuildContext context) => RepeatModePicker(
          onDaily: () => selectRepeatMode(RepeatEnum.daily),
          onOnce: () => selectRepeatMode(RepeatEnum.once),
        ),
      );

  void _showLabelBottonSheet() => showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) =>
          LabelPicker(labelController: _labelController));

  @override
  void initState() {
    _labelController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _alarmContext = Provider.of<AlarmContext>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: <Widget>[
            Text('Add Alarm',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(fontWeight: FontWeight.bold)),
            Text(_relative)
          ],
        ),
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close, size: 30)),
        actions: <Widget>[
          IconButton(
              onPressed: _addAlarm, icon: const Icon(Icons.done, size: 30)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Hour',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(fontWeight: FontWeight.w600, wordSpacing: 1.2),
                ),
                const SizedBox(width: 40),
                Text(
                  'Minute',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(fontWeight: FontWeight.w600, wordSpacing: 1.2),
                )
              ],
            ),
            TimePickerSpinner(
              time: at,
              alignment: Alignment.center,
              onTimeChange: _onTimeChange,
              normalTextStyle: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: Colors.black54),
              highlightedTextStyle: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 30),
              itemHeight: 80,
              isForce2Digits: true,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    onTap: _showRepeatBottomSheet,
                    title: Text(
                      'Repeat',
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          fontWeight: FontWeight.w600, wordSpacing: 1.2),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(_repeat == RepeatEnum.once ? 'Once' : 'Daily'),
                        const Icon(Icons.chevron_right)
                      ],
                    ),
                  ),
                  SwitchListTile(
                      value: _isVibrate,
                      onChanged: (bool t) =>
                          setState(() => _isVibrate = !_isVibrate),
                      title: Text(
                        'Vibrate when alarm sounds',
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            fontWeight: FontWeight.w600, wordSpacing: 1.2),
                      )),
                  if (_repeat == RepeatEnum.once)
                    SwitchListTile(
                        value: _isDelete,
                        onChanged: (bool t) =>
                            setState(() => _isDelete = !_isDelete),
                        title: Text(
                          'Delete after it goes off',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(
                                  fontWeight: FontWeight.w600,
                                  wordSpacing: 1.2),
                        )),
                  ListTile(
                    onTap: _showLabelBottonSheet,
                    title: Text(
                      'Label',
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          fontWeight: FontWeight.w600, wordSpacing: 1.2),
                    ),
                    trailing: _labelController.text.isEmpty
                        ? const Icon(Icons.chevron_right)
                        : Text(_labelController.text,
                            style: Theme.of(context).textTheme.caption),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30)
          ],
        ),
      ),
    );
  }
}
