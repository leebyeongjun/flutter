import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';

class ShootingPage extends StatefulWidget {
  @override
  _ShootingPageState createState() => _ShootingPageState();
}

class _ShootingPageState extends State<ShootingPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  XFile? _capturedImage; // 촬영된 이미지를 저장할 변수 추가

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
        title: Text(''),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _capturedImage != null
                ? Image.file(File(_capturedImage!.path)) // 촬영된 이미지를 표시
                : CameraPreview(_controller); // 카메라 미리보기 표시
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
                  _capturedImage = image; // 촬영된 이미지 저장
                });
                print('사진이 성공적으로 촬영되었습니다.');
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