import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'
    show BitmapDescriptor;

Future<BitmapDescriptor> getAssetImageMarker() async {
  ByteData data = await rootBundle.load("assets/custom-pin.png");
  final Uint8List markerIcon = await _getBytesFromAsset(100,data: data);
  return BitmapDescriptor.fromBytes(markerIcon);
}

Future<BitmapDescriptor> getNetworkImageMarker() async {
  final resp = await Dio().get(
      "https://cdn4.iconfinder.com/data/icons/small-n-flat/24/map-marker-512.png",
      options: Options(responseType: ResponseType.bytes));
  final Uint8List markerIcon = await _getBytesFromAsset(100,webData: resp.data);
  return BitmapDescriptor.fromBytes(markerIcon);
}

Future<Uint8List> _getBytesFromAsset(int width,{ByteData? data, Uint8List? webData}) async {
  ui.Codec codec = await ui.instantiateImageCodec(data != null? data.buffer.asUint8List(): webData!,
      targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
      .buffer
      .asUint8List();
}
