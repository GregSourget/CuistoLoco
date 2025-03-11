import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'pixtral_api.dart'; // Assurez-vous que le chemin est correct

class Camera extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<Camera> {
  CameraController? controller;
  List<CameraDescription>? cameras;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    if (cameras!.isNotEmpty) {
      controller = CameraController(cameras![0], ResolutionPreset.high);
      await controller?.initialize();
      setState(() {});
    } else {
      print('No cameras available');
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(title: Text('Camera')),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          CameraPreview(controller!),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                // Capture the image
                if (controller != null && controller!.value.isInitialized) {
                  try {
                    await controller!.takePicture();
                    await PixtralAPI.captureAndSendImage();
                  } catch (e) {
                    print('Error capturing image: $e');
                  }
                }
              },
              child: Text('Capture Image and Send to Pixtral'),
            ),
          ),
        ],
      ),
    );
  }
}
