import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../../data/raise_ticket_data.dart';

bool previewCompletedVideo = false;

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
  static const int maxRecordingTime = 10;

  @override
  void initState() {
    super.initState();
    // Automatically stops recording at 10 seconds
    recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isRecording) {
        setState(() {
          recordingTimeSeconds++;
          if (recordingTimeSeconds >= maxRecordingTime) {
            stopRecording();
          }
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
  void dispose() {
    super.dispose();
    widget.controller.dispose();
    recordingTimer.cancel();
  }

  // Stop recording
  void stopRecording() async {
    try {
      final XFile recordedVideo = await widget.controller.stopVideoRecording();
      print('Stop video recording result: ${recordedVideo.path}');
      setState(() {
        videoPath = recordedVideo.path;
        isRecording = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PreviewScreen2(
            videoFile: recordedVideo,
            controller: widget.controller,
          ),
        ),
      );
    } catch (e) {
      print('Error stopping video recording: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF292C3D),
      appBar: AppBar(
        title: const Text('Record a video'),
        backgroundColor: const Color(0xFFEFFF00),
      ),
      body: Column(
        children: [
          Expanded(child: CameraPreview(widget.controller)),
          const SizedBox(height: 20),
          // Recording time
          Text(
            'Recording : ${_formatTime(recordingTimeSeconds)}',
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              HapticFeedback.vibrate();
              if (!isRecording) {
                try {
                  await widget.controller.startVideoRecording();
                  setState(() {
                    isRecording = true;
                    recordingTimeSeconds = 0;
                  });
                } catch (e) {
                  print('Error starting video recording: $e');
                }
              } else {
                stopRecording();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isRecording ? Colors.red : Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: const Size(40, 40),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                isRecording ? 'Stop Recording' : 'Start Recording',
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  // Format time
  String _formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$hours:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}

class PreviewScreen2 extends StatefulWidget {
  final XFile videoFile;
  final CameraController controller;

  const PreviewScreen2({Key? key, required this.videoFile, required this.controller}) : super(key: key);

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
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Upload video to firebase
    Future<String> uploadVideo(File file) async {
      try {
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference ref = storage.ref().child("video/${DateTime.now().toString()}");
        UploadTask uploadTask = ref.putFile(file);
        TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
        String downloadUrl = await snapshot.ref.getDownloadURL();
        return downloadUrl;
      } catch (e) {
        print('Error uploading file: $e');
        throw e;
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFF292C3D),
      appBar: AppBar(
        title: const Text(
          'Preview Video',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF292C3D),
        iconTheme: const IconThemeData(color: Colors.white),
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
                : const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.refresh, color: Colors.black),
                  label: const Text(
                    'Record Again',
                    style: TextStyle(color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(50, 50),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    int countVideo = 0;
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    );
                    try {
                      File file = File(widget.videoFile.path);
                      String downloadUrl = await uploadVideo(file);
                      print('Uploaded file URL: $downloadUrl');
                      video = downloadUrl;
                      Navigator.popUntil(context, (route) {
                        if (!route.isFirst) {
                          countVideo++;
                        }
                        return countVideo == 4;
                      });
                      previewCompletedVideo = true;
                    } catch (e) {
                      print('Error uploading file: $e');
                    }
                  },
                  icon: const Icon(Icons.check, color: Colors.black),
                  label: const Text(
                    'Proceed',
                    style: TextStyle(color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(50, 50),
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
