import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/raise_ticket_data.dart';
import 'form_fill.dart';
import 'package:firebase_storage/firebase_storage.dart';

bool previewCompleted = false;

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
                      PreviewScreen(imagePath: imagePath, videoPath: '', onPreviewComplete: (bool ) {},),
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
  void _onPreviewComplete(bool isCompleted) {
    setState(() {
      previewCompleted = isCompleted; // Set previewCompleted to true
    });
  }
}

class PreviewScreen extends StatelessWidget {
  final String imagePath;
  final Function(bool) onPreviewComplete;

  const PreviewScreen(
      {Key? key, required this.imagePath, required String videoPath, required this.onPreviewComplete,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    Future<String> uploadImage(File imageFile) async {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child("images/${DateTime.now().toString()}");
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
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
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return Center(
                        child: CircularProgressIndicator(), // Show loading indicator
                      );
                    },
                  );
                  try {
                    // Convert imagePath to File
                    File imageFile = File(imagePath);
                    // Upload image
                    String downloadUrl = await uploadImage(imageFile);
                    // Do something with downloadUrl, if needed
                    photographOfLocationPoint = downloadUrl;
                    // Navigate to the next screen or perform any other action
                    onPreviewComplete(true);
                    Navigator.popUntil(context, (route) {
                      if (!route.isFirst) {
                        countPhoto++;
                      }
                      return countPhoto == 4;
                    });
                    previewCompleted = true;
                  } catch (e) {
                    print('Error uploading image: $e');
                  }
                  // uploadImage(imagePath as File);
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