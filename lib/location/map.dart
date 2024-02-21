// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:http/http.dart' as http;

// class MapPage extends StatefulWidget {
//   @override
//   _MapPageState createState() => _MapPageState();
// }

// class _MapPageState extends State<MapPage> {
//   final MapController mapController = MapController();
//   TextEditingController startController = TextEditingController();
//   TextEditingController endController = TextEditingController();
//   late List<LatLng> routePoints = [];

//   @override
//   void initState() {
//     super.initState();
//     // Set the start and end locations statically
//     // startController.text = "8.681495,49.41461"; // San Francisco
//     // endController.text = "8.687872,49.420318";   // New York
//     _getRoutePoints(); // Call to fetch and update route points
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('OpenRouteService Map Example'),
//       ),
//       body: Column(
//         children: [
//           TextField(
//             controller: startController,
//             decoration: InputDecoration(labelText: 'Start Location'),
//           ),
//           TextField(
//             controller: endController,
//             decoration: InputDecoration(labelText: 'End Location'),
//           ),
//           Expanded(
//             child: FlutterMap(
//               options: MapOptions(
//                 center: LatLng(0, 0),
//                 zoom: 2.0,
//               ),
//               layers: [
//                 TileLayerOptions(
//                   urlTemplate:
//                       "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
//                   subdomains: ['a', 'b', 'c'],
//                 ),
//                 if (routePoints.isNotEmpty)
//                   PolylineLayerOptions(
//                     polylines: [
//                       Polyline(
//                         points: routePoints,
//                         color: Colors.blue,
//                         strokeWidth: 3.0,
//                       ),
//                     ],
//                   ),
//                 MarkerLayerOptions(
//                   markers: _buildMarkers(),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// Future<void> _getRoutePoints() async {
//   try {
//     // Replace 'YOUR_API_KEY' with your OpenRouteService API key
//     String apiKey = '5b3ce3597851110001cf624848d4cc6a3d094d679674bdb5ff701a70';
//     String apiUrl =
//         'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey&start=33.6523182,73.0370993&end=33.6523182,73.0370993';

//     final response = await http.get(Uri.parse(apiUrl));

//     if (response.statusCode == 200) {
//       Map<String, dynamic> data = json.decode(response.body);
//       List<dynamic> coordinates =
//           data['features'][0]['geometry']['coordinates'];

//       setState(() {
//         routePoints = coordinates
//             .map((coordinate) => LatLng(coordinate[1], coordinate[0]))
//             .toList();
        
//         if (routePoints.isNotEmpty) {
//           if (mapController != null) {
//             mapController.move(routePoints.first, 10.0);
//           }
//         }
//       });
//     } else {
//       print('Failed to load route points: ${response.reasonPhrase}');
//     }
//   } catch (error) {
//     print('Error fetching route points: $error');
//   }
// }


//   List<Marker> _buildMarkers() {
//     List<Marker> markers = [];
//     if (routePoints.isNotEmpty) {
//       markers.add(
//         Marker(
//           width: 40.0,
//           height: 40.0,
//           point: routePoints.first,
//           builder: (ctx) => Container(),
//         ),
//       );
//       markers.add(
//         Marker(
//           width: 40.0,
//           height: 40.0,
//           point: routePoints.last,
//           builder: (ctx) => Container(),
//         ),
//       );
//     }

//     return markers;
//   }
// }
