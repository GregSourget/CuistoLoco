import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;

class Camera extends StatefulWidget {
  final CameraDescription camera;
  const Camera({Key? key, required this.camera}) : super(key: key);
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<Camera> {
  CameraController? controller;
  bool _isDetecting = false;
  final String apiKey = 'AIzaSyAGJ82vv7lParZ0-8rJUxUePK9l_dSzGFk'; // Remplacez par votre clé API

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    controller = CameraController(widget.camera, ResolutionPreset.high);
    await controller?.initialize();
    setState(() {});
  }

  Future<void> _captureImage() async {
    if (controller != null && controller!.value.isInitialized) {
      setState(() {
        _isDetecting = true;
      });

      try {
        final image = await controller!.takePicture();
        final file = File(image.path);
        final bytes = await file.readAsBytes();
        final base64Image = base64Encode(bytes);

        final response = await http.post(
          Uri.parse('https://vision.googleapis.com/v1/images:annotate?key=$apiKey'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'requests': [
              {
                'image': {'content': base64Image},
                'features': [{'type': 'OBJECT_LOCALIZATION', 'maxResults': 5}],
              }
            ]
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final objects = data['responses'][0]['localizedObjectAnnotations'];
          print('Objets détectés: $objects');
        } else {
          print('Erreur: ${response.statusCode}');
        }
      } catch (e) {
        print('Erreur lors de la capture de l\'image: $e');
      } finally {
        setState(() {
          _isDetecting = false;
        });
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
      floatingActionButton: FloatingActionButton(
        onPressed: _captureImage,
        child: Icon(Icons.camera),
      ),
    );
  }
}
