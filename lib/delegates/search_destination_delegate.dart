import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:gps_project/blocs/blocs.dart';
import 'package:gps_project/models/models.dart';
import '../widgets/widgets.dart';

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
    final proximity = locationBloc.state.lastKnowLocation!;
    searchBloc.getPlacesByQuery(proximity, query);
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        final places = state.places;
        return ListView.separated(
            itemCount: places.length,
            separatorBuilder: (context, i) => const Divider(),
            itemBuilder: (context, i) {
              final place = places[i];
              return SearchTile(
                title: place.text.toString(),
                icon: Icons.place_outlined,
                subtitle: place.placeName.toString(),
                onTap: () {
                  final position = LatLng(
                    place.geometry.coordinates[1].toDouble(),
                    place.geometry.coordinates[0].toDouble(),
                  );
                  /*
                  For Google:
                  final position = LatLng(
                    place.geometry.coordinates[0].toDouble(),
                    place.geometry.coordinates[1].toDouble(),
                  );
                   */
                  searchBloc.add(AddToHistoryEvent(place));
                  final result = SearchResult(
                    cancel: false,
                    manual: false,
                    position: position,
                    name: place.text,
                    description: place.placeName,
                  );
                  close(context, result);
                },
              );
            });
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final places = searchBloc.state.historyPlaces;
    return Column(
      children: [
        SearchTile(
          icon: Icons.location_on_outlined,
          title: "Set the location manually",
          onTap: () {
            final result = SearchResult(cancel: false, manual: true);
            close(context, result);
          },
        ),
        const Divider(),
        Expanded(
          child: ListView.separated(
            separatorBuilder: (context, i) => const Divider(),
            itemCount: places.length,
            itemBuilder: (context, i) {
              final place = places[i];
              return SearchTile(
                title: place.text.toString(),
                icon: Icons.history_outlined,
                subtitle: place.placeName ??
                    "${place.geometry.coordinates[0]},${place.geometry.coordinates[1]}",
                onTap: () {
                  final position = LatLng(
                    place.geometry.coordinates[1].toDouble(),
                    place.geometry.coordinates[0].toDouble(),
                  );
                  searchBloc.add(AddToHistoryEvent(place));
                  final result = SearchResult(
                    cancel: false,
                    manual: false,
                    position: position,
                    name: place.text,
                    description: place.placeName,
                  );
                  close(context, result);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
