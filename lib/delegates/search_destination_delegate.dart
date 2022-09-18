import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:gps_project/blocs/blocs.dart';
import 'package:gps_project/helpers/helpers.dart';
import 'package:gps_project/models/models.dart';

class SearchDestinationDelegate extends SearchDelegate<SearchResult> {
  SearchDestinationDelegate()
      : super(
          searchFieldLabel: "What are you looking for?",
        );
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios),
      onPressed: () {
        final result = SearchResult(cancel: true);
        close(context, result);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);
    final proximity = locationBloc.state.lastKnowLocation!;
    final country = Localizations.localeOf(context).countryCode ?? "es";
    final language = Localizations.localeOf(context).languageCode;
    searchBloc.getPlacesByQuery(proximity, query, country, language);
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return ListView(
          children: [
            ...state.places
                .map(
                  (place) => FadeInLeft(
                    child: ListTile(
                      title: Text(
                        place.placeName.toString(),
                      ),
                      onTap: () async {
                        showLoadingMessage(context);
                        final destination = await searchBloc.getCoorsStartToEnd(
                          locationBloc.state.lastKnowLocation!,
                          LatLng(
                            place.geometry.coordinates[1].toDouble(),
                            place.geometry.coordinates[0].toDouble(),
                          ),
                        );
                        await mapBloc.drawRoutePolyline(destination);
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                    ),
                  ),
                )
                .toList()
          ],
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.location_on_outlined, color: Colors.black),
          title: const Text(
            "Colocar la ubicacion manualmente",
            style: TextStyle(color: Colors.black),
          ),
          onTap: () {
            final result = SearchResult(cancel: false, manual: true);
            close(context, result);
          },
        )
      ],
    );
  }
}
