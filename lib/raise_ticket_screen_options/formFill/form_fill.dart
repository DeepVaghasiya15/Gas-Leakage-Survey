import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:gas_leakage_survey/data/raise_ticket_data.dart';
import 'package:gas_leakage_survey/raise_ticket_screen_options/formFill/take_picture_screen.dart';
import 'package:gas_leakage_survey/raise_ticket_screen_options/formFill/take_video_screen.dart';
import 'package:gas_leakage_survey/screens/home_screen.dart';
import 'package:gas_leakage_survey/screens/login/login_screen_new.dart';
import '../../screens/raise_ticket_screen_options.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FormFill extends StatefulWidget {
  const FormFill({Key? key}) : super(key: key);

  @override
  State<FormFill> createState() => _FormFillState();
}

class _FormFillState extends State<FormFill> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  Map<String, String> selectedOptionsDictionary = {};
  late String token;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Define a GlobalKey

  final mainAreaController = TextEditingController();
  final subAreaController = TextEditingController();
  final dpIrFirstController = TextEditingController();
  final dpIrBarController = TextEditingController();
  final rmldFirstController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _controller = CameraController(firstCamera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    mainAreaController.dispose();
    subAreaController.dispose();
    dpIrFirstController.dispose();
    dpIrBarController.dispose();
    rmldFirstController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> createTicket(List<String> selectedOptionArray) async {
      try {
        String url = '$baseUrl$createTicketEndpoint';
        String typeOfLeak = selectedOptionArray[0];
        Map<String, dynamic> requestBody;

        if (typeOfLeak == 'Underground') {
          requestBody = {
            'token': tokenUser,
            'type_of_Leak': selectedOptionArray[0],
            'consumer_type': selectedOptionArray[1],
            'leak_first_detected_through': selectedOptionArray[2],
            'pipeline': selectedOptionArray[3],
            'pressure_of_pipeline': selectedOptionArray[4],
            'pipeline_distribution_type': selectedOptionArray[5],
            'diameter_of_pipeline': selectedOptionArray[6],
            'location_of_pipe': selectedOptionArray[7],
            'cover_of_pipeline': selectedOptionArray[8],
            'leak_grading': selectedOptionArray[9],
            'main_area': selectedOptionArray[10],
            'sub_area_location': selectedOptionArray[11],
            'dp_ir_reading_when_leak_detected_first': selectedOptionArray[12],
            'dp_ir_reading_using_bar_hole_probe': selectedOptionArray[13],
            'rmld_reading_when_leak_detected_first': selectedOptionArray[14],
            'photograph_of_location_point': photographOfLocationPoint,
            'video': video,
            'coordinates_of_the_leakage_point': coordinatesOfLeakagePoint,
            'address_as_per_google': addressAsPerGoogle,
            'wind_direction_and_speed': windDirectionAndSpeed,
            'weather_temperature': weatherTemperature,
            'organization_id': organizationId,
            'create_by': createBy,
            'assign_to': assignTo,
          };
          print('Form Fill $tokenUser');
        } else if (typeOfLeak == 'Aboveground') {
          requestBody = {
            'token': tokenUser,
            'type_of_Leak': selectedOptionArray[0],
            'consumer_type': selectedOptionArray[1],
            'leak_first_detected_through': selectedOptionArray[2],
            'pipeline': selectedOptionArray[3],
            'pressure_of_pipeline': selectedOptionArray[4],
            'pipeline_distribution_type': selectedOptionArray[5],
            'diameter_of_pipeline': selectedOptionArray[6],
            'source_of_leak': selectedOptionArray[7],
            'location_of_pipe': selectedOptionArray[8],
            'leak_grading': selectedOptionArray[9],
            'main_area': selectedOptionArray[10],
            'sub_area_location': selectedOptionArray[11],
            'dp_ir_reading_when_leak_detected_first': selectedOptionArray[12],
            'dp_ir_reading_using_bar_hole_probe': selectedOptionArray[13],
            'rmld_reading_when_leak_detected_first': selectedOptionArray[14],
            'photograph_of_location_point': photographOfLocationPoint,
            'video': video,
            'coordinates_of_the_leakage_point': coordinatesOfLeakagePoint,
            'address_as_per_google': addressAsPerGoogle,
            'wind_direction_and_speed': windDirectionAndSpeed,
            'weather_temperature': weatherTemperature,
            'organization_id': organizationId,
            'create_by': createBy,
            'assign_to': assignTo,
          };
          print('Form Fill $tokenUser');
          print('API Call: $url');
        } else {
          print('Invalid type_of_Leak: $typeOfLeak');
          return; // Stop execution if the type is invalid
        }

        final response = await http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(requestBody),
        );

        if (response.statusCode == 200) {
          print('Ticket created successfully');
        } else {
          print('Failed to create ticket. Server returned: ${response.body}');
        }
      } catch (e) {
        print('Error creating ticket: $e');
      }
    }

    return Scaffold(
      backgroundColor: Color(0xFF292C3D),
      appBar: AppBar(
        title: Text("Raise Ticket"),
        backgroundColor: Color(0xFFEFFF00),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (selectedOptionArray.isNotEmpty) {
              // Remove the last item from selectedOptionArray
              selectedOptionArray.removeLast();
              print(selectedOptionArray);
            }
            // Pop the current route from the navigation stack
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Fill this details..", // Replace with your text or use DataFields[0]
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: mainAreaController,
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white),
                  textCapitalization: TextCapitalization.characters,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[A-Z]')), // Allow only uppercase characters
                  ],
                  decoration: InputDecoration(
                    labelText: 'Main Area',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFEFFF00),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Main Area is required'; // Error message if field is empty
                    }
                    return null; // Return null if input is valid
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                //Sub Area / Location
                TextField(
                  controller: subAreaController,
                  cursorColor: Color(0xFF31363F),
                  style: TextStyle(color: Colors.white),
                  textCapitalization: TextCapitalization.characters,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[A-Z]')), // Allow only uppercase characters
                  ],
                  decoration: InputDecoration(
                    labelText: 'Sub Area / Location',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFEFFF00),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                //DP-IR Reading when leak detected first
                TextField(
                  controller: dpIrFirstController,
                  cursorColor: Color(0xFF31363F),
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'DP-IR Reading when leak detected first',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFEFFF00),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                //DP-IR Reading using Bar Hole probe
                TextField(
                  controller: dpIrBarController,
                  cursorColor: Color(0xFF31363F),
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'DP-IR Reading using Bar Hole probe',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFEFFF00),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: rmldFirstController,
                  cursorColor: Color(0xFF31363F),
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'RMLD Reading when leak detected first',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFEFFF00),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      icon: Icon(
                        previewCompleted ? Icons.done : Icons.photo,
                        color: Colors.black,
                      ),
                      label: Text(
                        previewCompleted ? 'Done' : 'Photo',
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            previewCompleted ? Colors.green : Color(0xFFEFFF00),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: Size(50, 50),
                      ),
                      onPressed: () {
                        if (!previewCompleted) {
                          HapticFeedback.vibrate();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TakePictureScreen(controller: _controller),
                            ),
                          ).then((value) {
                            setState(() {
                              // Set previewCompleted to true when popping back from the other screen
                              previewCompleted = true;
                            });
                          });
                        } else {
                          // Do whatever you want when the button is pressed after preview completion
                        }
                      },
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    ElevatedButton.icon(
                      icon: Icon(
                        previewCompletedVideo
                            ? Icons.done
                            : Icons.video_collection,
                        color: Colors.black,
                      ),
                      label: Text(
                        previewCompletedVideo ? 'Done' : 'Video',
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            previewCompletedVideo ? Colors.green : Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: Size(50, 50),
                      ),
                      onPressed: () {
                        if (!previewCompletedVideo) {
                          HapticFeedback.vibrate();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TakeVideoScreen(controller: _controller),
                            ),
                          ).then((value) {
                            setState(() {
                              // Set previewCompleted to true when popping back from the other screen
                              previewCompletedVideo = true;
                            });
                          });
                        } else {
                          // Do whatever you want when the button is pressed after preview completion
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    int count = 0;
                    if (_formKey.currentState!.validate()) {
                      HapticFeedback.vibrate();

                      selectedOptionArray.add(mainAreaController.text);
                      selectedOptionArray.add(subAreaController.text);
                      selectedOptionArray.add(dpIrFirstController.text);
                      selectedOptionArray.add(dpIrBarController.text);
                      selectedOptionArray.add(rmldFirstController.text);

                      // createTicket(selectedOptionArray as String);
                      print(selectedOptionArray);
                      createTicket(selectedOptionArray);

                      if (selectedOptionArray.isNotEmpty) {
                        if (selectedOptionArray[0] == 'Underground') {
                          selectedOptionsDictionary = {
                            'TypeOfLeak': selectedOptionArray[0],
                            'ConsumerType': selectedOptionArray[1],
                            'LeakFirstDetectedThrough': selectedOptionArray[2],
                            'Pipeline': selectedOptionArray[3],
                            'PressureOfPipeline': selectedOptionArray[4],
                            'PipelineDistributionType': selectedOptionArray[5],
                            'DiameterOfPipeline': selectedOptionArray[6],
                            'LocationOfPipe': selectedOptionArray[7],
                            'CoverOfPipeline': selectedOptionArray[8],
                            'LeakGrading': selectedOptionArray[9],
                            'MainArea': selectedOptionArray[10],
                            'SubArea': selectedOptionArray[11],
                            'DPIR-ReadingFirst': selectedOptionArray[12],
                            'DPIR-BarHole': selectedOptionArray[13],
                          };
                        } else {
                          selectedOptionsDictionary = {
                            'TypeOfLeak': selectedOptionArray[0],
                            'ConsumerType': selectedOptionArray[1],
                            'LeakFirstDetectedThrough': selectedOptionArray[2],
                            'Pipeline': selectedOptionArray[3],
                            'PressureOfPipeline': selectedOptionArray[4],
                            'PipelineDistributionType': selectedOptionArray[5],
                            'DiameterOfPipeline': selectedOptionArray[6],
                            'SourceOfLeak': selectedOptionArray[7],
                            'LocationOfPipe': selectedOptionArray[8],
                            'LeakGrading': selectedOptionArray[9],
                            'MainArea': selectedOptionArray[10],
                            'SubArea': selectedOptionArray[11],
                            'DPIR-ReadingFirst': selectedOptionArray[12],
                            'DPIR-BarHole': selectedOptionArray[13],
                          };
                        }
                      }

                      print(selectedOptionsDictionary);
                      Navigator.popUntil(context, (route) {
                        // Increment the counter when encountering a non-first route
                        if (!route.isFirst) {
                          count++;
                        }
                        return count == 12;
                      });
                      // Navigator.popUntil(context, ModalRoute.withName('/homescreen'));
                      String? windDirectionAndSpeed = "";
                      String? weatherTemperature = "";
                      String? addressAsPerGoogle = "";
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(fontSize: 24),
                    minimumSize: Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    backgroundColor: Color(0xFF1877F2),
                  ),
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
