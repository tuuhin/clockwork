import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'app/app.dart';
import 'context/context.dart';
import 'data/data.dart';
import 'domain/models/models.dart';
import 'service/services.dart';
import 'utils/pallet.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.init();
  await AlarmService.init();
  NotificationService.init();

  SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  // SystemChrome.setSystemUIOverlayStyle(
  //     const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp(const ProviderWrappers());
}

class ProviderWrappers extends StatelessWidget {
  const ProviderWrappers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final StopWatchContext stopWatchContext = StopWatchContext();
    final ClocksContext clockContext = ClocksContext();
    final TimeZoneContext timezoneContext = TimeZoneContext();
    final AlarmContext alarmContext = AlarmContext();
    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<StopWatchContext>(
          create: (BuildContext context) => stopWatchContext,
        ),
        StreamProvider<CurrentStopWatchTime>(
          create: (BuildContext context) => stopWatchContext.getStopWatch,
          initialData: Duration.zero,
        ),
        StreamProvider<ClockTime>(
          create: (BuildContext context) => clockContext.getWatch,
          initialData: ClockTime.now(),
        ),
        FutureProvider<List<TimeZoneModel?>>(
          create: (BuildContext context) => timezoneContext.zones,
          initialData: const <TimeZoneModel?>[],
        ),
        ChangeNotifierProvider<TimeZoneContext>(
          create: (BuildContext context) => timezoneContext,
        ),
        ChangeNotifierProvider<AlarmContext>(
          create: (BuildContext context) => alarmContext,
        )
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'ClockWork',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        home: const App());
  }
}
