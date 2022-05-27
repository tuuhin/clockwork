import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stopwatch/app/app.dart';
import 'package:stopwatch/context/context.dart';
import 'package:stopwatch/utils/pallet.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  // SystemChrome.setSystemUIOverlayStyle(
  //     const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp(const ProviderWrappers());
}

class ProviderWrappers extends StatelessWidget {
  const ProviderWrappers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final StopWatchContext _stopWatchContext = StopWatchContext();
    final ClocksContext _clockContext = ClocksContext();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeContext>(
          create: (context) => ThemeContext(),
        ),
        ChangeNotifierProvider<StopWatchContext>(
            create: (context) => _stopWatchContext),
        StreamProvider<StopWatchTime>(
            create: (context) => _stopWatchContext.getStopWatch(),
            initialData: const Duration()),
        StreamProvider<ClockTime>(
            create: (context) => _clockContext.getWatch(),
            initialData: ClockTime.now()),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final ThemeContext _themeData = Provider.of<ThemeContext>(context);

    return MaterialApp(
        title: 'ClockWork',
        debugShowCheckedModeBanner: false,
        theme: _themeData.currentThemeIsDark
            ? Pallet.darkTheme
            : Pallet.lightTheme,
        home: const App());
  }
}
