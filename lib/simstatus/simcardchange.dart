import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_number/mobile_number.dart';

class simstatus extends StatefulWidget {
  @override
  _simstatusState createState() => _simstatusState();
}

class _simstatusState extends State<simstatus> {
  String _mobileNumber = '';
  List<SimCard> _simCard = <SimCard>[];
  String _simStatusMessage = ''; // Store the SIM status message
  late Timer _locationUpdateTimer;

  @override
  void initState() {
    super.initState();
    checkAndDisplaySimStatus();
    MobileNumber.listenPhonePermission((isPermissionGranted) {
      if (isPermissionGranted) {
        initMobileNumberState();
      } else {
        // Handle the case when permission is not granted.
      }
    });

    initMobileNumberState();

    // Set up a periodic timer to check SIM status every 30 seconds
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initMobileNumberState() async {
    if (!await MobileNumber.hasPhonePermission) {
      await MobileNumber.requestPhonePermission;
      return;
    }
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      _mobileNumber = (await MobileNumber.mobileNumber)!;
      _simCard = (await MobileNumber.getSimCards)!;
    } on PlatformException catch (e) {
      debugPrint("Failed to get mobile number because of '${e.message}'");
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    print('----------------:$_mobileNumber');
    if (!mounted) return;

    setState(() {});
  }

  void checkAndDisplaySimStatus() async {
    _locationUpdateTimer = Timer.periodic(Duration(seconds: 30), (timer) async {
      initMobileNumberState();
      if (_simCard.isNotEmpty) {
        // SIM card is present
        setState(() {
          print('------------:$_simStatusMessage');
          _simStatusMessage = "SIM Card is present";
        });
                _simCard = <SimCard>[];

      } else {
        // SIM card is not present
       setState(() {
           // Set _simCard as an empty list
          _simStatusMessage = "SIM Card is not present";
        });

      }
      print('------------:$_simStatusMessage');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Text('Running on: $_mobileNumber\n'),
              Text(_simStatusMessage),
              
            ],
          ),
        ),
      ),
    );
  }
}
