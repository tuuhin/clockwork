import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stopwatch/app/app.dart';
import 'package:stopwatch/context/theme_context.dart';
import 'package:stopwatch/utils/pallet.dart';

void main() => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeContext>(
            create: (context) => ThemeContext(),
          )
        ],
        child: const MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final ThemeContext _themeData = Provider.of<ThemeContext>(context);

    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: _themeData.currentThemeIsDark
            ? Pallet.darkTheme
            : Pallet.lightTheme,
        home: const App());
  }
}
