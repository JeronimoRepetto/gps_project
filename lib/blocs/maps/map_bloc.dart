import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_project/blocs/blocs.dart';

import '../../themes/map_style.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final LocationBloc locationBloc;
  GoogleMapController? _mapController;

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
      color: Colors.black,
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

  @override
  Future<void> close() {
    locationStateSubscription?.cancel();
    return super.close();
  }
}
