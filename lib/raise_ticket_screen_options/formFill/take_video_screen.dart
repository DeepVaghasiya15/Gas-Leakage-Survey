import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

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
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}