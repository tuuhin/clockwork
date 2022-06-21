import 'package:flutter/material.dart';
import 'package:stopwatch/app/widgets/app_widgets.dart';
import 'package:stopwatch/data/api/worldtimeapi_client.dart';
import 'package:stopwatch/data/local/time_zone_data.dart';
import 'package:stopwatch/domain/models/models.dart';

class TimeZoneContext extends ChangeNotifier {
  static final WorldTimeApiClient _clt = WorldTimeApiClient();
  static final TimeZoneData _data = TimeZoneData();
  final GlobalKey<AnimatedListState> _globalKey =
      GlobalKey<AnimatedListState>();

  GlobalKey<AnimatedListState> get zonesListKey => _globalKey;

  Future<List<TimeZoneModel?>> get zones async {
    List<TimeZoneModel?> _timeZones = _data.getAllZones();
    if (_timeZones.isEmpty) {
      List<TimeZoneModel> _zones = await _clt.getZones();
      if (_zones.isNotEmpty) {
        for (var element in _zones) {
          _data.addZone(element);
        }
        return _data.getAllZones();
      }
    }
    return _timeZones;
  }

  List<DetailedTimeZoneModel> getAllDetailedModels() =>
      _data.getAllDetailedZones();

  bool checkIfDetailModelSelected(TimeZoneModel zone) =>
      _data.checkIfDetailedModelExists(zone);

  Future getZoneDetails(TimeZoneModel zone) async {
    bool _exits = _data.checkIfDetailedModelExists(zone);
    if (!_exits) {
      Map? _details = await _clt.getTimeZoneInfo(zone);
      if (_details != null) {
        int rawOffset = _details['raw_offset'];
        print('added');
        _data.addDetailedZone(DetailedTimeZoneModel(
            location:
                zone.region != null ? zone.region.toString() : zone.location,
            area: zone.area,
            offset: rawOffset));
      }
      // Adding new member to the animated list

      print('added');
      notifyListeners();

      _globalKey.currentState!.insertItem(0);
    }
  }

  void removeDetailedModels() {
    var _allDetailModels = getAllDetailedModels();

    Future future = Future(() {});
    for (var entry in _allDetailModels) {
      future = future
          .then((_) => Future.delayed(const Duration(milliseconds: 50), () {
                _globalKey.currentState!.removeItem(
                  0,
                  (context, animation) {
                    final Tween<Offset> _offset = Tween<Offset>(
                      begin: const Offset(-1, 0),
                      end: const Offset(0, 0),
                    );
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
