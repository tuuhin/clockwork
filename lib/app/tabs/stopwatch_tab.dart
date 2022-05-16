import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vector_math/vector_math.dart' show radians;

class StopwatchTab extends StatefulWidget {
  const StopwatchTab({
    Key? key,
  }) : super(key: key);

  @override
  State<StopwatchTab> createState() => _StopwatchTabState();
}

class _StopwatchTabState extends State<StopwatchTab> {
  late DateTime _currentTime;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
  }

  void _onTap([bool start = true]) {}

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            height: _size.height * .45,
            // color: Colors.red,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox.square(
                  dimension: _size.width * 0.65,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.white,
                            offset: Offset(-1, -1),
                            blurRadius: 20,
                            spreadRadius: 3),
                        BoxShadow(
                            color: Color.fromARGB(255, 220, 220, 220),
                            offset: Offset(1, 1),
                            blurRadius: 20,
                            spreadRadius: 3)
                      ],
                    ),
                    child: CustomPaint(
                      foregroundPainter: ClockPainer(),
                    ),
                  ),
                ),
                SizedBox.square(
                  dimension: _size.width * .6,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.white,
                              offset: Offset(-4, -4),
                              blurRadius: 20,
                              spreadRadius: 1),
                          BoxShadow(
                              color: Color.fromARGB(255, 202, 201, 201),
                              offset: Offset(4, 4),
                              blurRadius: 20,
                              spreadRadius: 1)
                        ]),
                  ),
                ),
                SizedBox.square(
                  dimension: _size.width * .48,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromARGB(255, 226, 225, 225),
                              offset: Offset(-1, -1),
                              blurRadius: 20,
                              spreadRadius: 3),
                        ]),
                  ),
                ),
                SizedBox.square(
                  dimension: _size.width * .35,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromARGB(255, 234, 232, 232),
                              offset: Offset(0, 0),
                              blurRadius: 20,
                              spreadRadius: 1),
                        ]),
                  ),
                ),
                Text(
                  '12.34.56',
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                      fontFamily: GoogleFonts.orbitron().fontFamily,
                      letterSpacing: 1.2,
                      color: Colors.black),
                ),

                // for animating balls
                SizedBox.square(
                  dimension: _size.width * 0.65,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                  ),
                )
              ],
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GridView.builder(
                itemCount: 20,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, i) {
                  return SizedBox.shrink(
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              'LAP ${i + 1}',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            trailing: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.delete)),
                          ),
                          ListTile(
                            title: Text(
                              '00.11.00',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          )),
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                        fixedSize: const Size(150, 60),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                    onPressed: _onTap,
                    child: Text(
                      'START',
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(color: Colors.white),
                    )),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                        fixedSize: const Size(150, 60),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                    onPressed: null,
                    child: Text('RESET',
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(fontWeight: FontWeight.bold))),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ClockPainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint _paint = Paint()
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..color = Colors.black;

    for (double i = 0; i <= 360; i += 5) {
      canvas.drawLine(
          Offset(size.width * .5, size.height * .5),
          Offset(size.width * .5 * (1 + cos(radians(i))),
              size.height * .5 * (1 - sin(radians(i)))),
          _paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
