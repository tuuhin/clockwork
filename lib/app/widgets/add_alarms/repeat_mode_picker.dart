import 'package:flutter/material.dart';

class RepeatModePicker extends StatelessWidget {
  const RepeatModePicker({Key? key, this.onDaily, this.onOnce})
      : super(key: key);
  final void Function()? onOnce;
  final void Function()? onDaily;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              onTap: onOnce,
              title: Text('Once',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(fontWeight: FontWeight.w600)),
            ),
            ListTile(
              onTap: onDaily,
              title: Text('Daily',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      );
}
