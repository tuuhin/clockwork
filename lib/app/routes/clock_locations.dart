import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../context/context.dart';
import '../../domain/models/models.dart';

class ClockLocations extends StatefulWidget {
  const ClockLocations({Key? key}) : super(key: key);

  @override
  State<ClockLocations> createState() => _ClockLocationsState();
}

class _ClockLocationsState extends State<ClockLocations> {
  late TextEditingController _controller;
  late ScrollController _scrollController;
  late TimeZoneContext _timeZoneContext;

  String filter = '';
  bool _atBottom = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _scrollController = ScrollController();
  }

  @override
  void didChangeDependencies() {
    _timeZoneContext = Provider.of<TimeZoneContext>(context);

    _scrollController.addListener(() {
      if (_scrollController.offset >=
          _scrollController.position.maxScrollExtent) {
        setState(() => _atBottom = true);
      }
      if (_scrollController.offset <=
          _scrollController.position.minScrollExtent) {
        setState(() => _atBottom = false);
      }
    });

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> selectCity(TimeZoneModel zone) async {
    FocusScope.of(context).requestFocus(FocusNode());
    Navigator.of(context)
      ..pop()
      ..pop();
    await _timeZoneContext.getZoneDetails(zone);
  }

  void removeModels() {
    FocusScope.of(context).requestFocus(FocusNode());
    Navigator.of(context)
      ..pop()
      ..pop();
    _timeZoneContext.removeDetailedModels();
  }

  void loadInfoDialog(TimeZoneModel? zoneModel) => showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.symmetric(horizontal: 15),
          title: ListTile(
            contentPadding: EdgeInsets.zero,
            subtitle: Text(zoneModel!.area),
            title: zoneModel.region == null
                ? Text(zoneModel.location)
                : Text(zoneModel.region ?? ''),
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('CANCEL')),
            ElevatedButton(
                onPressed:
                    !_timeZoneContext.checkIfDetailModelSelected(zoneModel)
                        ? () => selectCity(zoneModel)
                        : null,
                child: Text(
                  'SELECT THIS CITY',
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      fontWeight: FontWeight.w600, color: Colors.white),
                ))
          ],
        );
      });

  void removeAllDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Clear all the selected cities'),
            content: Text(
              'Remove all the selected cities ,the old selected cities are need to be selected again to view',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('CANCEL')),
              ElevatedButton(
                  onPressed: _timeZoneContext.getAllDetailedModels().isNotEmpty
                      ? removeModels
                      : null,
                  child: Text('Remove',
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                          fontWeight: FontWeight.w600, color: Colors.white)))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final List<TimeZoneModel?> zones =
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
            children: <Widget>[
              Text('Select City', style: Theme.of(context).textTheme.headline5),
              Text('Time zones',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                      ))
            ],
          ),
          actions: <Widget>[
            IconButton(
                onPressed: removeAllDialog,
                icon: const Icon(Icons.delete_outlined))
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(40),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                cursorColor: Colors.black,
                onChanged: (String value) => setState(() => filter = value),
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
          child: zones.isNotEmpty
              ? ListView(
                  controller: _scrollController,
                  children: <Widget>[
                    ...zones
                        .where((TimeZoneModel? element) => element!.region ==
                                null
                            ? element.location.toLowerCase().contains(filter)
                            : element.region!.contains(filter))
                        .map((TimeZoneModel? zone) => ListTile(
                              onTap: () => loadInfoDialog(zone),
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
            onPressed: () {
              _scrollController.animateTo(
                  !_atBottom
                      ? _scrollController.position.maxScrollExtent
                      : _scrollController.position.minScrollExtent,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.decelerate);
            },
            child: Icon(!_atBottom
                ? Icons.keyboard_arrow_down
                : Icons.keyboard_arrow_up)),
      ),
    );
  }
}
