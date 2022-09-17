import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  StreamSubscription? positionStream;
  LocationBloc() : super(const LocationState()) {
    on<OnStartFollowingUser>(
        (event, emit) => emit(state.CopyWith(followingUser: true)));

    on<OnStopFollowingUser>(
        (event, emit) => emit(state.CopyWith(followingUser: false)));

    on<OnNewUserLocationEvent>((event, emit) {
      emit(state.CopyWith(
        lastKnowLocation: event.newLocation,
        locationHistory: [...state.locationHistory, event.newLocation],
        followingUser: true,
      ));
    });
  }
  Future<void> getCurrentPosition() async {
    final position = await Geolocator.getCurrentPosition();
    add(OnNewUserLocationEvent(LatLng(position.latitude, position.longitude)));
  }

  void startFollowingUser() {
    add(OnStartFollowingUser());
    positionStream = Geolocator.getPositionStream().listen((position) {
      add(OnNewUserLocationEvent(
          LatLng(position.latitude, position.longitude)));
    });
  }

  void clearSubscription() {
    positionStream?.cancel();
    add(OnStopFollowingUser());
  }

  @override
  Future<void> close() {
    clearSubscription();
    return super.close();
  }
}
