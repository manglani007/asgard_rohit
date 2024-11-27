import 'package:asgard_rohit/location_repository.dart';
import 'package:asgard_rohit/model/map_marker.dart';
import 'package:asgard_rohit/widgets/bouncing_icon.dart';
import 'package:asgard_rohit/widgets/filter_widget.dart';
import 'package:asgard_rohit/widgets/marker_details_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';


Future<void> main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Asgard.world',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FlutterMapDemo(),
    );
  }
}

class FlutterMapDemo extends StatefulWidget {
  const FlutterMapDemo({super.key});

  @override
  State<FlutterMapDemo> createState() => _FlutterMapDemoState();
}

class _FlutterMapDemoState extends State<FlutterMapDemo> {
  final MapRepository _markerRepository = MapRepository();


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _markerRepository,
      builder: (context, child) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final result = await showModalBottomSheet(
                  context: context,
                  isDismissible: false,
                  builder: (context) {
                    return FilterWidget(initialFilter: _markerRepository.selectedFilter);
                  });
              if (result != null) _markerRepository.onFilterChange(result);
            },
            child: const Icon(Icons.filter_list_alt),
          ),
          body: Stack(
            children: [
              FlutterMap(
                mapController: _markerRepository.mapController,
                options: MapOptions(
                    initialCenter: _markerRepository.initialCenter,
                    initialZoom: 15,
                    interactionOptions: const InteractionOptions(
                        flags: InteractiveFlag.drag |
                            InteractiveFlag.flingAnimation |
                            InteractiveFlag.pinchMove |
                            InteractiveFlag.pinchZoom |
                            InteractiveFlag.doubleTapZoom |
                            InteractiveFlag.doubleTapDragZoom |
                            InteractiveFlag.scrollWheelZoom),
                    onMapReady: () {
                      _markerRepository.fetchMarkers();
                    }),
                children: [
                  TileLayer(
                    urlTemplate:
                        _markerRepository.urlTemplate,
                    userAgentPackageName: 'com.rohit.asgard',
                  ),
                  MarkerLayer(
                      rotate: true,
                      markers: _markerRepository.markers
                          .map(
                            (marker) => Marker(
                              key: ObjectKey(marker),
                              point: LatLng(marker.latitude, marker.longitude),
                              child: BouncingIcon(
                                visible: _markerRepository.selectedFilter.contains(marker.markerType) || marker.markerType == MarkerType.gps,
                                icon: marker.markerType.icon,
                                color: marker.markerType.color,
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return MarkerDetailsWidget(marker);
                                      });
                                },
                              ),
                            ),
                          )
                          .toList()),
                ],
              ),
              Positioned(
                  bottom: 10,
                  left: 20,
                  child: SafeArea(
                    child: Row(
                      children: [
                        IconButton.filled(
                            onPressed: _markerRepository.goToCurrentLocation,
                            tooltip: 'Current Location',
                            icon: const Icon(
                              Icons.gps_fixed,
                              size: 30,
                            )),
                        const SizedBox(width: 5),
                        IconButton.filled(
                            onPressed: _markerRepository.goToInitial,
                            tooltip: 'Recenter',
                            icon: const Icon(
                              Icons.navigation_sharp,
                              size: 30,
                            )),
                      ],
                    ),
                  ))
            ],
          ),
        );
      },
    );
    
  }
}

