import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stopwatch/models/models.dart';

class ClockLocations extends StatefulWidget {
  const ClockLocations({Key? key}) : super(key: key);

  @override
  State<ClockLocations> createState() => _ClockLocationsState();
}

class _ClockLocationsState extends State<ClockLocations> {
  final TextEditingController _controller = TextEditingController(text: '');
  late ScrollController _scrollController;

  String filter = '';

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    final List<TimeZoneModel?>? _zones =
        Provider.of<List<TimeZoneModel?>?>(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64.0,
        title: Column(
          children: [
            Text('Select City', style: Theme.of(context).textTheme.headline5),
            Text('Time zones',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                    ))
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              onChanged: ((value) => setState(() => filter = value)),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search for a country or city',
              ),
              controller: _controller,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          controller: _scrollController,
          children: [
            ..._zones!
                .where((element) => element!.region == null
                    ? element.location.toLowerCase().contains(filter)
                    : element.region!.contains(filter))
                .map((TimeZoneModel? model) => ListTile(
                      subtitle: Text(model!.area),
                      title: model.region == null
                          ? Text(model.location)
                          : Text(model.region ?? ''),
                    ))
          ],
        ),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.black,
          child: const Icon(Icons.keyboard_arrow_down)),
    );
  }
}
