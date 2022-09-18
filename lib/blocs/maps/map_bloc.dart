import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_project/blocs/blocs.dart';
import 'package:gps_project/models/models.dart';

import '../../helpers/helpers.dart';
import '../../themes/map_style.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final LocationBloc locationBloc;
  GoogleMapController? _mapController;
  LatLng? mapCenter;

  StreamSubscription<LocationState>? locationStateSubscription;

  MapBloc({required this.locationBloc}) : super(const MapState()) {
    on<OnMapInitializedEvent>(_onInitMap);

    on<OnSwitchFollowing>(_onSwitchFollowingUser);

    on<OnStopFollowing>(
        (event, emit) => emit(state.CopyWith(isFollowingUser: false)));

    on<OnStartFollowing>(
        (event, emit) => emit(state.CopyWith(isFollowingUser: false)));

    on<UpdateUserPolylineEvent>(_onPolylineUpdate);

    on<OnToggleUserRute>(
        (event, emit) => emit(state.CopyWith(showMyRute: !state.showMyRute)));

    on<OnNewPolylineEvent>((event, emit) => emit(
        state.CopyWith(polylines: event.polyline, markers: event.markers)));

    locationStateSubscription = locationBloc.stream.listen((locationState) {
      if (locationState.lastKnowLocation == null) return;
      add(UpdateUserPolylineEvent(locationState.locationHistory));

      if (!state.isFollowingUser) return;

      moveCamera(locationState.lastKnowLocation!);
    });
  }

  void _onInitMap(OnMapInitializedEvent event, Emitter<MapState> emit) {
    _mapController = event.controller;
    _mapController!.setMapStyle(jsonEncode(mapStyleTheme));
    emit(state.CopyWith(isMapInitialized: true));
  }

  void _onSwitchFollowingUser(OnSwitchFollowing event, Emitter<MapState> emit) {
    emit(state.CopyWith(isFollowingUser: !state.isFollowingUser));

    if (locationBloc.state.lastKnowLocation == null) return;
    if (!state.isFollowingUser) {
      moveCamera(locationBloc.state.lastKnowLocation!);
    }
  }

  void _onPolylineUpdate(
      UpdateUserPolylineEvent event, Emitter<MapState> emit) {
    final Polyline myRute = Polyline(
      polylineId: const PolylineId("myRoute"),
      color: Colors.black45,
      width: 3,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      points: event.userHistory,
    );
    final currentPolyline = Map<String, Polyline>.from(state.polylines);
    currentPolyline["myRoute"] = myRute;

    emit(state.CopyWith(polylines: currentPolyline));
  }

  void moveCamera(LatLng newLocation) {
    final cameraUpdate = CameraUpdate.newLatLng(newLocation);
    _mapController?.animateCamera(cameraUpdate);
  }

  Future<void> drawRoutePolyline(RouteDestination destination) async {
    final myDestination = Polyline(
        polylineId: const PolylineId("routeDestination"),
        color: Colors.black,
        points: destination.points,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        width: 3);

    double kms = destination.distance / 1000;
    kms = (kms * 100).floorToDouble();
    kms /= 100;

    double tripDuration = (destination.duration / 60).floorToDouble();

    final startImgMarker =
        await getStartCustomMarker(tripDuration.toInt(), "Current location");
    final endImgMarker = await getEndCustomMarker(
        kms.toInt(), destination.endplace.placeName.toString());

    final startMarker = Marker(
        icon: startImgMarker,
        markerId: const MarkerId("start"),
        position: destination.points.first,
        anchor: const Offset(0, 0.9));

    final endMarker = Marker(
      icon: endImgMarker,
      markerId: const MarkerId("end"),
      position: destination.points.last,
    );

    final currentMarkers = Map<String, Marker>.from(state.markers);
    currentMarkers["start"] = startMarker;
    currentMarkers["end"] = endMarker;

    final currentPolyline = Map<String, Polyline>.from(state.polylines);
    currentPolyline["routeDestination"] = myDestination;

    add(OnNewPolylineEvent(currentPolyline, currentMarkers));

    await Future.delayed(const Duration(milliseconds: 300));
    _mapController?.showMarkerInfoWindow(const MarkerId("end"));
  }

  @override
  Future<void> close() {
    locationStateSubscription?.cancel();
    return super.close();
  }
}
