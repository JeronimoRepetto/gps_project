import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:gps_project/models/models.dart';
import 'package:gps_project/services/places_interceptor.dart';
import 'package:gps_project/services/services.dart';

class TrafficService {
  final Dio _dioTraffic;
  final Dio _dioPlaces;
  final String _baseTrafficUrl = "https://api.mapbox.com/directions/v5/mapbox";
  final String _basePlacesUrl =
      "https://api.mapbox.com/geocoding/v5/mapbox.places";

  TrafficService()
      : _dioTraffic = Dio()..interceptors.add(TrafficInterceptor()),
        _dioPlaces = Dio()..interceptors.add(PlacesInterceptor());

  Future<TrafficResponse> getCoorsStartToEnd(LatLng start, LatLng end) async {
    final coorsString =
        "${start.longitude},${start.latitude};${end.longitude},${end.latitude}";
    final url = "$_baseTrafficUrl/driving/$coorsString";
    final response = await _dioTraffic.get(url);
    final data = TrafficResponse.fromMap(response.data);
    return data;
  }

  Future<List<Feature>> getResultByQuery(LatLng proximity, String query, String country, String language) async {
    if (query.isEmpty) return [];
    final url = "$_basePlacesUrl/$query.json";

    final response = await _dioPlaces.get(url,queryParameters: {
      "proximity" : "${proximity.longitude},${proximity.latitude}",
      "country" : country,
      "language" : language
    });
    final PlacesResponse placesResponse = PlacesResponse.fromJson(response.data);
    return placesResponse.features; //LUGARES
  }
}
