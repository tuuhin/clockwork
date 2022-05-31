import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stopwatch/models/models.dart';

class WorldTimeApiClient {
  String baseURL = 'http://worldtimeapi.org/api/timezone';

  Future<List?> _getTimeZones() async {
    final Uri _uri = Uri.parse(baseURL);
    try {
      http.Response _resp = await http.get(_uri);
      print('i am called');
      if (_resp.statusCode == 200) {
        List _timeZones = jsonDecode(_resp.body) as List;
        return _timeZones;
      } else {
        throw http.ClientException;
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  TimeZoneModel? _zoneToModel(String endpoint) {
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

  List<TimeZoneModel?>? _parsedModels(List? zones) => zones!
      .map((e) => _zoneToModel(e))
      .where((element) => element != null)
      .toList();

  Future<List<TimeZoneModel?>?> getZones() async {
    List? _zones = await _getTimeZones();
    List<TimeZoneModel?>? parsedData = _parsedModels(_zones);
    return parsedData;
  }
}
