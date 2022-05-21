import 'package:flutter/material.dart';

class StopWatchLapsCard extends StatelessWidget {
  final int lapNumber;
  const StopWatchLapsCard({
    Key? key,
    required this.lapNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // if you need this
        side: BorderSide(
          color: Colors.grey.withOpacity(0.2),
          width: 0.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListTile(
            dense: true,
            title: Text('LAP ${lapNumber + 1} ',
                style: Theme.of(context)
                    .textTheme
                    .headline5!
                    .copyWith(fontWeight: FontWeight.w700, letterSpacing: 1.2)),
            trailing: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.delete,
                  color: Colors.black,
                )),
          ),
          const ListTile(
            title: Text('00.11.00',
                style: TextStyle(
                    fontSize: 25,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Technology',
                    color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
