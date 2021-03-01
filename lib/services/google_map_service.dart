import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

const apiKey = "AIzaSyBHrrBht5lEns5w6lArJ7cgYyjN_Um_oeA";

class GoogleMapsServices {
  Future<String> getRouteCoordinates(LatLng source, LatLng destination) async {
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${source.latitude},${source.longitude}&destination=${destination.latitude},${destination.longitude}&key=$apiKey";
    http.Response response = await http.get(url);
    Map values = jsonDecode(response.body);
    print(values);
    String points = '';

    if ((values["routes"] as List).isNotEmpty) {
      points = values["routes"][0]["overview_polyline"]["points"];
    }
    return points;
  }
}
