import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'camera.dart'; // Assurez-vous d'importer le fichier camera.dart

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CameraDescription>? cameras;

  @override
  void initState() {
    super.initState();
    _initializeCameras();
  }

  Future<void> _initializeCameras() async {
    cameras = await availableCameras();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accueil'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Bienvenue sur la page d\'accueil !'),
            SizedBox(height: 20), // Espace entre le texte et le bouton
            ElevatedButton(
              onPressed: cameras != null && cameras!.isNotEmpty
                  ? () {
                // Naviguer vers la page de la caméra
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Camera(camera: cameras![0]),
                  ),
                );
              }
                  : null,
              child: Text('Ouvrir la caméra'),
            ),
          ],
        ),
      ),
    );
  }
}
