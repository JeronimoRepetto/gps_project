import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_project/delegates/delegates.dart';
import 'package:gps_project/models/models.dart';

import '../blocs/blocs.dart';
import '../helpers/helpers.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) => state.displayManualMarker
            ? const SizedBox()
            : const _SearchBarBody());
  }
}

class _SearchBarBody extends StatelessWidget {
  const _SearchBarBody({Key? key}) : super(key: key);

  Future<void> _onSearchResult(
      SearchResult searchResult, BuildContext context) async {
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);

    if (searchResult.manual!) {
      searchBloc.add(OnActivateManualMarkerEvent());
      return;
    }
    if (searchResult.position != null) {
      showLoadingMessage(context);
      final destination = await searchBloc.getCoorsStartToEnd(
          locationBloc.state.lastKnowLocation!, searchResult.position!);
      await mapBloc.drawRoutePolyline(destination);
      Navigator.pop(context);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      duration: const Duration(milliseconds: 200),
      child: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.symmetric(horizontal: 30),
          width: double.infinity,
          child: GestureDetector(
            onTap: () async {
              final result = await showSearch(
                  context: context, delegate: SearchDestinationDelegate());
              if (result == null) return;
              _onSearchResult(result, context);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(0, 5),
                    )
                  ]),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
              child: const Text("Where do you want to go?",
                  style: TextStyle(color: Colors.black87)),
            ),
          ),
        ),
      ),
    );
  }
}
