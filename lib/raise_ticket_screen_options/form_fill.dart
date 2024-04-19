import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:gas_leakage_survey/screens/home_screen.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';


class FormFill extends StatefulWidget {
  const FormFill({Key? key}) : super(key: key);

  @override
  State<FormFill> createState() => _FormFillState();
}

class _FormFillState extends State<FormFill> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();
    // Get the first camera from the list.
    final firstCamera = cameras.first;
    // Initialize the controller
    _controller = CameraController(firstCamera, ResolutionPreset.medium);
    // Next, initialize the controller. This returns a Future
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Raise Ticket"),backgroundColor: Color(0xFFFFC604),),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Fill this details..", // Replace with your text or use DataFields[0]
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 40),
              TextField(
                cursorColor: Color(0xFF31363F),
                decoration: InputDecoration(
                  labelText: 'Main Area',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFFFC604),
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
                cursorColor: Color(0xFF31363F),
                decoration: InputDecoration(
                  labelText: 'Sub Area / Location',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFFFC604),
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
                cursorColor: Color(0xFF31363F),
                decoration: InputDecoration(
                  labelText: 'DP-IR Reading when leak detected first',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFFFC604),
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
                cursorColor: Color(0xFF31363F),
                decoration: InputDecoration(
                  labelText: 'DP-IR Reading using Bar Hole probe',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFFFC604),
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
                    icon: Icon(Icons.photo, color: Colors.black),
                    label: Text('Photo', style: TextStyle(color: Colors.black), textAlign: TextAlign.center),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFC604),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: Size(50, 50),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TakePictureScreen(controller: _controller),
                        ),
                      );
                    },
                  ),
                  SizedBox(width: 20),
                  ElevatedButton.icon(
                    icon: Icon(Icons.video_collection, color: Colors.black),
                    label: Text('Video', style: TextStyle(color: Colors.black), textAlign: TextAlign.center),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: Size(50, 50),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TakeVideoScreen(controller: _controller),
                        ),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  // Submit logic here
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

  const TakePictureScreen({Key? key, required this.controller}) : super(key: key);

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
      appBar: AppBar(
        title: Text('Take a picture'),
        backgroundColor: Color(0xFFFFC604),
      ),
      body: CameraPreview(widget.controller),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 30.0),
        child: IconButton(
          icon: Icon(Icons.camera,size: 50,),
          onPressed: () async {
            try {
              final image = await widget.controller.takePicture();
              setState(() {
                imagePath = image.path;
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PreviewScreen(imagePath: imagePath, videoPath: ''),
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

  const PreviewScreen({Key? key, required this.imagePath, required String videoPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Preview Image')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.file(File(imagePath)),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Proceed with the taken picture
                },
                child: Text('Use this'),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  // Retake the picture
                  Navigator.pop(context);
                },
                child: Text('Take again'),
              ),
            ],
          ),
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
  }

  @override
  void dispose() {
    // Dispose the recording timer
    recordingTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Record a video'),backgroundColor: Color(0xFFFFC604),),
      body: Column(
        children: [
          Expanded(child: CameraPreview(widget.controller)),
          SizedBox(height: 20),
          Text(
            'Recording Time: ${_formatTime(recordingTimeSeconds)}',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (!isRecording) {
                try {
                  await widget.controller.startVideoRecording();
                  setState(() {
                    isRecording = true;
                    recordingTimeSeconds = 0; // Reset recording time when starting a new recording
                  }
                  );
                } catch (e) {
                  print('Error starting video recording: $e');
                }
              } else {
                try {
                  final path = await widget.controller.stopVideoRecording();
                  print('Stop video recording result: $path'); // Debugging statement
                  setState(() {
                    videoPath = path as String;
                    isRecording = false;
                  });
                  // Navigate to the preview screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PreviewScreen(videoPath: videoPath, imagePath: '',),
                    ),
                  );
                } catch (e) {
                  print('Error stopping video recording: $e');
                }
              }
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                // Set different background colors for different states
                if (states.contains(MaterialState.pressed)) {
                  return Colors.red; // Color when pressed
                }
                return Colors.red; // Default color
              }),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
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
          SizedBox(height: 20,)
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

class PreviewScreen2 extends StatelessWidget {
  final String videoPath;

  const PreviewScreen2({Key? key, required this.videoPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Preview')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Preview Video Here'),
            VideoPlayer(VideoPlayerController.file(File(videoPath))),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Proceed with the recorded video
              },
              child: Text('Proceed'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Navigate back to the recording screen
              },
              child: Text('Record Again'),
            ),
          ],
        ),
      ),
    );
  }
}
