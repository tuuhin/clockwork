import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stopwatch/app/app.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: GoogleFonts.sourceSansProTextTheme()),
      home: const App());
}
