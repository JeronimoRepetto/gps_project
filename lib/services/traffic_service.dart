import 'package:devicelocale/devicelocale.dart';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:gps_project/models/models.dart';
import 'package:gps_project/services/places_interceptor.dart';
import 'package:gps_project/services/services.dart';

late String country;
late dynamic language;

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

  Future<List<Feature>> getResultByQuery(LatLng proximity, String query) async {
    if (query.isEmpty) return [];
    final url = "$_basePlacesUrl/$query.json";
    await _checkCountryAndLanguage();
    final response = await _dioPlaces.get(url, queryParameters: {
      "limit": 7,
      "proximity": "${proximity.longitude},${proximity.latitude}",
      "country": country.split("-")[1],
      "language": language.split("-")[1]
    });
    final PlacesResponse placesResponse = PlacesResponse.fromMap(response.data);
    return placesResponse.features;
  }

  Future<Feature> getInformationByCoors(LatLng coors) async {
    final url = "$_basePlacesUrl/${coors.longitude},${coors.latitude}.json";
    await _checkCountryAndLanguage();
    final response = await _dioPlaces.get(url, queryParameters: {
      "limit": 1,
      "country": country.split("-")[1],
      "language": language.split("-")[1]
    });
    final PlacesResponse placesResponse = PlacesResponse.fromMap(response.data);
    return placesResponse.features.first;
  }

  _checkCountryAndLanguage() async {
    country = await Devicelocale.currentLocale ?? "ES";
    final languages = await Devicelocale.preferredLanguages;
    language = languages != null ? languages[0] : "es";
  }
}
