import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_project/blocs/blocs.dart';

class GpsAccessScreen extends StatelessWidget {
  const GpsAccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocBuilder<GpsBloc, GpsState>(builder: (context, state) {
      return !state.isGpsEnable
          ? const _EnableGpsMessage()
          : const _AccessButton();
    }));
  }
}

class _EnableGpsMessage extends StatelessWidget {
  const _EnableGpsMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Debe habilitar el GPS',
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
      ),
    );
  }
}

class _AccessButton extends StatelessWidget {
  const _AccessButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Center(child: Text("Es Necesario el acceso al GPS")),
        MaterialButton(
          onPressed: () {
            final gpsBloc = BlocProvider.of<GpsBloc>(context);
            gpsBloc.askGpsAccess();
          },
          elevation: 0,
          shape: const StadiumBorder(),
          splashColor: Colors.transparent,
          color: Colors.black,
          child: const Text(
            "Solicitar Acceso",
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }
}
