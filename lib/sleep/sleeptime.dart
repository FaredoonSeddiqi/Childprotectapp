import 'dart:async';
import 'package:flutter/material.dart';
import 'package:screen_state/screen_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class sleep extends StatefulWidget {
  @override
  _sleepState createState() => new _sleepState();
}

class ScreenStateEventEntry {
  ScreenStateEvent event;
  DateTime? time;

  ScreenStateEventEntry(this.event) {
    time = DateTime.now();
  }
}

class _sleepState extends State<sleep> {
  Screen _screen = Screen();
  StreamSubscription<ScreenStateEvent>? _subscription;
  bool started = false;
  List<ScreenStateEventEntry> _log = [];

  void initState() {
    super.initState();
    startListening();
  }

  /// Start listening to screen events
  void startListening() {
    try {
      _subscription = _screen.screenStateStream!.listen(_onData);
      setState(() => started = true);
    } on ScreenStateException catch (exception) {
      print(exception);
    }
  }

  void _onData(ScreenStateEvent event) {
    setState(() {
      _log.add(ScreenStateEventEntry(event));
    });

    // Check if the screen is in idle mode
    if (event == ScreenStateEvent.SCREEN_OFF) {
      Future.delayed(Duration(seconds:10), () async {
        if (_log.isNotEmpty && _log.last.event == ScreenStateEvent.SCREEN_OFF) {
          await storeMessageInFirstStore("sleep");
        }
      });
    }

    print(event);
  }

    Future<void> storeMessageInFirstStore(String message) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference collection = firestore.collection('sleeptime');

    // Add the message to Firestore
    await collection.add({'message': message});
  }

  /// Stop listening to screen events
  void stopListening() {
    _subscription?.cancel();
    setState(() => started = false);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Screen State Example'),
        ),
        body: new Center(
            child: new ListView.builder(
                itemCount: _log.length,
                reverse: true,
                itemBuilder: (BuildContext context, int idx) {
                  final entry = _log[idx];
                  return ListTile(
                      leading: Text(entry.time.toString().substring(0, 19)),
                      trailing: Text(entry.event.toString().split('.').last));
                })),
      ),
    );
  }
}