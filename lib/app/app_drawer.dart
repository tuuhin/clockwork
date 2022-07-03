import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:stopwatch/context/context.dart';
import 'package:stopwatch/utils/images.dart';

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

  void _showDialog(String text, [String? desc]) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(text),
        content: desc != null ? Text(desc) : null,
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Text('Ok'),
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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder(
            future: PackageInfo.fromPlatform(),
            builder: (context, AsyncSnapshot<PackageInfo> snapshot) {
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
