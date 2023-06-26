import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';
import 'package:flip_card/flip_card.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlong;

import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  bool isFlipped = false;

  Position? _currentPosition;
  bool isLoading = false;
  bool dadusstatus = false;

  String localizasaun = "";
  final dio = Dio(BaseOptions(baseUrl: 'https://event.timordigital.gov.tl'));
  List<dynamic> _dataList = [];

  @override
  void initState() {
    _getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(),
        child: Scaffold(
          backgroundColor: Colors.red,
          body: FlipCard(
            key: cardKey,
            flipOnTouch: false,
            direction: FlipDirection.HORIZONTAL,
            front: Container(
              constraints: const BoxConstraints.expand(),
              color: Colors.green,
              padding: const EdgeInsets.all(15),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'img/logo.png',
                      width: 200,
                      height: 200,
                    ),
                    const SizedBox(height: 20),
                    dadusstatus
                        ? Expanded(
                            child: ListView.builder(
                              itemCount: _dataList.length,
                              itemBuilder: (context, index) {
                                final item = _dataList[index];
                                return ListTile(
                                  leading: Image.network(
                                    'https://event.timordigital.gov.tl/${item['image']}',
                                    gaplessPlayback: true,
                                    height: 50,
                                    width: 50,
                                  ),
                                  title: Text(item['naran']),
                                  subtitle: Text(
                                      '${item['km']} / km  ${item['m']} m'),
                                );
                              },
                            ),
                          )
                        : const SizedBox(),
                    isLoading
                        ? const CircularProgressIndicator(
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.white),
                          )
                        : Column(
                            children: [
                              ElevatedButton(
                                onPressed: isLoading
                                    ? null
                                    : () async {
                                        setState(() {
                                          isLoading = true;
                                        });

                                        try {
                                          final response = await dio.post(
                                              '/en/turismuapi/lista/',
                                              data: {
                                                'lat': _currentPosition
                                                    ?.latitude
                                                    .toString(),
                                                'lon': _currentPosition
                                                    ?.longitude
                                                    .toString(),
                                              });

                                          print(_currentPosition?.latitude);
                                          print(_currentPosition?.longitude);
                                          print(response.data);

                                          if (response.data['response'] ==
                                              'susesu') {
                                            setState(() {
                                              dadusstatus = true;
                                              _dataList = response.data['data'];
                                            });
                                          } else {
                                            print(
                                                'API response failed: ${response.data}');
                                          }
                                        } catch (e) {
                                          print(e);
                                        } finally {
                                          setState(() {
                                            Future.delayed(
                                                const Duration(seconds: 4), () {
                                              setState(() {
                                                isLoading = false;

                                                isFlipped = !isFlipped;
                                                cardKey.currentState!
                                                    .toggleCard();
                                              });
                                            });
                                          });
                                        }
                                      },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.transparent),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: const BorderSide(
                                          color: Colors.white, width: 2),
                                    ),
                                  ),
                                ),
                                child: const Text(
                                    'Detekta Fatin Turimu Besik Liu'),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
            back: Container(
              constraints: const BoxConstraints.expand(),
              color: Colors.blue,
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Center(
                    child: ElevatedButton(
                      child: const Text("KOko"),
                      onPressed: () {
                        setState(() {
                          isFlipped = !isFlipped;
                          cardKey.currentState!.toggleCard();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            onFlipDone: (isFront) {
              setState(() {
                isFlipped = isFront;
              });
            },
          ),
        ),
      ),
    );
  }

  _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
    });
  }
}
