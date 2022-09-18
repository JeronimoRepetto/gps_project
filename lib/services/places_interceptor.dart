import 'package:dio/dio.dart';

class PlacesInterceptor extends Interceptor {
  final accessToken =
      "pk.eyJ1IjoianJlcGV0dG8iLCJhIjoiY2w4NmJpOG1wMHhyNzN2bGt3Y2p1dW96NSJ9.Tx-Yn9blPLwRD44b_1jiwg";

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters.addAll({
      "types": ["place", "postcode", "address"],
      "geometries": "polyline6",
      "autocomplete": false,
      "routing": true,
      "access_token": accessToken
    });
    super.onRequest(options, handler);
  }
}
