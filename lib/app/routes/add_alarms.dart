import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:stopwatch/context/alarm_context.dart';

class AddAlarm extends StatefulWidget {
  const AddAlarm({Key? key}) : super(key: key);

  @override
  State<AddAlarm> createState() => _AddAlarmState();
}

class _AddAlarmState extends State<AddAlarm> {
  final TextEditingController _labelController = TextEditingController();
  bool _isVibrate = false;
  bool _isDelete = true;
  Repeat _repeat = Repeat.once;
  String _label = '';
  final DateTime _time = DateTime.now();

  void _onTimeChange(DateTime time) {
    time = _time;
  }

  void _addAlarmLabel() {
    Navigator.of(context).pop();
    setState(() {
      _label = _labelController.text;
      _labelController.text = '';
    });
  }

  void _showRepeatBottomSheet() => showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () => setState(() => _repeat = Repeat.once),
                  title: Text('Once',
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(fontWeight: FontWeight.w700)),
                ),
                ListTile(
                  onTap: () => setState(() => _repeat = Repeat.daily),
                  title: Text('Daily',
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(fontWeight: FontWeight.w700)),
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
                    Text('Add Alarm Label',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2!
                            .copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 10),
                    TextField(
                      keyboardType: TextInputType.name,
                      keyboardAppearance: Brightness.light,
                      controller: _labelController,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize: Size(_size.width, 50)),
                        onPressed: _addAlarmLabel,
                        child: const Text('Add'))
                  ],
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text('Add Alarm', style: Theme.of(context).textTheme.headline6),
            Text('current time',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                    ))
          ],
        ),
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close, size: 30)),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.done, size: 30)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Hour',
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(width: 40),
                Text(
                  'Minute',
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(fontWeight: FontWeight.w700),
                )
              ],
            ),
            TimePickerSpinner(
              time: _time,
              alignment: Alignment.center,
              is24HourMode: true,
              onTimeChange: _onTimeChange,
              normalTextStyle: Theme.of(context).textTheme.headline6,
              highlightedTextStyle: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 30),
              itemHeight: 80,
              isForce2Digits: true,
            ),
            const Spacer(),
            ListTile(
              onTap: _showRepeatBottomSheet,
              title: Text(
                'Repeat',
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(fontWeight: FontWeight.w700),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_repeat == Repeat.once ? 'Once' : 'Daily'),
                  const Icon(Icons.chevron_right)
                ],
              ),
            ),
            SwitchListTile(
                value: _isVibrate,
                onChanged: (t) => setState(() => _isVibrate = !_isVibrate),
                title: Text(
                  'Vibrate when alarm sounds',
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(fontWeight: FontWeight.w700),
                )),
            SwitchListTile(
                value: _isDelete,
                onChanged: (t) => setState(() => _isDelete = !_isDelete),
                title: Text(
                  'Delete after it goes off',
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(fontWeight: FontWeight.w700),
                )),
            ListTile(
              onTap: _showLabelBottonSheet,
              title: Text(
                'Label',
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(fontWeight: FontWeight.w700),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_label, style: Theme.of(context).textTheme.caption),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
