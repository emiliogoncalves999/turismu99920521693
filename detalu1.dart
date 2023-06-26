import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';
import 'package:flip_card/flip_card.dart';

import 'package:flutter_map/flutter_map.dart';
// ignore: depend_on_referenced_packages

import 'package:latlong2/latlong.dart' as latlong;

import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class MyAppx extends StatefulWidget {
  final String id;
  final String naran;

  MyAppx({required this.id, required this.naran});

  @override
  State<MyAppx> createState() => _MyAppxState();
}

class _MyAppxState extends State<MyAppx> {
  final _dio = Dio(BaseOptions(baseUrl: 'https://event.timordigital.gov.tl'));

  final firstcordinate = latlong.LatLng(-8.559381, 125.573269);

  final seconcordinate = latlong.LatLng(-8.562531, 125.569721);

  String dt = "";

  void getdata() async {
    try {
      final response = await _dio.post('/en/turismuapi/detallu/', data: {
        'id': widget.id,
      });

      if (response.data['response'] == 'susesu') {
        setState(() {
          dt = response.data['dt'];
          print("Fux");
          print(dt);
        });
      } else {
        print("Falla");
      }
    } catch (e) {
      print(e);
    } finally {
      print("Falla");
    }
  }

  @override
  void initState() {
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Localizasaun',
      home: MediaQuery(
        data: MediaQueryData(),
        child: Scaffold(
          appBar: AppBar(title: Text('${widget.naran}')),
          body: Column(
            children: [
              Expanded(
                child: FlutterMap(
                  options: MapOptions(
                    center: latlong.LatLng(-8.556856, 125.567308),
                    zoom: 14.0,
                  ),
                  layers: [
                    TileLayerOptions(
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c'],
                      tileProvider: NonCachingNetworkTileProvider(),
                    ),
                    MarkerLayerOptions(
                      markers: [
                        Marker(
                          point: firstcordinate,
                          builder: (ctx) => Icon(
                            Icons.my_location,
                            size: 40,
                            color: Colors.blue,
                          ),
                        ),
                        Marker(
                          point: seconcordinate,
                          builder: (ctx) => Icon(
                            Icons.location_on,
                            size: 40,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ListTile(
                  onTap: () {
                    showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      barrierColor: Colors.transparent,
                      context: context,
                      builder: (context) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFffffff),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            ), // adds a 10 pixel radius to the top corners
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 15.0, // soften the shadow
                                spreadRadius: 5.0, //extend the shadow
                                offset: Offset(
                                  5.0, // Move to right 5  horizontally
                                  5.0, // Move to bottom 5 Vertically
                                ),
                              )
                            ],
                          ),
                          child: Container(
                            padding: EdgeInsets.all(30),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Text(dt),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  contentPadding: EdgeInsets.all(20),
                  title: Row(
                    children: [
                      Icon(
                        Icons.location_pin,
                        color: Colors.blue,
                      ),
                      Text("${widget.naran}"),
                    ],
                  ),
                  subtitle: Row(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.my_location,
                            color: Colors.blue,
                          ),
                          Text("Hau nia localizasaun"),
                        ],
                      ),
                    ],
                  ),
                  leading: Icon(
                    Icons.map_outlined,
                    size: 40,
                    color: Colors.blue,
                  ),
                  trailing: Column(
                    children: [Icon(Icons.arrow_upward), Text("Detallu")],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
