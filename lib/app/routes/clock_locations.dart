import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stopwatch/context/context.dart';
import 'package:stopwatch/domain/models/models.dart';

class ClockLocations extends StatefulWidget {
  const ClockLocations({Key? key}) : super(key: key);

  @override
  State<ClockLocations> createState() => _ClockLocationsState();
}

class _ClockLocationsState extends State<ClockLocations> {
  final TextEditingController _controller = TextEditingController(text: '');
  late ScrollController _scrollController;
  late TimeZoneContext _timeZoneContext;

  String filter = '';

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {});
  }

  @override
  void didChangeDependencies() {
    _timeZoneContext = Provider.of<TimeZoneContext>(context);

    super.didChangeDependencies();
  }

  void selectCity(TimeZoneModel zone) async {
    await _timeZoneContext.getZoneDetails(zone);
    Navigator.of(context)
      ..pop()
      ..pop();
  }

  void loadInfo(TimeZoneModel? zoneModel) => showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.symmetric(horizontal: 15),
          title: ListTile(
            contentPadding: EdgeInsets.zero,
            subtitle: Text(zoneModel!.area),
            title: zoneModel.region == null
                ? Text(zoneModel.location)
                : Text(zoneModel.region ?? ''),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('CANCEL')),
            ElevatedButton(
                onPressed: () => selectCity(zoneModel),
                child: Text(
                  'SELECT THIS CITY',
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      fontWeight: FontWeight.w600, color: Colors.white),
                ))
          ],
        );
      });

  @override
  Widget build(BuildContext context) {
    final List<TimeZoneModel?> _zones =
        Provider.of<List<TimeZoneModel?>>(context);

    return WillPopScope(
      onWillPop: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        return true;
      },
      child: Scaffold(
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
                cursorColor: Colors.black,
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
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: _zones.isNotEmpty
              ? ListView(
                  controller: _scrollController,
                  children: [
                    ..._zones
                        .where((element) => element!.region == null
                            ? element.location.toLowerCase().contains(filter)
                            : element.region!.contains(filter))
                        .map((TimeZoneModel? zone) => ListTile(
                              onTap: () => loadInfo(zone),
                              subtitle: Text(zone!.area),
                              title: zone.region == null
                                  ? Text(zone.location)
                                  : Text(zone.region ?? ''),
                            ))
                  ],
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ),
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.keyboard_arrow_down),
        ),
      ),
    );
  }
}
