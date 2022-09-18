import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

import 'models.dart';

class RouteDestination {
  final List<LatLng> points;
  final double duration;
  final double distance;
  final Feature endplace;

  RouteDestination(
      {required this.points,
      required this.duration,
      required this.distance,
      required this.endplace});
}
