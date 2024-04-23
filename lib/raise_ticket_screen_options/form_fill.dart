import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:gas_leakage_survey/screens/home_screen.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

import '../screens/raise_ticket_screen_options.dart';

class FormFill extends StatefulWidget {
  const FormFill({Key? key}) : super(key: key);

  @override
  State<FormFill> createState() => _FormFillState();
}

class _FormFillState extends State<FormFill> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  Map<String, String> selectedOptionsDictionary = {};

  final mainAreaController = TextEditingController();
  final subAreaController = TextEditingController();
  final dpIrFirstController = TextEditingController();
  final dpIrBarController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _controller = CameraController(firstCamera, ResolutionPreset.high);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    mainAreaController.dispose();
    subAreaController.dispose();
    dpIrFirstController.dispose();
    dpIrBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 20),
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
                cursorColor: Color(0xFF31363F),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    icon: Icon(Icons.photo, color: Colors.black),
                    label: Text('Photo',
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.center),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFEFFF00),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: Size(50, 50),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TakePictureScreen(controller: _controller),
                        ),
                      );
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
                  int count = 0;
                  // Submit logic here
                  selectedOptionArray.add(mainAreaController.text);
                  selectedOptionArray.add(subAreaController.text);
                  selectedOptionArray.add(dpIrFirstController.text);
                  selectedOptionArray.add(dpIrBarController.text);

                  print(selectedOptionArray);

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
                    return count == 12;
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
                onPressed: () {
                  int countPhoto = 0;
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
