import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';
import 'package:flip_card/flip_card.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlong;

import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class MyAppx2 extends StatefulWidget {
  final String id;

  MyAppx2({required this.id});

  @override
  State<MyAppx2> createState() => _MyAppx2State();
}

class _MyAppx2State extends State<MyAppx2> {
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
      title: 'Informasaun Qr Code  ',
      home: MediaQuery(
        data: MediaQueryData(),
        child: Scaffold(
          appBar: AppBar(title: Text('Informasaun QRCODE')),
          body: Container(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.qr_code,
                    color: Colors.blue,
                    size: 50,
                  ),
                  title: Text(
                      "Scan Qr Code Ne'ebe localiza iha fatin turistico sira hodi hetan informasaun"),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.transparent),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: const BorderSide(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                  child: const Text("Scan QR-Code"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
