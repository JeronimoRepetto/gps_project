import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_project/blocs/blocs.dart';
import 'package:gps_project/screens/gps_access_sceen.dart';
import 'package:gps_project/screens/map_screen.dart';

late String country;
late String language;

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    country = Localizations.localeOf(context).countryCode ?? "es";
    language = Localizations.localeOf(context).languageCode;
    return Scaffold(
      body: BlocBuilder<GpsBloc, GpsState>(builder: (context, state) {
        return state.isAllGranted ? const MapScreen() : const GpsAccessScreen();
      }),
    );
  }
}
