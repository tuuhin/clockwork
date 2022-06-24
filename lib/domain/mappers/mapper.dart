import '../models/models.dart';

TimeZoneModel? zoneToModel(String endpoint) {
  List<String> _enties = endpoint.split('/');
  if (_enties.length == 2) {
    return TimeZoneModel(
      area: _enties[0],
      location: _enties[1],
      endpoint: endpoint,
    );
  }
  if (_enties.length == 3) {
    return TimeZoneModel(
        area: _enties[0],
        location: _enties[1],
        region: _enties[2],
        endpoint: endpoint);
  }
  return null;
}
