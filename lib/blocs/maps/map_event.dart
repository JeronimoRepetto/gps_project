part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

class OnMapInitializedEvent extends MapEvent {
  final GoogleMapController controller;
  const OnMapInitializedEvent(this.controller);
}

class OnStopFollowing extends MapEvent {}

class OnStartFollowing extends MapEvent {}

class OnSwitchFollowing extends MapEvent {}

class UpdateUserPolylineEvent extends MapEvent {
  final List<LatLng> userHistory;
  const UpdateUserPolylineEvent(this.userHistory);
}

class OnNewPolylineEvent extends MapEvent {
  final Map<String, Polyline> polyline;
  final Map<String, Marker> markers;
  const OnNewPolylineEvent(this.polyline,this.markers);
}

class OnToggleUserRute extends MapEvent {}
