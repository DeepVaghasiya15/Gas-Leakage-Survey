import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gas_leakage_survey/data/polyline_data.dart';
import 'package:gas_leakage_survey/raise_ticket_screen_options/formFill/take_video_screen.dart';
import 'package:gas_leakage_survey/screens/raise_ticket_screen.dart';
import 'package:gas_leakage_survey/screens/raise_ticket_screen_options.dart';
import 'package:gas_leakage_survey/screens/side_drawer/inbuilt_drawer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:weather/weather.dart';
import '../data/polyline_algo.dart';
import '../data/raise_ticket_data.dart';
import '../raise_ticket_screen_options/formFill/take_picture_screen.dart';
import 'package:geocoding/geocoding.dart';


// Get coordinates of location
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

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
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
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);
  Weather? _weather;
  bool _isSurveyStoppedDueToTicket = false;
  double _totalDistance = 0.0;


  @override
  bool get wantKeepAlive => true;
  void initState() {
    super.initState();
    _getCurrentLocation();

    // Add the provided coordinates to _recordedLocations if there are any
    // List<Map<String, double>> providedCoordinates = polylineData;
    //
    // _recordedLocations.addAll(providedCoordinates
    //     .map((coord) => LatLng(coord['latitude']!, coord['longitude']!)));
    //
    // List<LatLng> simplifiedPolyline = simplifyPolyline(_recordedLocations, 0.001);
    //
    // // Add the simplified polyline to _polylines
    // _polylines.add(Polyline(
    //   polylineId: PolylineId('simplified_route'),
    //   points: simplifiedPolyline,
    //   color: Colors.blue,
    //   width: 5,
    // ));
    //
    // _updatePolylines();
    // _updatePolygons();

    if (widget.isSurveyInProgress) {
      _startRecording();
      _startLocationUpdates();
    }
    // _printCurrentPosition();
  }

  void rebuildScreen() {
    setState(() {});
  }

  //Location updates starts when click on Start Survey
  void _startLocationUpdates() {
    _positionStreamSubscription = Geolocator.getPositionStream().listen(
          (Position position) {
        if (mounted && _isRecording && !_isPaused) { // Check if widget is still mounted, recording, and not paused
          setState(() {
            _currentPosition = position;
          });
          if (_recordedLocations.isNotEmpty) {
            final lastLocation = _recordedLocations.last;
            final newLocation = LatLng(position.latitude, position.longitude);
            final distance = Geolocator.distanceBetween(
              lastLocation.latitude,
              lastLocation.longitude,
              newLocation.latitude,
              newLocation.longitude,
            );
            _totalDistance += distance;
          }
          _recordedLocations.add(LatLng(position.latitude, position.longitude));
          _updateMarkerPosition();
        }
      },
      onError: (error) => print("Error in location updates: $error"),
    );
  }

  //Stop location update when click on Stop Button
  void _stopLocationUpdates() {
    _positionStreamSubscription?.cancel();
  }

  //Get cuurent Location
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

  //Print all the coordinates from Survey Started to Stop
  void _printCoordinatesArray() {
    List<Map<String, double>> coordinatesArray = _recordedLocations.map((location) {
      return {'latitude': location.latitude, 'longitude': location.longitude};
    }).toList();
    print(coordinatesArray);
  }


  //Sending all the Coordinates to server
  Future<List<LatLng>> _sendCoordinatesToServer(List<LatLng> coordinates, String organizationId, String createdBy) async {
    final url = '$baseUrl$passAllCoordinatesEndPoint';
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      'organization_id': organizationId,
      'created_by': createdBy,
      'coordinates': coordinates.map((coord) => {
        'latitude': coord.latitude,
        'longitude': coord.longitude,
      }).toList(),
    });

    print('Sending coordinates to server...');
    print('URL: $url');
    print('Headers: $headers');
    print('Body: $body');

    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);
      print('Server responded with status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Parse the response body
        final responseBody = jsonDecode(response.body);

        // Assuming the response contains a list of coordinates within 'data'
        if (responseBody['data'] is List) {
          final updatedCoordinates = List<Map<String, dynamic>>.from(responseBody['data']);

          // Process the updated coordinates as needed
          print('Updated coordinates received from server: $updatedCoordinates');

          // Convert the updated coordinates to LatLng objects
          final List<LatLng> updatedLatLngCoordinates = updatedCoordinates.map((coord) {
            return LatLng(coord['latitude'], coord['longitude']);
          }).toList();

          return updatedLatLngCoordinates;
        } else {
          print('Failed to parse updated coordinates.');
          throw Exception('Failed to parse updated coordinates.');
        }
      } else {
        print('Failed to send coordinates. Status code: ${response.statusCode}');
        throw Exception('Failed to send coordinates. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending coordinates: $e');
      throw Exception('Error sending coordinates: $e');
    }
  }




  //Toggle Recording for pause and resume
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

  // Start Recording coordinates
  void _startRecording() {
    _recordedLocations.clear();
    _totalDistance = 0.0;
    totalDistance = "";
    if (_currentPosition != null) {
      _recordedLocations.add(LatLng(_currentPosition!.latitude, _currentPosition!.longitude));
    }
    _startLocationUpdates();
    _polylineTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updatePolylines();
      _storedPolylines.add(List.from(_polylines) as Polyline);
    });
  }

  // Pause Recording coordinates
  void _pauseRecording() {
    _stopLocationUpdates();
    _polylineTimer?.cancel();
    setState(() {
      _isPaused = true;
      _storedPolylines.addAll(_polylines);
      _polylines.clear();
    });
  }

  // Resume Recording coordinates
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

  // Toggle pause Recording Buttons
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

  // Stop Recording coordinates
  void _stopRecording() {
    _stopLocationUpdates();
    _polylineTimer?.cancel();
    setState(() {
      _isRecording = false; // Update _isRecording state to false
    });
    _printCoordinatesArray();
    totalDistance = 'Total Distance: ${(_totalDistance / 1000).toStringAsFixed(2)} km';
    print(totalDistance);
    _sendCoordinatesToServer(_recordedLocations, organizationId!, createBy!)
        .then((updatedLatLngCoordinates) {
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

  //Updating polylines on map (Red colour line)
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

  // Updating Polygons (not using currently)
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

  // Update Marker position (blue dot)
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

  // Fetch weather by current lat & long
  Future<void> fetchWeather(double latitude, double longitude) async {
    Weather? weather = await _wf.currentWeatherByLocation(latitude, longitude);
    if (weather != null) {
      setState(() {
        _weather = weather;
      });
    } else {
      print('Weather data not available.');
    }
  }

  // Fetch address by current lat & long
  Future<String?> fetchAddress(double latitude, double longitude) async {
    try {
      // Retrieve a list of placemarks for the provided coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

      // Check if any placemarks were found
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        // Construct the address string using available placemark properties
        String address = "${place.subThoroughfare ?? ''}, ${place.thoroughfare ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''} ${place.postalCode ?? ''}, ${place.country ?? ''}";

        // Remove leading comma and space if the first part of the address is empty
        address = address.trim().replaceAll(RegExp(r'^,\s*'), '');

        // Return the constructed address
        return address;
      } else {
        // Handle case where no placemarks were found
        print("No placemarks found for the provided coordinates.");
        return null;
      }
    } catch (e) {
      // Handle any errors that occur during the geocoding process
      print("Error fetching address: $e");
      return null; // Return null to indicate failure
    }
  }

  // Survey option dialog box (not using currently)
  void _showSurveyOptionsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Survey Paused'),
          content: const Text('Do you want to continue the survey or stop it?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _resumeRecording();
                setState(() {
                  _isSurveyStoppedDueToTicket = false;
                });
              },
              child: Text('Continue'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _isSurveyStoppedDueToTicket = false;
                  _isRecording = false;
                });
              },
              child: Text('Stop'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFF31363F),
      appBar: AppBar(
        title: const Text(
          'Gas Leakage Survey',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color(0xFFEFFF00),
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
                  borderRadius: const BorderRadius.only(
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

                // Live Distance During survey
                Positioned(
                  bottom: 80,
                  left: 65,
                  right: 65,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Total Distance: ${(_totalDistance / 1000).toStringAsFixed(2)} km',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                // Start Leakage Survey button
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
                    child: const Row(
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

                // Three buttons (Stop, Pause/Resume, Raise Ticket)
                Positioned(
                  bottom: 20,
                  left: 5,
                  right: 5,
                  child: Visibility(
                    visible: _isRecording,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Stop Button
                        Expanded(
                          // fit: FlexFit.tight,
                          flex: 4,
                          child: ElevatedButton.icon(
                            onPressed: _stopRecording,
                            icon: const Icon(Icons.stop, color: Colors.black,size: 22,),
                            label: const Text('Stop', style: TextStyle(color: Colors.black,fontSize: 14),
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
                        const SizedBox(width: 10),
                        // Pause/Resume Button
                        Expanded(
                          flex: 5,
                          child: ElevatedButton.icon(
                            onPressed: _togglePauseResume,
                            icon: Icon(
                              _isPaused ? Icons.play_arrow : Icons.pause,
                              color: Colors.black,
                              size: 23,
                            ),
                            label: Text(
                              _isPaused ? 'Resume' : 'Pause',
                              style: TextStyle(color: Colors.black,fontSize: 14),
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
                        SizedBox(width: 10),
                        // Raise ticket button
                        Expanded(
                          flex: 4,
                          child: ElevatedButton(
                            onPressed: () async {
                              selectedOptionArray.clear();
                              previewCompleted = false;
                              previewCompletedVideo = false;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RaiseTicketScreenOptions(
                                    isSurveyInProgress: true,
                                  ),
                                ),
                              );
                              _isPaused = true;
                              if (_currentPosition != null) {
                                double latitude = _currentPosition!.latitude;
                                double longitude = _currentPosition!.longitude;
                                coordinatesOfLeakagePoint = "$latitude $longitude";
                                print('Current Coordinates: Latitude: $latitude, Longitude: $longitude');

                                // Fetch address
                                String? address = await fetchAddress(latitude, longitude);
                                if (address != null) {
                                  print('Address: $address');
                                } else {
                                  print('Address not available.');
                                }
                                addressAsPerGoogle = address;
                                print(addressAsPerGoogle);

                                //Fetch Weather
                                await fetchWeather(latitude, longitude);
                                if (_weather != null) {
                                  windDirectionAndSpeed = "Wind Direction: ${_weather!.windDegree}° , Wind Speed: ${_weather!.windSpeed} m/s";
                                  weatherTemperature = "Weather: ${_weather!.weatherMain}, Temperature: ${_weather!.temperature?.celsius?.toStringAsFixed(2)}°C";
                                  print(windDirectionAndSpeed);
                                  print(weatherTemperature);
                                } else {
                                  print('Weather data not available.');
                                }
                              } else {
                                print('Current position not available.');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFEFFF00),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              minimumSize: Size(50, 50),
                            ),
                            child: const Text(
                              'Raise Ticket',
                              style: TextStyle(color: Colors.black, fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }
}
