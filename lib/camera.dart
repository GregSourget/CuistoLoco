import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';

class Camera extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<Camera> {
  CameraController? controller;
  List<CameraDescription>? cameras;
  final ImageLabeler _imageLabeler = ImageLabeler(options: ImageLabelerOptions());
  Map<String, int> foodDictionary = {};

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

  Future<void> _captureImage() async {
    if (controller != null && controller!.value.isInitialized) {
      try {
        final image = await controller!.takePicture();
        final inputImage = InputImage.fromFilePath(image.path);
        final labels = await _imageLabeler.processImage(inputImage);

        for (var label in labels) {
          final text = label.label;
          if (text.contains('food') || text.contains('aliment')) {
            foodDictionary[text] = (foodDictionary[text] ?? 0) + 1;
          }
        }

        print('Aliments détectés: $foodDictionary');
      } catch (e) {
        print('Erreur lors de la capture de l\'image: $e');
      }
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
      body: CameraPreview(controller!),
    );
  }
}
