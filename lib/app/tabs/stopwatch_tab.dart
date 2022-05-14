import 'package:flutter/material.dart';

class StopwatchTab extends StatelessWidget {
  const StopwatchTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            height: _size.height * 0.5,
            child: Stack(alignment: Alignment.center, children: [
              AnimatedContainer(
                width: _size.width * 0.6,
                duration: const Duration(milliseconds: 200),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.pinkAccent,
                          offset: Offset(0, 0),
                          blurRadius: 30,
                          spreadRadius: 5),
                      BoxShadow(
                          color: Colors.lightBlue,
                          offset: Offset(0, 0),
                          blurRadius: 30,
                          spreadRadius: 5)
                    ]),
              ),
              AnimatedContainer(
                height: _size.height * 0.6,
                width: _size.width * 0.6,
                duration: const Duration(milliseconds: 200),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.white,
                          offset: Offset(-1, -1),
                          blurRadius: 20,
                          spreadRadius: 3),
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(1, 1),
                          blurRadius: 20,
                          spreadRadius: 3)
                    ]),
              ),
            ]),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                        fixedSize: const Size(150, 60),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                    onPressed: () {},
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
                    onPressed: () {},
                    child: Text(
                      'RESET',
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(color: Colors.white),
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
