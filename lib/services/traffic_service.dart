import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:gps_project/models/models.dart';
import 'package:gps_project/services/services.dart';

class TrafficService {
  final Dio _dioTraffic;
  final String _baseTrafficUrl = "https://api.mapbox.com/directions/v5/mapbox";

  TrafficService()
      : _dioTraffic = Dio()..interceptors.add(TrafficInterceptor());

  Future<TrafficResponse> getCoorsStartToEnd(LatLng start, LatLng end) async {
    final coorsString =
        "${start.longitude},${start.latitude};${end.longitude},${end.latitude}";
    final url = "$_baseTrafficUrl/driving/$coorsString";
    final response = await _dioTraffic.get(url);
    final data = TrafficResponse.fromMap(response.data);
    return data;
  }
}
