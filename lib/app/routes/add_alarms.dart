import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:provider/provider.dart';
import 'package:stopwatch/context/alarm_context.dart';
import 'package:stopwatch/domain/enums/repeat_enum.dart';
import 'package:stopwatch/domain/models/models.dart';

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

  void _onTimeChange(DateTime time) {
    at = time.subtract(Duration(seconds: time.second));
  }

  void _addAlarm() {
    print(_isDelete);
    _alarmContext.addAlarms(
      AlarmsModel(
        at: at,
        repeat: _repeat,
        vibrate: _isVibrate,
        label: _labelController.text.isNotEmpty ? _labelController.text : null,
        deleteAfterDone: _isDelete,
      ),
    );
    Navigator.of(context).pop();
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
      builder: (context) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () => selectRepeatMode(RepeatEnum.once),
                  title: Text('Once',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(fontWeight: FontWeight.w600)),
                ),
                ListTile(
                  onTap: () => selectRepeatMode(RepeatEnum.daily),
                  title: Text('Daily',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ));

  void _showLabelBottonSheet() {
    final Size _size = MediaQuery.of(context).size;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Label',
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          fontWeight: FontWeight.w600, wordSpacing: 1.2),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.name,
                      keyboardAppearance: Brightness.light,
                      controller: _labelController,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize: Size(_size.width, 50)),
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Add'))
                  ],
                ),
              ),
            ));
  }

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
        title: Text('Add Alarm',
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(fontWeight: FontWeight.bold)),
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close, size: 30)),
        actions: [
          IconButton(
              onPressed: _addAlarm, icon: const Icon(Icons.done, size: 30)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
              is24HourMode: true,
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
                children: [
                  ListTile(
                    onTap: _showRepeatBottomSheet,
                    title: Text(
                      'Repeat',
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          fontWeight: FontWeight.w600, wordSpacing: 1.2),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_repeat == RepeatEnum.once ? 'Once' : 'Daily'),
                        const Icon(Icons.chevron_right)
                      ],
                    ),
                  ),
                  SwitchListTile(
                      value: _isVibrate,
                      onChanged: (t) =>
                          setState(() => _isVibrate = !_isVibrate),
                      title: Text(
                        'Vibrate when alarm sounds',
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            fontWeight: FontWeight.w600, wordSpacing: 1.2),
                      )),
                  if (_repeat == RepeatEnum.once)
                    SwitchListTile(
                        value: _isDelete,
                        onChanged: (t) =>
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
