import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'enroll_page.dart';

class ShootingPage extends StatefulWidget {
  @override
  _ShootingPageState createState() => _ShootingPageState();
}

class _ShootingPageState extends State<ShootingPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  XFile? _capturedImage;

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final backCamera = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.back,
      );
      _controller = CameraController(
        backCamera,
        ResolutionPreset.medium,
      );
      await _controller.initialize();
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shooting Page'),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _capturedImage != null
                ? Image.file(File(_capturedImage!.path))
                : CameraPreview(_controller);
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: SizedBox(
          width: 50,
          height: 50,
          child: FloatingActionButton(
            onPressed: () async {
              try {
                await _initializeControllerFuture;
                final XFile image = await _controller.takePicture();
                setState(() {
                  _capturedImage = image;
                });
                print('Photo taken successfully.');
                // 이미지를 EnrollPage로 전달
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EnrollPage(imagePath: _capturedImage!.path),
                  ),
                );
              } catch (e) {
                print('Error taking picture: $e');
              }
            },
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            child: Icon(Icons.camera),
          ),
        ),
      ),
    );
  }
}