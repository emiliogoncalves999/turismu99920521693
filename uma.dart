import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';

import 'package:dio/dio.dart';
import 'package:flip_card/flip_card.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlong;

import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:archive/archive_io.dart';
import 'detallu2.dart';
import 'detalu1.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:connectivity/connectivity.dart';

import 'package:geocoding/geocoding.dart';

class UmaApp extends StatefulWidget {
  @override
  _UmaAppState createState() => _UmaAppState();
}

class _UmaAppState extends State<UmaApp> {
  Position? _currentPosition;
  late bool _isLoadinglocation = false;
  late bool _isLoading = false;
  late bool _dadusstatus = false;
  late String _locationstatus = "";
  String localizasaun = "mamuk";
  String localizasaunbuttom = "Refresh";
  final _dio = Dio(BaseOptions(baseUrl: 'https://event.timordigital.gov.tl'));
  List<dynamic> _dataList = [];

//QR

  String _scanResult = 'Unknown';

  @override
  void initState() {
    _getCurrentLocation();
    super.initState();
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _widgetOptions = <Widget>[
      Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          await _detektafatin();
                        },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 255, 255, 255)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: const BorderSide(
                            color: Color.fromARGB(255, 38, 102, 218), width: 2),
                      ),
                    ),
                  ),
                  child: Text('Kultura',
                      style:
                          TextStyle(color: Color.fromARGB(255, 38, 102, 218))),
                ),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          await _detektafatin();
                        },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 255, 255, 255)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: const BorderSide(
                            color: Color.fromARGB(255, 38, 102, 218), width: 2),
                      ),
                    ),
                  ),
                  child: Text('Ambiente',
                      style:
                          TextStyle(color: Color.fromARGB(255, 38, 102, 218))),
                ),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          await _detektafatin();
                        },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 255, 255, 255)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: const BorderSide(
                            color: Color.fromARGB(255, 38, 102, 218), width: 2),
                      ),
                    ),
                  ),
                  child: Text('Rezistencia',
                      style:
                          TextStyle(color: Color.fromARGB(255, 38, 102, 218))),
                ),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          await _detektafatin();
                        },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 255, 255, 255)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: const BorderSide(
                            color: Color.fromARGB(255, 38, 102, 218), width: 2),
                      ),
                    ),
                  ),
                  child: Text('Rezistencia',
                      style:
                          TextStyle(color: Color.fromARGB(255, 38, 102, 218))),
                ),
              ],
            ),
          ),
          _dadusstatus
              ? Container(
                  color: Colors.black12,
                  child: ListTile(
                    leading: Icon(Icons.location_pin),
                    title: Text(
                        "${localizasaun} , Eziste fatin turismu ${_dataList.length} maka besik ita bo'ot "),
                  ),
                )
              : Text(""),
          _dadusstatus
              ? Expanded(
                  child: ListView.builder(
                    itemCount: _dataList.length,
                    itemBuilder: (context, index) {
                      final item = _dataList[index];
                      return Container(
                        padding: EdgeInsets.all(5),
                        child: Card(
                          child: ListTile(
                            leading: Image.network(
                              'https://event.timordigital.gov.tl/${item['image']}',
                              gaplessPlayback: true,
                              height: 50,
                              width: 50,
                            ),
                            title: Text(item['naran']),
                            subtitle: Text(
                                '${item['km']} km husi ita boot nia fatin'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyAppx(
                                      id: item['id'].toString(),
                                      naran: item['naran'].toString()),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                )
              : Expanded(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        padding: EdgeInsets.all(40),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/lafa.gif',
                              fit: BoxFit.cover,
                              width: 200,
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              width: 200,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                  top: BorderSide.none,
                                  bottom: BorderSide(
                                    color: Colors.black,
                                    width: 2.0,
                                    style: BorderStyle.solid,
                                  ),
                                  left: BorderSide(
                                    color: Colors.black,
                                    width: 2.0,
                                    style: BorderStyle.solid,
                                  ),
                                  right: BorderSide(
                                    color: Colors.black,
                                    width: 2.0,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                              ),
                              child: _isLoadinglocation
                                  ? Center(child: Text("Hein Oitoan .."))
                                  : Column(
                                      children: [
                                        Text(localizasaun),
                                        _isLoading
                                            ? CircularProgressIndicator()
                                            : ElevatedButton(
                                                onPressed: _isLoading
                                                    ? null
                                                    : () async {
                                                        await _detektafatin();
                                                      },
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                              Color>(
                                                          Color.fromARGB(255,
                                                              255, 255, 255)),
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              18.0),
                                                      side: const BorderSide(
                                                          color: Color.fromARGB(
                                                              255,
                                                              38,
                                                              102,
                                                              218),
                                                          width: 2),
                                                    ),
                                                  ),
                                                ),
                                                child: Text(
                                                    '${localizasaunbuttom}',
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255,
                                                            38,
                                                            102,
                                                            218))),
                                              ),
                                      ],
                                    ),
                            ),
                          ],
                        )),
                  ],
                )),
          _isLoading
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : Text("")
        ],
      ),
      Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                padding: EdgeInsets.all(40),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/qrscan.gif',
                      fit: BoxFit.cover,
                      width: 200,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.qr_code,
                        color: Colors.blue,
                        size: 50,
                      ),
                      title: Text(
                          "Scan Qr Code Ne'ebe localiza iha fatin turistico hodi le informasaun"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _startQrCodeScan();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 247, 247, 247)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: const BorderSide(
                                color: Color.fromARGB(255, 38, 102, 218),
                                width: 2),
                          ),
                        ),
                      ),
                      child: const Text(
                        "Scan QR-Code",
                        style:
                            TextStyle(color: Color.fromARGB(255, 38, 102, 218)),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    ];

    return MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 38, 102, 218),
            title: Image.asset(
              'assets/images/yolego.png',
              fit: BoxFit.cover,
              width: 100,
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.qr_code),
                onPressed: () {
                  // TODO: Implement QR code functionality
                },
              )
            ],
          ),
          body: Container(
            child: Center(
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Color.fromARGB(255, 38, 102, 218),
            selectedItemColor: Color.fromARGB(255, 255, 255, 255),
            unselectedItemColor: Color.fromARGB(255, 76, 140, 242),
            selectedFontSize: 14,
            unselectedFontSize: 12,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.location_pin),
                label: 'Fatin',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.qr_code),
                label: 'QR',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }

  Future<void> _startQrCodeScan() async {
    try {
      print("QR CODE");
      final qrCodeScanResult = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );

      print("Tamaaaaa");

      String id = "";

      if (qrCodeScanResult == "-1") {
        print("");
      } else if (qrCodeScanResult == "") {
        print("");
      } else {
        try {
          String compressedString = qrCodeScanResult;
          List<int> compressedBytes = base64.decode(compressedString);

          List<int> decompressedBytes =
              GZipDecoder().decodeBytes(compressedBytes);

          String decompressedString = utf8.decode(decompressedBytes);

          dialogscanopen(decompressedString);
        } catch (e) {
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
                    child: Text("Qr Code Invalidu"),
                  ),
                ),
              );
            },
          );
        }
      }
    } on PlatformException {
      print("errror");
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MyAppx2(
                id: '1',
              )));
    }
  }

  Future<void> _getadress() async {
    print("koko");
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadinglocation = true;
    });
    // Check if there is internet connectivity
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _isLoadinglocation = false;
        _locationstatus = "nointernet";
        localizasaun =
            "Laiha konexaun internet, Favor Ativu ita bo'ot nia rede  internet.";
        localizasaunbuttom = "Koko Fali";
      });
      return;
    } else {
      print("tama");
      // Check if location services are enabled
      bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isLocationEnabled) {
        setState(() {
          _isLoadinglocation = false;
          _locationstatus = "laiha";
          localizasaun =
              "GPS taka hela , favor klik butaun iha okos hodi loke GPS.";
          localizasaunbuttom = "Loke GPS";
        });
        return;
      } else {
        // Get the current location
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        if (position == null) {
          setState(() {
            _isLoadinglocation = false;
            _locationstatus = "cordinatelaiha";
            localizasaun =
                "Labele detekta ita bo'ot nia fatin !!! ,  favor klik butaun iha okos hodi koko fila fali ";
            localizasaunbuttom = "Koko Fali";
          });
          return;
        } else {
          setState(() {
            _isLoadinglocation = false;
            _locationstatus = "iha";
            _currentPosition = position;
          });

          List<Placemark> placemarks = await placemarkFromCoordinates(
              _currentPosition!.latitude, _currentPosition!.longitude);
          String address =
              "Hyy Ita Bo'ot Agora Iha  ${placemarks[0].administrativeArea} ${placemarks[0].country}";
          localizasaunbuttom = "Buka Fatin Turismu";

          setState(() {
            _isLoadinglocation = false;
            localizasaun = address;
          });
        }
      }
    }
  }

  Future<void> _detektafatin() async {
    if (_locationstatus == "iha") {
      setState(() {
        _isLoading = true;
      });

      try {
        final response = await _dio.post('/en/turismuapi/lista/', data: {
          'lat': _currentPosition?.latitude.toString(),
          'lon': _currentPosition?.longitude.toString(),
        });

        print(response.data);

        if (response.data['response'] == 'susesu') {
          setState(() {
            _dadusstatus = true;
            _dataList = response.data['data'];
          });
        } else {
          print('API response failed: ${response.data}');
        }
      } catch (e) {
        print(e);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else if (_locationstatus == "laiha") {
      await Geolocator.openLocationSettings();

      await _getCurrentLocation();
    } else if (_locationstatus == "mamuk") {
      _getCurrentLocation();
    } else if (_locationstatus == "nointernet") {
      _getCurrentLocation();
    } else if (_locationstatus == "cordinatelaiha") {
      _getCurrentLocation();
    }
  }

  void dialogscanopen(String compressedString) {
    List<String> historia = compressedString.split("==");

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // final historia = [
        //   'lorem ipsum',
        //   'dolor sit amet',
        //   'consectetur adipiscing elit',
        //   'sed do eiusmod',
        //   'tempor incididunt'
        // ];
        final textLength = historia.join().length;
        final screenHeight = MediaQuery.of(context).size.height;

        return Dialog(
          backgroundColor: Color.fromARGB(0, 255, 255, 255),
          child: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                Image.asset(
                  'assets/images/kaibauk.png',
                  fit: BoxFit.cover,
                  width: 250,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    width: 250,
                    child: Column(
                      children: [
                        TabBar(
                          labelColor: Colors.black,
                          tabs: [
                            Tab(
                              icon: Icon(
                                Icons.language,
                                color: Colors.black,
                              ),
                              text: "Tetum",
                            ),
                            Tab(
                              icon: Icon(
                                Icons.language,
                                color: Colors.black,
                              ),
                              text: "English",
                            ),
                          ],
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(5),
                            child: TabBarView(
                              children: [
                                SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        Text(
                                          historia[1],
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Divider(
                                          color: Colors.grey,
                                          thickness: 1,
                                          height: 16,
                                          indent: 16,
                                          endIndent: 16,
                                        ),
                                        Text(
                                          historia[2],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    children: [
                                      Text(
                                        historia[3],
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Divider(
                                        color: Colors.grey,
                                        thickness: 1,
                                        height: 16,
                                        indent: 16,
                                        endIndent: 16,
                                      ),
                                      Text(
                                        historia[4],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
