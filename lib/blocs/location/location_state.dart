part of 'location_bloc.dart';

class LocationState extends Equatable {
  final bool followingUser;
  final LatLng? lastKnowLocation;
  final List<LatLng> locationHistory;

  const LocationState(
      {this.followingUser = false, this.lastKnowLocation, locationHistory})
      : locationHistory = locationHistory ?? const [];

  @override
  List<Object?> get props => [followingUser, lastKnowLocation, locationHistory];

  LocationState CopyWith({
    bool? followingUser,
    LatLng? lastKnowLocation,
    List<LatLng>? locationHistory,
  }) =>
      LocationState(
        followingUser: followingUser ?? this.followingUser,
        lastKnowLocation: lastKnowLocation ?? this.lastKnowLocation,
        locationHistory: locationHistory ?? this.locationHistory,
      );
}
