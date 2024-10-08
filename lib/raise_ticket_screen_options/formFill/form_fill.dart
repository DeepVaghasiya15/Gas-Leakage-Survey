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

  // Controller of all TextField
  final mainAreaController = TextEditingController();
  final subAreaController = TextEditingController();
  final dpIrFirstController = TextEditingController();
  final dpIrBarController = TextEditingController();
  final rmldFirstController = TextEditingController();

  // bool previewCompleted = false; // Flag for photo completion
  // bool previewCompletedVideo = false; // Flag for video completion
  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  // Initialize camera
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
    // Create ticket and send data to backend
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
        title: const Text("Raise Ticket"),
        backgroundColor: Color(0xFFEFFF00),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
                // Main Area
                TextFormField(
                  controller: mainAreaController,
                  cursorColor: Colors.white,
                  style: const TextStyle(color: Colors.white),
                  textCapitalization: TextCapitalization.characters,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9 ]')), // Allow uppercase characters, numbers, and spaces
                  ],
                  decoration: InputDecoration(
                    labelText: 'Main Area',
                    labelStyle: const TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0xFFEFFF00),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0), // Add padding here
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
                  cursorColor: const Color(0xFF31363F),
                  style: const TextStyle(color: Colors.white),
                  textCapitalization: TextCapitalization.characters,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9 ]')), // Allow only uppercase characters
                  ],
                  decoration: InputDecoration(
                    labelText: 'Sub Area / Location',
                    labelStyle: const TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
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
                  keyboardType: TextInputType.number,
                  cursorColor: const Color(0xFF31363F),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'DP-IR Reading when leak detected first',
                    labelStyle: const TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
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
                  keyboardType: TextInputType.number,
                  cursorColor: const Color(0xFF31363F),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'DP-IR Reading using Bar Hole probe',
                    labelStyle: const TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:const  BorderSide(
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
                // RMLD Reading when leak detected first
                TextField(
                  controller: rmldFirstController,
                  keyboardType: TextInputType.number,
                  cursorColor:const  Color(0xFF31363F),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'RMLD Reading when leak detected first',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
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
                    // Photo Button
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
                              // previewCompleted = false;
                            });
                          });
                        } else {
                          // Do whatever you want when the button is pressed after preview completion
                        }
                      },
                    ),
                    const SizedBox(
                      width: 20,
                    ),

                    // Video Button
                    ElevatedButton.icon(
                      icon: Icon(
                        previewCompletedVideo
                            ? Icons.done
                            : Icons.video_collection,
                        color: Colors.black,
                      ),
                      label: Text(
                        previewCompletedVideo ? 'Done' : 'Video',
                        style: const TextStyle(color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            previewCompletedVideo ? Colors.green : Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size(50, 50),
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
                              // previewCompletedVideo = false;
                            });
                          });
                        } else {
                          // Do whatever you want when the button is pressed after preview completion
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Submit button
                ElevatedButton(
                  onPressed: () async {
                    int count = 0;
                    if (_formKey.currentState!.validate()) {
                      if (previewCompleted && previewCompletedVideo) {
                        HapticFeedback.vibrate();

                        // Adding details to selectedOptionArray which is written in TextField
                        selectedOptionArray.add(mainAreaController.text);
                        selectedOptionArray.add(subAreaController.text);
                        selectedOptionArray.add(dpIrFirstController.text);
                        selectedOptionArray.add(dpIrBarController.text);
                        selectedOptionArray.add(rmldFirstController.text);

                        print(selectedOptionArray);
                        await createTicket(selectedOptionArray);

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
                              'RMLD-ReadingFirst': selectedOptionArray[14],
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
                              'RMLD-ReadingFirst': selectedOptionArray[14],
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
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please take both a photo and a video before submitting.'),
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 24),
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    backgroundColor: const Color(0xFF1877F2),
                  ),
                  child: const Text(
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
