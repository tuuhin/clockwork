import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../domain/models/models.dart';

class WorldTimeApiClient {
  String baseURL = 'http://worldtimeapi.org/api/timezone';

  Future<Map<String, dynamic>?> getTimeZoneInfo(TimeZoneModel timeZone) async {
    final Uri endpoint = Uri.parse('$baseURL/${timeZone.endpoint}');
    final http.Response resp = await http.get(endpoint);
    if (resp.statusCode == 200) {
      return jsonDecode(resp.body) as Map<String, dynamic>;
    }
    return null;
  }

  Future<List<dynamic>?> _getTimeZones() async {
    final Uri uri = Uri.parse(baseURL);
    try {
      final http.Response resp = await http.get(uri);
      if (resp.statusCode == 200) {
        return jsonDecode(resp.body) as List<dynamic>;
      }
    } on SocketException {
      debugPrint('socket exception ');
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  TimeZoneModel? zoneToModel(String endpoint) {
    final List<String> enties = endpoint.split('/');
    if (enties.length == 2) {
      return TimeZoneModel(
        area: enties[0],
        location: enties[1],
        endpoint: endpoint,
      );
    }
    if (enties.length == 3) {
      return TimeZoneModel(
          area: enties[0],
          location: enties[1],
          region: enties[2],
          endpoint: endpoint);
    }
    return null;
  }

  List<TimeZoneModel> _parsedModels(List<dynamic>? zones) {
    if (zones != null) {
      return zones
          .map<TimeZoneModel?>((dynamic e) => zoneToModel(e.toString()))
          .whereType<TimeZoneModel>()
          .toList();
    }
    return <TimeZoneModel>[];
  }

  Future<List<TimeZoneModel>> getZones() async {
    final List<dynamic>? zones = await _getTimeZones();
    return _parsedModels(zones);
  }
}
