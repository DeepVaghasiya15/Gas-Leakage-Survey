import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gas_leakage_survey/data/polyline_data.dart';
import 'package:gas_leakage_survey/screens/raise_ticket_screen.dart';
import 'package:gas_leakage_survey/screens/raise_ticket_screen_options.dart';
import 'package:gas_leakage_survey/screens/side_drawer/inbuilt_drawer.dart';
import 'package:gas_leakage_survey/screens/side_drawer/side_drawer_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../data/polyline_algo.dart';


class LocationCoordinate {
  final double latitude;
  final double longitude;

  LocationCoordinate(this.latitude, this.longitude);

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class HomeScreen extends StatefulWidget {
  final bool isSurveyInProgress;

  const HomeScreen({Key? key, required this.isSurveyInProgress}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Completer<GoogleMapController> _controller = Completer();
  List<LatLng> _recordedLocations = [];
  Set<Polyline> _polylines = {};
  Set<Polyline> _storedPolylines = {};
  Set<Polygon> _polygons = {};
  Position? _currentPosition;
  bool _isRecording = false;
  bool _isPaused = false;
  StreamSubscription<Position>? _positionStreamSubscription;
  Timer? _polylineTimer;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();

    // Add the provided coordinates to _recordedLocations if there are any
    // List<Map<String, double>> providedCoordinates = polylineData;
    //
    // _recordedLocations.addAll(providedCoordinates
    //     .map((coord) => LatLng(coord['latitude']!, coord['longitude']!)));

    // List<LatLng> simplifiedPolyline = simplifyPolyline(_recordedLocations, 0.001);
    //
    // // Add the simplified polyline to _polylines
    // _polylines.add(Polyline(
    //   polylineId: PolylineId('simplified_route'),
    //   points: simplifiedPolyline,
    //   color: Colors.blue,
    //   width: 5,
    // ));

    // _updatePolylines();
    // _updatePolygons();

    if (widget.isSurveyInProgress) {
      _startRecording();
      _startLocationUpdates();
    }
    // _printCurrentPosition();
  }

  void _startLocationUpdates() {
    _positionStreamSubscription = Geolocator.getPositionStream().listen(
          (Position position) {
        setState(() {
          _currentPosition = position;
        });
        if (_isRecording) {
          _recordedLocations.add(LatLng(position.latitude, position.longitude));
          _updateMarkerPosition();
        }
      },
      onError: (error) => print("Error in location updates: $error"),
    );
  }

  void _stopLocationUpdates() {
    _positionStreamSubscription?.cancel();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  void _printCoordinatesArray() {
    List<Map<String, double>> coordinatesArray = _recordedLocations.map((location) {
      return {'latitude': location.latitude, 'longitude': location.longitude};
    }).toList();
    print(coordinatesArray);
  }

  Future<List<LatLng>> _sendCoordinatesToServer(List<LatLng> coordinates) async {
    final url = 'https://97b2-2401-4900-1f3e-8fff-00-202-7626.ngrok-free.app/'; // Replace with your API endpoint
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      'data': coordinates.map((coord) => {
        "latitude": coord.latitude,
        "longitude": coord.longitude,
      }).toList(),
    });

    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);
      if (response.statusCode == 200) {
        // Parse the response body
        final responseBody = jsonDecode(response.body);
        // Assuming the response contains an array of coordinates
        final updatedCoordinates = List<Map<String, dynamic>>.from(responseBody['data']);
        // Process the updated coordinates as needed
        print('Updated coordinates received from server: $updatedCoordinates');
        // Convert the updated coordinates to LatLng objects
        final List<LatLng> updatedLatLngCoordinates = updatedCoordinates.map((coord) {
          return LatLng(coord['latitude'], coord['longitude']);
        }).toList();
        return updatedLatLngCoordinates;
      } else {
        print('Failed to send coordinates. Status code: ${response.statusCode}');
        throw Exception('Failed to send coordinates. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending coordinates: $e');
      throw Exception('Error sending coordinates: $e');
    }
  }

  void _toggleRecording() {
    setState(() {
      _isRecording = !_isRecording;
    });
    if (_isRecording) {
      _startRecording();
      _startLocationUpdates();
    } else {
      _stopRecording();
    }
  }

  void _startRecording() {
    _recordedLocations.clear();
    if (_currentPosition != null) {
      _recordedLocations.add(LatLng(_currentPosition!.latitude, _currentPosition!.longitude));
    }
    _startLocationUpdates();
    _polylineTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updatePolylines();
      _storedPolylines.add(List.from(_polylines) as Polyline);
    });
  }

  void _pauseRecording() {
    print("Recording paused");
    _stopLocationUpdates();
    _polylineTimer?.cancel();
    setState(() {
      _isPaused = true;
      _storedPolylines;
      _polylines.clear();
    });
  }

  void _resumeRecording() {
    print("Recording resumed");
    _startLocationUpdates(); // Resume location updates
    // _polylineTimer?.cancel(); // Cancel previous timer if exists
    _polylineTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updatePolylines();
      _storedPolylines.add(List.from(_polylines) as Polyline);
    });
    setState(() {
      _isPaused = false;
      //   // Resume polyline updates
      //   // if (!_isPaused) {
      //   //   _updatePolylines();
      //   // }
      // });
      print('Recording Resumed');
    });
  }


  void _togglePauseResume() {
    if (_isPaused) {
      _resumeRecording(); // If paused, resume recording
    } else {
      _pauseRecording(); // If not paused, pause recording
    }
    // _updatePolylines();
    // if (!_isPaused) {
    //   _updatePolylines();
    // }
    print('Pause/Resume Toggled');
  }

  void _stopRecording() {
    _stopLocationUpdates();
    _polylineTimer?.cancel();
    // _updatePolylines();
    setState(() {
      _isRecording = false; // Update _isRecording state to false
    });
    _printCoordinatesArray();
    _sendCoordinatesToServer(_recordedLocations).then((updatedLatLngCoordinates) {
      // Update UI with the updated coordinates received from the server
      setState(() {
        // Clear previous recorded locations and add updated coordinates
        _recordedLocations.clear();
        _recordedLocations.addAll(updatedLatLngCoordinates);
        // Update polylines
        _updatePolylines();
        _updatePolygons();
      });
    }).catchError((error) {
      print('Error receiving updated coordinates: $error');
    });
  }



  void _updatePolylines() {
    if (_isPaused) {
      return; // If recording is paused, do not update polylines
    }
    _polylines.clear(); // Clear the polylines
    _polylines.addAll(_storedPolylines); // Add stored polylines
    if (_recordedLocations.isNotEmpty) {
      _polylines.add(Polyline(
        polylineId: PolylineId('recorded_route'),
        points: _recordedLocations,
        color: Colors.red,
        width: 5,
      ));
    }
  }


  void _updatePolygons() {
    _polygons.clear();

    List<Map<String, double>> providedCoordinates = polylineData;

    List<LatLng> points = providedCoordinates.map((coord) {
      return LatLng(coord['latitude']!, coord['longitude']!);
    }).toList();

    _polygons.add(Polygon(
      polygonId: PolygonId('polygon'),
      points: points,
      strokeWidth: 5,
      strokeColor: Colors.green,
      fillColor: Colors.transparent, // Set to transparent if you don't want to fill the polygon
    ));
  }

  void _updateMarkerPosition() async {
    print('Updating marker position:');
    print('Current Latitude: ${_currentPosition!.latitude}');
    print('Current Longitude: ${_currentPosition!.longitude}');

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLng(
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude)));

    print('Marker position updated.');
  }


  void _printCurrentPosition() {
    if (_currentPosition != null) {
      print('Current Latitude: ${_currentPosition!.latitude}');
      print('Current Longitude: ${_currentPosition!.longitude}');
    } else {
      print('Current position is not available yet. Trying again...');
      _getCurrentLocation(); // Attempt to fetch the current location again
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFF31363F),
      appBar: AppBar(
        title: Text(
          'Gas Leakage Survey',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(0xFFEFFF00),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu_rounded),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: const DrawerHomeScreen(),
      body: _currentPosition != null
          ? Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(0),
                  ),
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        _currentPosition!.latitude,
                        _currentPosition!.longitude,
                      ),
                      zoom: 19.0,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    myLocationEnabled: true,
                    compassEnabled: true,
                    markers: {
                      // Marker(
                      //   markerId: MarkerId('1'),
                      //   position: LatLng(
                      //     _currentPosition!.latitude,
                      //     _currentPosition!.longitude,
                      //   ),
                      //   infoWindow: InfoWindow(
                      //     title: 'My current location',
                      //   ),
                      // ),
                    },
                    polylines: _polylines,
                    // polygons: _polygons,
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 65,
                  right: 65,
                  child: _isRecording ? Container() : MaterialButton(
                    onPressed: _toggleRecording,
                    color: Color(0xFFEFFF00),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minWidth: double.infinity,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.play_arrow, color: Colors.black), // Icon
                        SizedBox(width: 8),
                        Text(
                          'Start Leakage Survey',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 5,
                  right: 5,
                  child: Visibility(
                    visible: _isRecording,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          fit: FlexFit.tight,
                          child: ElevatedButton.icon(
                            onPressed: _stopRecording,
                            icon: Icon(Icons.stop, color: Colors.black),
                            label: Text('Stop', style: TextStyle(color: Colors.black),
                              textAlign: TextAlign.center,),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              minimumSize: Size(50, 50),
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Flexible(
                          fit: FlexFit.loose,
                          child: ElevatedButton.icon(
                            onPressed: _togglePauseResume,
                            icon: Icon(
                              _isPaused ? Icons.play_arrow : Icons.pause,
                              color: Colors.black,
                            ),
                            label: Text(
                              _isPaused ? 'Resume' : 'Pause',
                              style: TextStyle(color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isPaused ? Colors.green : Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              minimumSize: Size(50, 50),
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Flexible(
                          fit: FlexFit.tight,
                          child: ElevatedButton(
                            onPressed: () {
                              selectedOptionArray.clear();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RaiseTicketScreenOptions(
                                    isSurveyInProgress: true,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'Raise Ticket',
                              style: TextStyle(color: Colors.black, fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFEFFF00),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              minimumSize: Size(50, 50),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
