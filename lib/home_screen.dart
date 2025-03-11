import 'package:flutter/material.dart';
import 'camera.dart'; // Assurez-vous d'importer le fichier camera_page.dart

class HomeScreen extends StatelessWidget {
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
              onPressed: () {
                // Naviguer vers la page de la caméra
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Camera()),
                );
              },
              child: Text('Ouvrir la caméra'),
            ),
          ],
        ),
      ),
    );
  }
}
