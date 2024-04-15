import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gas_leakage_survey/screens/raise_ticket_screen.dart';
import 'package:gas_leakage_survey/screens/raise_ticket_screen_options.dart';
import 'package:gas_leakage_survey/screens/side_drawer/inbuilt_drawer.dart';
import 'package:gas_leakage_survey/screens/side_drawer/side_drawer_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

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
  Position? _currentPosition;
  bool _isRecording = false;
  StreamSubscription<Position>? _positionStreamSubscription;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();

    if (widget.isSurveyInProgress) {
      _startRecording();
      _startLocationUpdates();
    }
    // _printCurrentPosition();
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
          desiredAccuracy: LocationAccuracy.bestForNavigation);

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
    setState(() {
      _isRecording = false; // Update _isRecording state to false
    });
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
        backgroundColor: Color(0xFFFFC604),
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
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 65,
                  right: 65,
                  child: _isRecording ? Container() : MaterialButton(
                    onPressed: _toggleRecording,
                    color: Color(0xFFFFC604),
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
                  left: 0,
                  right: 0,
                  child: Visibility(
                    visible: _isRecording,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _stopRecording,
                          icon: Icon(Icons.stop,color: Colors.black,),
                          label: Text('Stop',style: TextStyle(color: Colors.black),),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10), // Set the border radius here
                            ),
                            minimumSize: Size(50,50),// Set the button background color to red
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RaiseTicketScreenOptions(isSurveyInProgress: true,),
                              ),
                            );
                          },
                          child: Text('Raise Ticket',style: TextStyle(color: Colors.black,fontSize: 16),),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFFC604),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10), // Set the border radius here
                            ),
                            minimumSize: Size(50,50),
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
