import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_project/blocs/blocs.dart';
import 'package:gps_project/screens/screens.dart';
import 'package:gps_project/services/services.dart';

void main() {
  runApp(MultiBlocProvider(providers: [
    BlocProvider(create: (context) => GpsBloc()),
    BlocProvider(create: (context) => LocationBloc()),
    BlocProvider(
        create: (context) =>
            MapBloc(locationBloc: BlocProvider.of<LocationBloc>(context))),
    BlocProvider(
        create: (context) => SearchBloc(trafficService: TrafficService())),
  ], child: const GpsApp()));
}

class GpsApp extends StatelessWidget {
  const GpsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Gps Project',
        home: LoadingScreen());
  }
}
