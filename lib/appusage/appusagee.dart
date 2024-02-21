import 'package:flutter/material.dart';
import 'package:app_usage/app_usage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class AppUsageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AppUsagePage(),
    );
  }
}

class AppUsagePage extends StatefulWidget {
  @override
  _AppUsagePageState createState() => _AppUsagePageState();
}

class _AppUsagePageState extends State<AppUsagePage> {
  final firestore = FirebaseFirestore.instance;
  List<AppUsageInfo> _infos = [];
  final appUsage = AppUsage();

  

  @override
  void initState() {
    super.initState();

    // Schedule periodic task to fetch app usage and store in Firestore every 20 seconds
    const duration = Duration(seconds: 10);
    Timer.periodic(duration, (Timer t) {
      getUsageStatsAndStoreInFirestore();
    });
  }

  Future<void> getUsageStatsAndStoreInFirestore() async {
    try {
      DateTime endDate = DateTime.now();
      DateTime startDate = endDate.subtract(Duration(seconds: 2));
      List<AppUsageInfo> infoList = await appUsage.getAppUsage(startDate, endDate);
      _storeAppUsageInFirestore(infoList);
      setState(() => _infos = infoList);
    } on AppUsageException catch (exception) {
      print(exception);
    }
  }

Future<void> _storeAppUsageInFirestore(List<AppUsageInfo> infoList) async {
  final appUsageCollection = firestore.collection('app_usage');
  final appStartTime = DateTime.now(); // Record the time when you start the application
  int totalUsageDurationSeconds = 0;


  if (infoList.isNotEmpty) {
    // If there's no data from AppUsageInfo, check if it has been 3 hours since the start.
    for (var info in infoList) {
      if (info.usage.inSeconds > 0) {
        // Calculate the usage duration in seconds, including milliseconds
        final now = DateTime.now();
        final duration = now.difference(appStartTime);
        final usageDurationSeconds = duration.inSeconds + (duration.inMilliseconds % 1000 >= 500 ? 1 : 0);
        totalUsageDurationSeconds += usageDurationSeconds;

        await appUsageCollection.add({
          'app_name': info.appName,
          'usage_duration_seconds': usageDurationSeconds,
          'start_time': appStartTime,
          'end_time': now,
          'totalusageofApp':totalUsageDurationSeconds,

         
        });
      }
    }
   
  }
}





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App Usage Example'),
      ),
      body: ListView.builder(
        itemCount: _infos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_infos[index].appName),
            trailing: Text(_infos[index].usage.toString()),
          );
        },
      ),
    );
  }
}
