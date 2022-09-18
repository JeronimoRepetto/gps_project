part of 'search_bloc.dart';

class SearchState extends Equatable {
  final bool displayManualMarker;
  final List<Feature> places;
  final List<Feature> historyPlaces;
  const SearchState(
      {this.displayManualMarker = false,
      this.places = const [],
      this.historyPlaces = const []});

  SearchState CopyWith({
    bool? displayManualMarker,
    List<Feature>? places,
    List<Feature>? historyPlaces,
  }) =>
      SearchState(
        displayManualMarker: displayManualMarker ?? this.displayManualMarker,
        places: places ?? this.places,
        historyPlaces: historyPlaces ?? this.historyPlaces,
      );

  @override
  List<Object> get props => [displayManualMarker, places, historyPlaces];
}
