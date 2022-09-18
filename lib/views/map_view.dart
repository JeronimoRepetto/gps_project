import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../blocs/blocs.dart';

class MapView extends StatelessWidget {
  final LatLng initialLocation;
  final Set<Polyline> polylines;
  final Set<Marker> markers;
  const MapView(
      {Key? key, required this.initialLocation, required this.polylines, required this.markers})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    final CameraPosition cameraPosition = CameraPosition(
      target: initialLocation,
      zoom: 15,
    );
    final size = MediaQuery.of(context).size;
    return SizedBox(
        width: size.width,
        height: size.height,
        child: Listener(
          onPointerMove: (_) {
            mapBloc.add(OnStopFollowing());
          },
          child: GoogleMap(
            initialCameraPosition: cameraPosition,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            compassEnabled: false,
            myLocationButtonEnabled: false,
            onMapCreated: (controller) =>
                mapBloc.add(OnMapInitializedEvent(controller)),
            polylines: polylines,
            markers: markers,
            onCameraMove: (position) => mapBloc.mapCenter = position.target,
          ),
        ));
  }
}
