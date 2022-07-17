import 'package:flutter/material.dart';
import '../app/widgets/app_widgets.dart';
import '../data/api/worldtimeapi_client.dart';
import '../data/local/time_zone_data.dart';
import '../domain/models/models.dart';

class TimeZoneContext extends ChangeNotifier {
  final WorldTimeApiClient _clt = WorldTimeApiClient();
  final TimeZoneData _data = TimeZoneData();
  final Tween<Offset> _offset = Tween<Offset>(
    begin: const Offset(-1, 0),
    end: Offset.zero,
  );
  final GlobalKey<AnimatedListState> _globalKey =
      GlobalKey<AnimatedListState>();

  GlobalKey<AnimatedListState> get zonesListKey => _globalKey;

  Future<List<TimeZoneModel?>> get zones async {
    final List<TimeZoneModel?> timeZones = _data.getAllZones();
    if (timeZones.isEmpty) {
      final List<TimeZoneModel> zones = await _clt.getZones();
      if (zones.isNotEmpty) {
        // ignore: prefer_foreach
        for (final TimeZoneModel element in zones) {
          _data.addZone(element);
        }
        return _data.getAllZones();
      }
    }
    return timeZones;
  }

  List<DetailedTimeZoneModel> getAllDetailedModels() =>
      _data.getAllDetailedZones();

  bool checkIfDetailModelSelected(TimeZoneModel zone) =>
      _data.checkIfDetailedModelExists(zone);

  Future<void> getZoneDetails(TimeZoneModel zone) async {
    final bool exits = _data.checkIfDetailedModelExists(zone);
    if (!exits) {
      final Map<String, dynamic>? details = await _clt.getTimeZoneInfo(zone);
      if (details != null) {
        final int rawOffset = details['raw_offset'] as int;

        _data.addDetailedZone(DetailedTimeZoneModel(
            location:
                zone.region != null ? zone.region.toString() : zone.location,
            area: zone.area,
            offset: rawOffset));
      }
      // Adding new member to the animated list

      notifyListeners();

      _globalKey.currentState!.insertItem(0);
    }
  }

  void removeIndividualModel(DetailedTimeZoneModel zone) {
    final int index = _data.getIndex(zone);
    if (_globalKey.currentState != null) {
      _globalKey.currentState!.removeItem(
          index,
          (BuildContext context, Animation<double> animation) =>
              const SizedBox());
    }
    _data.removeIndividualModel(zone);
    notifyListeners();
  }

  void removeDetailedModels() {
    final List<DetailedTimeZoneModel> allDetailModels = getAllDetailedModels();

    Future<dynamic> future = Future<dynamic>(() {});
    for (final DetailedTimeZoneModel entry in allDetailModels) {
      future = future.then(
          (_) => Future<dynamic>.delayed(const Duration(milliseconds: 50), () {
                _globalKey.currentState!.removeItem(
                  0,
                  (BuildContext context, Animation<double> animation) {
                    return SlideTransition(
                      position: animation.drive(_offset),
                      child: ClockCard(zone: entry),
                    );
                  },
                );
              }));
    }
    _data.clearDetailedModels();

    notifyListeners();
  }
}
