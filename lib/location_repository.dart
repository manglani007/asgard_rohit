import 'dart:convert';

import 'package:asgard_rohit/model/map_marker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapRepository extends ChangeNotifier {
  String urlTemplate = 'https://api.mapbox.com/styles/v1/mapbox/outdoors-v12/tiles/{z}/{x}/{y}?access_token=${dotenv.env['MAP_ACCESS_TOKEN']}';
  final initialCenter = const LatLng(51.5027805, -0.087738);
  final MapController mapController = MapController();
  List<MapMarker> markers = [];
  List<MarkerType> selectedFilter = [MarkerType.cycle, MarkerType.restaurant, MarkerType.shopping];

  Future<void> fetchMarkers() async {
    final String response = await rootBundle.loadString('assets/markers_list_response.json');
    final List<dynamic> data = json.decode(response);
    markers = data.map((json) => MapMarker.fromJson(json)).toList();
    notifyListeners();
  }

  void onFilterChange(List<MarkerType> selectedFilter) {
    this.selectedFilter = selectedFilter;
    notifyListeners();
  }

  void goToInitial() {
    mapController.move(initialCenter, 15);
  }

  void goToCurrentLocation() {
    _determinePosition().then((latLng) {
      markers.removeWhere((m) => m.markerType == MarkerType.gps);
      markers.add(MapMarker(latitude: latLng.latitude, longitude: latLng.longitude, name: 'Your Location', description: 'It\'s You', markerType: MarkerType.gps));
      mapController.move(latLng, 15);
      notifyListeners();
    });
  }

  Future<LatLng> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition();
    return LatLng(position.latitude, position.longitude);
  }
}
