// import 'package:bounce/bounce.dart';
// import 'package:bouncerwidget/bouncerwidget.dart';
// import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:asgard_rohit/location_repository.dart';
import 'package:asgard_rohit/model/map_marker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Marker Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FlutterMapDemo(),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);
//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final locations = const [
//     LatLng(37.42796133580664, -122.085749655962),
//     LatLng(37.41796133580664, -122.085749655962),
//     LatLng(37.43796133580664, -122.085749655962),
//     LatLng(37.42796133580664, -122.095749655962),
//     LatLng(37.42796133580664, -122.075749655962),
//   ];

//   late List<MarkerData> _customMarkers;

//   @override
//   void initState() {
//     super.initState();
//     _customMarkers = [
//       MarkerData(
//           marker:
//               Marker(markerId: const MarkerId('id-1'), position: locations[0],onTap:(){print('Hello');}),
//           child: _customMarker3('Everywhere\nis a Widgets', Colors.blue)),
//       MarkerData(
//           marker:
//               Marker(markerId: const MarkerId('id-5'), position: locations[4]),
//           child: _customMarker('A', Colors.black)),
//       MarkerData(
//           marker:
//               Marker(markerId: const MarkerId('id-2'), position: locations[1]),
//           child: _customMarker('B', Colors.red)),
//       MarkerData(
//           marker:
//               Marker(markerId: const MarkerId('id-3'), position: locations[2]),
//           child: _customMarker('C', Colors.green)),
//       MarkerData(
//           marker:
//               Marker(markerId: const MarkerId('id-4'), position: locations[3]),
//           child: _customMarker2('D', Colors.purple)),
//       MarkerData(
//           marker:
//               Marker(markerId: const MarkerId('id-5'), position: locations[4]),
//           child: _customMarker('A', Colors.blue)),
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           setState(() {
//             if (_customMarkers.isNotEmpty) {
//               _customMarkers.removeLast();
//             }
//           });
//         },
//       ),
//       body: CustomGoogleMapMarkerBuilder(
//         screenshotDelay: const Duration(seconds: 3),
//         customMarkers: _customMarkers,
//         builder: (BuildContext context, Set<Marker>? markers) {
//           if (markers == null) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           return GoogleMap(
//             initialCameraPosition: const CameraPosition(
//               target: LatLng(37.42796133580664, -122.085749655962),
//               zoom: 14.4746,
//             ),
//             markers: markers,
//             onMapCreated: (GoogleMapController controller) {},
//           );
//         },
//       ),
//     );
//   }

//   _customMarker(String symbol, Color color) {
//     return Stack(
//       children: [
//         Icon(
//           Icons.add_location,
//           color: color,
//           size: 50,
//         ),
//         Positioned(
//           left: 15,
//           top: 8,
//           child: Container(
//             width: 20,
//             height: 20,
//             decoration: BoxDecoration(
//                 color: Colors.white, borderRadius: BorderRadius.circular(10)),
//             child: Center(child: Text(symbol)),
//           ),
//         )
//       ],
//     );
//   }

//   _customMarker2(String symbol, Color color) {
//     return Bounce(
//       child: Container(
//         width: 30,
//         height: 30,
//         margin: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//             border: Border.all(color: color, width: 2),
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(15),
//             boxShadow: [BoxShadow(color: color, blurRadius: 6)]),
//         child: Center(child: Column(
//           children: [
//             Text(symbol),
//           ],
//         )),
//       ),
//     );
//   }

//   _customMarker3(String text, Color color) {
//     return BouncingWidget(
//   //     duration: Duration(milliseconds: 100),
//   // scaleFactor: 1.5,
//   // onPressed: (){},
//       child: Container(
//         margin: const EdgeInsets.all(8),
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//             border: Border.all(color: color, width: 2),
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(4),
//             boxShadow: [BoxShadow(color: color, blurRadius: 6)]),
//         child: Center(
//             child: Image.asset(
//     "assets/phone.gif",
//     height: 125.0,
//     width: 125.0,
// ),),
//       ),
//     );
//   }
// }

class FlutterMapDemo extends StatefulWidget {
  const FlutterMapDemo({super.key});

  @override
  State<FlutterMapDemo> createState() => _FlutterMapDemoState();
}

class _FlutterMapDemoState extends State<FlutterMapDemo> {
  List<MapMarker> _markers = [];
  List<MapMarker> _filteredMarkers = [];

  final MarkerRepository _markerRepository = MarkerRepository();
  final MapController mapController = MapController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      loadMarkers();
    });
  }

 void loadMarkers() async {
    _markers = await _markerRepository.fetchLocations();
    setState(() {
      _filteredMarkers =  List.from(_markers);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(onPressed: (){
        if(_filteredMarkers.any((m) => m.markerType == MarkerType.cycle))
        _filteredMarkers.removeWhere((m) => m.markerType == MarkerType.cycle);
        else
          _filteredMarkers = List.from(_markers);
        setState(() {
          
        });
      }, label: Text('Filter')),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
            initialCenter: LatLng(51.50407, -0.218214),
            keepAlive: true, // Center the map over London
            onTap: (tapPos, latLng) {
              print(latLng);
            }),
            
        children: [
          TileLayer(
            urlTemplate:
                'https://api.mapbox.com/styles/v1/mapbox/outdoors-v12/tiles/{z}/{x}/{y}?access_token=pk.eyJ1IjoibWFuZ2xhbmkwMDciLCJhIjoiY20zdDBuZjMwMDNhYTJpcXRob3M3MGVpZyJ9.qCWviHCwGqlGO_Lmde7qQg', // OSMF's Tile Server
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            rotate: true,
              markers: _filteredMarkers
                  .map(
                    (marker) => Marker(
                      key: ObjectKey(marker),
                      point: LatLng(marker.latitude, marker.longitude),
                      child: BouncingIcon(icon: marker.markerType.icon,color: marker.markerType.color,onTap: () {
                        mapController.rotate(30);
                        showModalBottomSheet(context: context, builder: (context){
                          return Container(
                            width: double.maxFinite,
                            child: Column(
                              children: [
                                Text(marker.name+ ' HELLO'),
                              ],
                            ),
                          );
                        });
                      },),
                      
                    ),
                  )
                  .toList()),
          
        ],
      ),
    );
  }
}

class BouncingIcon extends StatefulWidget {
  final IconData icon;
  final double size;
  final Color color;
  final void Function()? onTap;
  final bool visible;

  const BouncingIcon({Key? key, required this.icon, this.size = 30.0, required this.color, this.onTap, this.visible = true}) : super(key: key);

  @override
  _BouncingIconState createState() => _BouncingIconState();
}

class _BouncingIconState extends State<BouncingIcon> with SingleTickerProviderStateMixin,AutomaticKeepAliveClientMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnimatedOpacity(
      opacity: widget.visible ? 1.0 : 0.0,
      duration: const Duration(seconds: 1),
      child: InkWell(
        onTap: widget.onTap,
        child: ScaleTransition(
          scale: _animation,
          child: Icon(
            widget.icon,
            size: widget.size,
            color: widget.color,
            
          ),
        ),
      ),
    );
  }
  
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}