import 'dart:convert';

import 'package:asgard_rohit/model/map_marker.dart';
import 'package:flutter/services.dart';

class MarkerRepository {
  Future<List<MapMarker>> fetchLocations() async {
    final String response = await rootBundle.loadString('assets/markers_list_response.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => MapMarker.fromJson(json)).toList();
  }
}




// class LocationProvider extends ChangeNotifier {
//   final LocationRepository _repository = LocationRepository();

//   List<LocationModel> _locations = [];
//   List<LocationModel> get locations => _locations;

//   bool _isLoading = false;
//   bool get isLoading => _isLoading;

//   String? _errorMessage;
//   String? get errorMessage => _errorMessage;

//   Future<void> fetchLocations() async {
//     _isLoading = true;
//     _errorMessage = null;
//     notifyListeners();

//     try {
//       _locations = await _repository.fetchLocations();
//     } catch (e) {
//       _errorMessage = 'Failed to fetch locations';
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
// }
