import 'package:flutter/material.dart';
import 'camera.dart';  // Cette importation peut ne plus être nécessaire
import 'pixtral_api.dart';
import 'mistral_api.dart';// Assurez-vous d'importer PixtralAPI

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
              onPressed: () async {
                // Appeler la méthode captureAndSendImage de PixtralAPI
                await PixtralAPI.captureAndSendImage();
              },
              child: Text('Ouvrir la caméra et envoyer l\'image'),
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
