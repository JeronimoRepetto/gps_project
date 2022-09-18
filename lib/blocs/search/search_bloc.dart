import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:gps_project/blocs/blocs.dart';
import 'package:gps_project/models/models.dart';

import '../../screens/loading_screen.dart' show country, language;
import '../../services/services.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  TrafficService trafficService;

  SearchBloc({required this.trafficService}) : super(const SearchState()) {
    on<OnActivateManualMarkerEvent>(
      (event, emit) => emit(
        state.CopyWith(displayManualMarker: true),
      ),
    );
    on<OnDeactivateManualMarkerEvent>(
      (event, emit) => emit(
        state.CopyWith(displayManualMarker: false),
      ),
    );
    on<OnNewPlacesFoundEvent>(
      (event, emit) => emit(
        state.CopyWith(places: event.places),
      ),
    );
    on<AddToHistoryEvent>(
      (event, emit) {
        List<Feature> historyPlaces = [...state.historyPlaces];
        historyPlaces.removeWhere((place) => place.id == event.place.id);
        emit(
          state.CopyWith(
            historyPlaces: [event.place, ...historyPlaces],
          ),
        );
      },
    );
  }

  Future<RouteDestination> getCoorsStartToEnd(LatLng start, LatLng end) async {
    final trafficResponse = await trafficService.getCoorsStartToEnd(start, end);

    final endPlace =
        await trafficService.getInformationByCoors(end, country, language);

    final distance = trafficResponse.routes[0].distance;
    final duration = trafficResponse.routes[0].duration;
    final geometry = trafficResponse.routes[0].geometry;

    //Decode
    final polylineDecode = decodePolyline(geometry, accuracyExponent: 6);
    final List<LatLng> points = polylineDecode
        .map((coor) => LatLng(coor[0].toDouble(), coor[1].toDouble()))
        .toList();

    return RouteDestination(
      points: points,
      duration: duration,
      distance: distance,
      endplace: endPlace,
    );
  }

  Future getPlacesByQuery(
      LatLng proximity, String query, String country, String language) async {
    final response = await trafficService.getResultByQuery(
        proximity, query, country, language);
    add(OnNewPlacesFoundEvent(response));
  }

  void createCustomPlace(LatLng position, RouteDestination destination) {
    Feature place = Feature(
        id: "${destination.endplace.id}",
        type: "Feature",
        placeType: ["place"],
        text: destination.endplace.text.toString(),
        placeName: destination.endplace.placeName,
        properties:
            Properties.fromMap({'accuracy': null, 'override:postcode': null}),
        center: [position.longitude, position.latitude],
        geometry: Geometry.fromMap({
          'type': 'Point',
          'coordinates': [position.longitude, position.latitude]
        }),
        context: []);
    add(AddToHistoryEvent(place));
  }
}
