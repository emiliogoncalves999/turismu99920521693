import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';
import 'package:flip_card/flip_card.dart';

import 'package:flutter_map/flutter_map.dart';

import 'package:latlong2/latlong.dart' as latlong;

import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:turismutl999/ListaTurismu.dart';
import 'package:turismutl999/uma.dart';
// import 'package:flutter_windows/window.dart';
// https://event.timordigital.gov.tl/en/turismuapi/turismu/listtourism-places/

void main() {
  runApp(MaterialApp(
    home: SplashScreen(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'yolego',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: ListaTurismu(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double opacityLevel = 0.0;

  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1)).then((_) {
      setState(() {
        opacityLevel = 1.0; // Set the opacity to 1 to fade in the image
      });
    });
    Future.delayed(Duration(seconds: 5)).then((_) {
      setState(() {
        opacityLevel = 0.0; // Set the opacity to 0 to fade out the image
      });
      Future.delayed(Duration(milliseconds: 500)).then((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UmaApp()),
        ); // Redirect to the next screen after the fade out animation is finished
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(),
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 38, 102, 218),
          body: Column(
            children: [
              Expanded(
                child: Center(
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 500),
                    opacity: opacityLevel,
                    child: Image.asset(
                      'assets/images/yolego.png',
                      fit: BoxFit.cover,
                      width: 150,
                    ),
                  ),
                ),
              ),
              Image.asset(
                'assets/images/footer.png',
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      print(e);
    }
  }
}
