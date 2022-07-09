import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:stopwatch/domain/models/models.dart';

class WorldTimeApiClient {
  String baseURL = 'http://worldtimeapi.org/api/timezone';

  Future<Map?> getTimeZoneInfo(TimeZoneModel timeZone) async {
    Uri endpoint = Uri.parse(baseURL + '/' + timeZone.endpoint);
    http.Response _resp = await http.get(endpoint);
    if (_resp.statusCode == 200) {
      Map _data = jsonDecode(_resp.body) as Map;
      return _data;
    }
    return null;
  }

  Future<List?> _getTimeZones() async {
    final Uri _uri = Uri.parse(baseURL);
    try {
      http.Response _resp =
          await http.get(_uri).timeout(const Duration(seconds: 10));

      if (_resp.statusCode == 200) {
        List _timeZones = jsonDecode(_resp.body) as List;
        return _timeZones;
      } else {
        throw http.ClientException;
      }
    } on SocketException {
      print('socket exception ');
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

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

  List<TimeZoneModel> _parsedModels(List? zones) {
    if (zones != null) {
      return zones
          .map((e) => zoneToModel(e))
          .whereType<TimeZoneModel>()
          .toList();
    }
    return [];
  }

  Future<List<TimeZoneModel>> getZones() async {
    List? _zones = await _getTimeZones();
    List<TimeZoneModel> parsedData = _parsedModels(_zones);
    return parsedData;
  }
}
