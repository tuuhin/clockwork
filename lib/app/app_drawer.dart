import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../context/context.dart';
import '../utils/images.dart';
import 'tabs/alarm_tab.dart';
import 'tabs/clocks_tab.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  late AlarmContext _alarmContext;
  late TimeZoneContext _timeZoneContext;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _alarmContext = Provider.of<AlarmContext>(context);
    _timeZoneContext = Provider.of<TimeZoneContext>(context);
  }

  Future<void> _showDialog(String text) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(text, style: Theme.of(context).textTheme.subtitle1),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Ok'),
          )
        ],
      ),
    );
  }

  void removeAlarms() {
    _alarmContext.removeAllAlarms();
    _showDialog('Alarms are deleted');
  }

  void clearSelectedZones() {
    _timeZoneContext.removeDetailedModels();
    _showDialog('All the selected cities are removed');
  }

  void _addAlarm() => Navigator.of(context)
    ..pop()
    ..push(alarmRoute());

  void _addCity() => Navigator.of(context)
    ..pop()
    ..push(clockLocations());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder:
                (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
              if (snapshot.hasData) {
                return ListTile(
                  dense: true,
                  leading: SizedBox(width: 40, child: appIcon),
                  subtitle: Text('Version ${snapshot.data!.version}'),
                  title: Text(snapshot.data!.appName,
                      style: Theme.of(context).textTheme.subtitle1),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
          const Divider(),
          ListTile(
            onTap: _addAlarm,
            leading: const Icon(Icons.alarm_add),
            title: const Text('Add a alarm'),
            subtitle: const Text('Creates a alarm at a given time'),
          ),
          ListTile(
            onTap: _addCity,
            leading: const Icon(Icons.location_city),
            title: const Text('Add a city '),
            subtitle:
                const Text('Add a city from the locations to the clock tab'),
          ),
          ListTile(
            onTap: removeAlarms,
            leading: const Icon(Icons.delete_outlined),
            subtitle: const Text('Removes all the alarms that are assigned.'),
            title: const Text('Remove all alarms'),
          ),
          ListTile(
            onTap: clearSelectedZones,
            leading: const Icon(Icons.clear_outlined),
            subtitle: const Text(
                'Removes all the selcted cites which are clock tab.'),
            title: const Text('Clear all the prefered citires'),
          ),
        ],
      ),
    );
  }
}
