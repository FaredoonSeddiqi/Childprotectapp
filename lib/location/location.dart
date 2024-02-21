import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

class LocationTracker extends StatefulWidget {
  @override
  _LocationTrackerState createState() => _LocationTrackerState();
}

class _LocationTrackerState extends State<LocationTracker> {
  final firestore = FirebaseFirestore.instance;
  double latitude = 0.0;
  double longitude = 0.0;
  String currentTime = "";
  DateTime timestampp = DateTime.now();
  Position? lastPosition; // Store the last position
  StreamController<Position> _locationController = StreamController<Position>.broadcast();
  Stream<Position> get locationStream => _locationController.stream;

  @override
  void initState() {
    super.initState();
    startTrackingLocation();
    requestPermission();
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    super.dispose();
  }

Future<void> startTrackingLocation() async {
 await Geolocator.getPositionStream().listen((Position position) {
    // Check if this is the first location update or the distance is greater than 10 km.
    if (lastPosition == null) {
      DateTime currentTimestamp = DateTime.now();
      firestore.collection('locationchild').add({
        'latitude': position.latitude,
        'longitude': position.longitude,
        'timestamp': position.timestamp,
      });
      print('Position: $position');
      
      setState(() {
        latitude = position.latitude.toDouble();
        longitude = position.longitude.toDouble();
        currentTime = position.timestamp.toString();
        lastPosition = position;
        timestampp = currentTimestamp; // Update the last position
      });
      _locationController.add(position); // Emit the position to the stream
      
      
    }else if (Geolocator.distanceBetween(
      lastPosition!.latitude, lastPosition!.longitude,
      position.latitude, position.longitude) > 10 && timestampp.second >60) {
      // User is moving, log the new location
      DateTime currentTime = DateTime.now();

     DateTime timestamp = timestampp ?? currentTime;

     int timeSpentNotMoving = currentTime.difference(timestamp).inSeconds;


      firestore.collection('locationchild').add({
        'latitude': position.latitude,
        'longitude': position.longitude,
        'timestamp': currentTime,
        'lastlocationtimeSpent': timeSpentNotMoving,
      });
      print('Position: $position');
      
      _locationController.add(position); // Emit the position to the stream

       // User is not moving, calculate time spent not moving
      setState(() {
        timestampp = DateTime.now(); // Update the last position
      });
      

    }
 });
}

//  Future<void> startTrackingLocation() async {
//   _locationUpdateTimer = Timer.periodic(Duration(seconds: 30), (timer) async {
//     Position position = await Geolocator.getCurrentPosition();

//     // Check if this is the first location update or the distance is greater than 10 km.
//     if (lastPosition == null || Geolocator.distanceBetween(
//       lastPosition!.latitude, lastPosition!.longitude,
//       position.latitude, position.longitude) > 10000) {
//       // User is moving, log the new location
//       DateTime currentTimestamp = DateTime.now();
//       await firestore.collection('locationchild').add({
//         'latitude': position.latitude,
//         'longitude': position.longitude,
//         'timestamp': currentTimestamp,
//       });
//       print('Position: $position');
//       setState(() {
//         latitude = position.latitude.toDouble();
//         longitude = position.longitude.toDouble();
//         currentTime = currentTimestamp.toString();
//         lastPosition = position; // Update the last position
//       });
//     } else if (lastPosition != null) {
//       // User is not moving, calculate time spent not moving
//      DateTime currentTimestamp = DateTime.now();
//      DateTime timestamp = lastPosition!.timestamp ?? currentTimestamp;
//      int timeSpentNotMoving = currentTimestamp.difference(timestamp).inSeconds;
      
//       // Store the time spent not moving in Firestore
//       await firestore.collection('timeNotMoving').add({
//         'timeSpent': timeSpentNotMoving,
//         'timestamp': currentTimestamp,
//       });
//     }
//   });
// }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(latitude, longitude),
          zoom: 15.0,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate:
                "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayerOptions(
            markers: [
              Marker(
                width: 40.0,
                height: 40.0,
                point: LatLng(latitude, longitude),
                builder: (ctx) => Container(
                  child: Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40.0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  requestPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      print('Location permission granted.');
    } else if (status.isDenied) {
      requestPermission();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }
}
