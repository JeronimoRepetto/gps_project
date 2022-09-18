part of 'map_bloc.dart';

class MapState extends Equatable {
  final bool isMapInitialized;
  final bool isFollowingUser;
  final bool showMyRute;

  final Map<String, Polyline> polylines;
  final Map<String, Marker> markers;

/*
  mi_ruta : {
    id: polyliuneID by Google
    points : [[Lat,Lng], [12314124,-1231231], [123213,-1231321], ...]
    width: 3
    color: black[87]
  }
*/

  const MapState({
    this.isMapInitialized = false,
    this.isFollowingUser = true,
    this.showMyRute = true,
    Map<String, Polyline>? polylines,
    Map<String, Marker>? markers,
  })  : polylines = polylines ?? const {},
        markers = markers ?? const {};

  MapState CopyWith({
    bool? isMapInitialized,
    bool? isFollowingUser,
    bool? showMyRute,
    Map<String, Polyline>? polylines,
    Map<String, Marker>? markers,
  }) =>
      MapState(
        isMapInitialized: isMapInitialized ?? this.isMapInitialized,
        isFollowingUser: isFollowingUser ?? this.isFollowingUser,
        showMyRute: showMyRute ?? this.showMyRute,
        polylines: polylines ?? this.polylines,
        markers: markers ?? this.markers,
      );

  @override
  List<Object> get props =>
      [isMapInitialized, isFollowingUser, showMyRute, polylines, markers];
}
