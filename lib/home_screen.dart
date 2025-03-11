import 'package:flutter/material.dart';
import 'camera.dart';
import 'mistral_api.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Accueil')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Bienvenue sur la page d\'accueil !'),
            SizedBox(height: 20), // Espace entre le texte et les boutons
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
            SizedBox(height: 20), // Espace entre les deux boutons
            ElevatedButton(
              onPressed: () async {
                // Appel de la fonction pour générer une recette
                String result = await MistralAPI.getSummary();

                // Afficher la recette générée dans le terminal
                print(result); // Imprimer la réponse dans le terminal
              },
              child: Text('Générer une recette'),
            ),
          ],
        ),
      ),
    );
  }
}
