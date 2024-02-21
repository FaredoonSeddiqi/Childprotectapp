import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:gpx/gpx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class locationss extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('GPX Route Map'),
        ),
        body: FutureBuilder(
          future: loadGpxFile(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              List<LatLng> routePoints = snapshot.data as List<LatLng>;
              return MapWithRoute(routePoints: routePoints);
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}

Future<List<LatLng>> loadGpxFile() async {
  try {
    final ByteData data = await rootBundle.load('asset/two.gpx');
    final String gpxString = utf8.decode(data.buffer.asUint8List());

    final gpx = GpxReader().fromString(gpxString);

    List<LatLng> routePoints = [];
    for (var waypoint in gpx.wpts) {
      if (waypoint.lat != null && waypoint.lon != null) {
        routePoints.add(LatLng(waypoint.lat!, waypoint.lon!));
      }
    }

    return routePoints;
  } catch (e) {
    throw ('Error loading GPX file: $e');
  }
}

class MapWithRoute extends StatelessWidget {
  final List<LatLng> routePoints;

  MapWithRoute({required this.routePoints});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: routePoints.isNotEmpty ? routePoints.first : LatLng(0, 0),
        zoom: 13.0,
      ),
      layers: [
        TileLayerOptions(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: ['a', 'b', 'c'],
        ),
        MarkerLayerOptions(
        markers: routePoints.map((point) {
          return Marker(
            width: 30.0,
            height: 30.0,
            point: point,
            builder: (ctx) => Container(
               child: Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 30.0,
              ),
            ),
          );
        }).toList(),
      ),
        PolylineLayerOptions(
          polylines: [
            Polyline(
              points: routePoints,
              color: Colors.blue,
              strokeWidth: 4.0,
            ),
          ],
        ),
      ],
    );
  }
}
