import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gas_leakage_survey/screens/raise_ticket_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Completer<GoogleMapController> _controller = Completer();
  List<LatLng> _recordedLocations = [];
  Set<Polyline> _polylines = {};
  Position? _currentPosition;
  bool _isRecording = false;
  StreamSubscription<Position>? _positionStreamSubscription;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
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
      _recordedLocations
          .add(LatLng(_currentPosition!.latitude, _currentPosition!.longitude));
    }
  }

  void _stopRecording() {
    _stopLocationUpdates();
    _updatePolylines();
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

  void _updatePolylines() {
    _polylines.clear();
    if (_recordedLocations.isNotEmpty) {
      _polylines.add(Polyline(
        polylineId: PolylineId('recorded_route'),
        points: _recordedLocations,
        color: Colors.red,
        width: 5,
      ));
    }
  }

  void _updateMarkerPosition() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLng(
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF31363F),
      appBar: AppBar(
        title: Text(
          'Gas Leakage Survey',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF31363F),
        centerTitle: true,
      ),
      body: _currentPosition != null
          ? Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        _currentPosition!.latitude,
                        _currentPosition!.longitude,
                      ),
                      zoom: 25.0,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    myLocationEnabled: true,
                    compassEnabled: true,
                    markers: {
                      Marker(
                        markerId: MarkerId('1'),
                        position: LatLng(
                          _currentPosition!.latitude,
                          _currentPosition!.longitude,
                        ),
                        infoWindow: InfoWindow(
                          title: 'My current location',
                        ),
                      ),
                    },
                    polylines: _polylines,
                  ),
                ),
                Positioned(
                  bottom: 20,
                  // right: 60,
                  left: 65,
                  right: 65,
                  child: Container(
                    width: 220, // Adjust width according to your preference
                    height: 50, // Adjust height according to your preference
                    decoration: BoxDecoration(
                      color: _isRecording ? Colors.red : Color(0xFF76ABAE),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),

                    child: TextButton.icon(
                      onPressed: _toggleRecording,
                      icon: Icon(
                        _isRecording ? Icons.stop : Icons.play_arrow,
                        color: Colors.black,
                        size: 30, // Increase the size of the icon
                      ),
                      label: Text(
                        _isRecording ? 'Stop' : 'Start Leakage Survey',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16), // Increase the size of the text
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 6.5, // Adjust position according to your preference
                  left: 65,
                  right: 65,
                  child: Visibility(
                    visible: _isRecording,
                    child: Container(
                      // color: Colors.transparent,
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => RaiseTicket()));
                        },
                        color: Color(0xFF76ABAE),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minWidth: double.infinity,
                        height: 40,
                        child: const Text(
                          'Raise a Ticket',
                          style: TextStyle(fontSize: 17, color: Colors.black),
                        ),
                      ),
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
