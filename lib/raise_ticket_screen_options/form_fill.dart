import 'dart:async';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:gas_leakage_survey/data/raise_ticket_data.dart';
import 'package:gas_leakage_survey/screens/home_screen.dart';
import 'package:gas_leakage_survey/screens/login/login_screen_new.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import '../screens/raise_ticket_screen_options.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:firebase_storage/firebase_storage.dart';

bool previewCompleted = false;
// FirebaseStorage storage = FirebaseStorage.instance;

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

  final mainAreaController = TextEditingController();
  final subAreaController = TextEditingController();
  final dpIrFirstController = TextEditingController();
  final dpIrBarController = TextEditingController();
  final rmldFirstController = TextEditingController();

  // get http => null;

  @override
  void initState() {
    super.initState();
    initializeCamera();
    initializeToken();
  }
  void initializeToken() {
    // Initialize 'token'
    token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7Im5hbWUiOiJ0ZW1wIiwidXNlcl9pZCI6IjEyMyIsInJvbGUiOiJhZG1pbiIsIm9yZ2FuaXphdGlvbl9pZCI6IjEyMzM0NDMzNDMiLCJ0aW1lc3RhbXAiOjE3MTQxMTYzMDd9fQ.xB2HtV_i2oH4ZtWbZ1gW1OUq_BG7_vqx3cNe97ri-u4";
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
            // 'type_of_Leak': typeOfLeak,
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
            'dp_ir_reading_when_leak_detected_first' : selectedOptionArray[12],
            'dp_ir_reading_using_bar_hole_probe': selectedOptionArray[13],
            'rmld_reading_when_leak_detected_first': selectedOptionArray[14],
            'photograph_of_location_point': photographOfLocationPoint,
            'video': video,
            'coordinates_of_the_leakage_point': coordinatesOfLekagePoint,
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
            // 'type_of_Leak': typeOfLeak,
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
            'dp_ir_reading_when_leak_detected_first' : selectedOptionArray[12],
            'dp_ir_reading_using_bar_hole_probe': selectedOptionArray[13],
            'rmld_reading_when_leak_detected_first': selectedOptionArray[14],
            'photograph_of_location_point': photographOfLocationPoint,
            'video': video,
            'coordinates_of_the_leakage_point': coordinatesOfLekagePoint,
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
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Fill this details..", // Replace with your text or use DataFields[0]
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              SizedBox(height: 40),
              TextField(
                controller: mainAreaController,
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),
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
              ),
              const SizedBox(
                height: 10,
              ),
              //Sub Area / Location
              TextField(
                controller: subAreaController,
                cursorColor: Color(0xFF31363F),
                style: TextStyle(color: Colors.white),
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
                        );
                      } else {
                        // Do whatever you want when the button is pressed after preview completion
                      }
                    },
                  ),
                  SizedBox(width: 20),
                  ElevatedButton.icon(
                    icon: Icon(Icons.video_collection, color: Colors.black),
                    label: Text('Video',
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.center),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: Size(50, 50),
                    ),
                    onPressed: () {
                      HapticFeedback.vibrate();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TakeVideoScreen(controller: _controller),
                        ),
                      );
                    },
                  ),
                ],
              ),

              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  HapticFeedback.vibrate();
                  int count = 0;
                  // Submit logic here
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
                    // Return true when the counter reaches 2
                    return count == 11;
                  });
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
    );
  }
}

class TakePictureScreen extends StatefulWidget {
  final CameraController controller;

  const TakePictureScreen({Key? key, required this.controller})
      : super(key: key);

  @override
  _TakePictureScreenState createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreen> {
  late String imagePath = '';

  @override
  Widget build(BuildContext context) {
    if (!widget.controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      backgroundColor: Color(0xFF292C3D),
      appBar: AppBar(
        title: Text('Take a picture'),
        backgroundColor: Color(0xFFEFFF00),
      ),
      body: CameraPreview(widget.controller),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 30.0),
        child: IconButton(
          icon: Icon(
            Icons.camera,
            color: Colors.white,
            size: 50,
          ),
          onPressed: () async {
            HapticFeedback.vibrate();
            try {
              final image = await widget.controller.takePicture();
              setState(() {
                imagePath = image.path;
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PreviewScreen(imagePath: imagePath, videoPath: ''),
                ),
              );
            } catch (e) {
              print('Error taking picture: $e');
            }
          },
        ),
      ),
    );
  }
}

class PreviewScreen extends StatelessWidget {
  final String imagePath;

  const PreviewScreen(
      {Key? key, required this.imagePath, required String videoPath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    Future<void> uploadImageToFirebase(String imagePath) async {
      print('Image Path $imagePath');
      // await Firebase.initializeApp();
      try {
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference ref = storage.ref().child('photos').child('image.jpg');
        UploadTask uploadTask = ref.putFile(File(imagePath));
        await uploadTask.whenComplete(() => print('Image uploaded to Firebase'));
      } catch (e) {
        print('Error uploading image to Firebase: $e');
      }
    }

    return Scaffold(
      backgroundColor: Color(0xFF292C3D),
      appBar: AppBar(
        title: Text(
          'Preview Image',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF292C3D),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.file(File(imagePath)),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  // Retake the picture
                  Navigator.pop(context);
                },
                icon: Icon(Icons.refresh, color: Colors.black),
                label: Text(
                  'Take Again',
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: Size(50, 50),
                ),
              ),
              SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: () async {
                  int countPhoto = 0;
                  previewCompleted = true;
                  uploadImageToFirebase(imagePath);
                  print('Image is uploaded to firebase: $uploadImageToFirebase(imagePath)');
                  Navigator.popUntil(context, (route) {
                    if (!route.isFirst) {
                      countPhoto++;
                    }
                    return countPhoto == 3;
                  });
                },
                icon: Icon(Icons.check, color: Colors.black),
                label: Text(
                  'Proceed',
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: Size(50, 50),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}

class TakeVideoScreen extends StatefulWidget {
  final CameraController controller;

  const TakeVideoScreen({Key? key, required this.controller}) : super(key: key);

  @override
  _TakeVideoScreenState createState() => _TakeVideoScreenState();
}

class _TakeVideoScreenState extends State<TakeVideoScreen> {
  bool isRecording = false;
  String videoPath = '';
  int recordingTimeSeconds = 0;
  late Timer recordingTimer;
  bool isRed = false;

  @override
  void initState() {
    super.initState();
    // Initialize the recording timer
    recordingTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (isRecording) {
        setState(() {
          recordingTimeSeconds++;
        });
      }
    });
    widget.controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF292C3D),
      appBar: AppBar(
        title: Text('Record a video'),
        backgroundColor: Color(0xFFEFFF00),
      ),
      body: Column(
        children: [
          Expanded(child: CameraPreview(widget.controller)),
          SizedBox(height: 20),
          Text(
            'Recording : ${_formatTime(recordingTimeSeconds)}',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              HapticFeedback.vibrate();
              if (!isRecording) {
                try {
                  await widget.controller.startVideoRecording();
                  setState(() {
                    isRecording = true;
                    recordingTimeSeconds =
                        0; // Reset recording time when starting a new recording
                  });
                } catch (e) {
                  print('Error starting video recording: $e');
                }
              } else {
                try {
                  final XFile recordedVideo =
                      await widget.controller.stopVideoRecording();
                  print(
                      'Stop video recording result: ${recordedVideo.path}'); // Debugging statement
                  setState(() {
                    videoPath = recordedVideo.path;
                    isRecording = false;
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PreviewScreen2(
                          videoFile: recordedVideo,
                          controller: widget.controller),
                    ),
                  );
                } catch (e) {
                  print('Error stopping video recording: $e');
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isRecording ? Colors.red : Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: Size(40, 40),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                isRecording ? 'Stop Recording' : 'Start Recording',
                style: TextStyle(
                  fontSize: 18.0, // Set text size
                  fontWeight: FontWeight.bold, // Set text weight
                  color: Colors.black, // Set text color
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    // Format the time as HH:MM:SS
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$hours:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}

class PreviewScreen2 extends StatefulWidget {
  final XFile videoFile;
  final CameraController controller;

  const PreviewScreen2(
      {Key? key, required this.videoFile, required this.controller})
      : super(key: key);

  @override
  _PreviewScreen2State createState() => _PreviewScreen2State();
}

class _PreviewScreen2State extends State<PreviewScreen2> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoFile.path))
      ..initialize().then((_) {
        setState(() {}); // Ensure the video is initialized and start playing
        _controller.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF292C3D),
      appBar: AppBar(
        title: Text(
          'Preview Video',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF292C3D),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : CircularProgressIndicator(), // Show a loader until video is initialized
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(
                        context); // Navigate back to the recording screen
                  },
                  icon: Icon(Icons.refresh, color: Colors.black),
                  label: Text(
                    'Record Again',
                    style: TextStyle(color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size(50, 50),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    int countVideo = 0;
                    Navigator.popUntil(context, (route) {
                      if (!route.isFirst) {
                        countVideo++;
                      }
                      return countVideo == 3;
                    });
                  },
                  icon: Icon(Icons.check, color: Colors.black),
                  label: Text(
                    'Proceed',
                    style: TextStyle(color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size(50, 50),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
