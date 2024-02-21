import 'package:childapp/appusage/appusagee.dart';
import 'package:childapp/batterylevel/batterylevel.dart';
import 'package:childapp/location/location.dart';
import 'package:childapp/simstatus/simcardchange.dart';
import 'package:childapp/sleep/sleeptime.dart';
import 'package:flutter/material.dart';
class pages extends StatefulWidget {
  const pages({super.key});

  @override
  State<pages> createState() => _pagesState();
}

class _pagesState extends State<pages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            children: [
              // Padding(
              //   padding: const EdgeInsets.only(top: 150),
              //   child: Container(
              //     decoration: BoxDecoration(
              //       image: DecorationImage(
              //         image: AssetImage('images/start.jpg'),
              //         fit: BoxFit.cover,
              //       ),
              //     ),
              //     width: 300,
              //     height: 300,
              //   ),
              // ),
              SizedBox(height:170,),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                elevation: 5.0,
                height: 60,
                minWidth: 380,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>sleep()));
                },
                child: Text(
                  "Battery",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
                color: Color(0xffFF1744),
              ),
           SizedBox(height: 10,),
            MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                elevation: 5.0,
                height: 60,
                minWidth: 380,
                onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>AppUsageApp()));

                },
                child: Text(
                  "App Usage",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
                color: Color(0xff0091EA),
              ),
                            MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                elevation: 5.0,
                height: 60,
                minWidth: 380,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>LocationTracker()));
                },
                child: Text(
                  "Location",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
                color: Color(0xffFF1744),
              ),
           SizedBox(height: 10,),
            MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                elevation: 5.0,
                height: 60,
                minWidth: 380,
                onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>simstatus()));

                },
                child: Text(
                  "simstats",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
                color: Color(0xff0091EA),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
