import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_project/ui/ui.dart';

import '../blocs/blocs.dart';

class BtnShowPolyline extends StatelessWidget {
  const BtnShowPolyline({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        maxRadius: 25,
        backgroundColor: Colors.white,
        child: IconButton(
          icon: const Icon(Icons.horizontal_rule_outlined, color: Colors.black),
          onPressed: () {
            mapBloc.add(OnToggleUserRute());
          },
        ),
      ),
    );
  }
}
