import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';


class Batterypercentage extends StatefulWidget {
  @override
  _BatterypercentageState createState() => _BatterypercentageState();
}

class _BatterypercentageState extends State<Batterypercentage> {
  final Battery battery = Battery();
  int batteryLevel = 0;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _getBatteryLevel();
  }

  Future<void> _getBatteryLevel() async {
    try {
      final batteryStatus = await battery.batteryLevel;
      setState(() {
        batteryLevel = batteryStatus;
        // Store the battery percentage in Firestore.
        _storeBatteryLevelInFirestore(batteryLevel);
      });
    } on PlatformException catch (e) {
      print("Failed to get battery level: ${e.message}");
    }
  }

  Future<void> _storeBatteryLevelInFirestore(int level) async {
    try {
      await _firestore.collection('battery_levels').add({
        'level': level,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print("Battery level stored in Firestore: $level%");
    } catch (e) {
      print("Failed to store battery level in Firestore: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Battery Status Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Battery Percentage:",
              style: TextStyle(fontSize: 18),
            ),
            Text(
              "$batteryLevel%",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}


