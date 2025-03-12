import 'package:flutter/material.dart';
import 'pixtral_api.dart';
import 'mistral_api.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _recipe = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Accueil')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Bienvenue sur la page d'accueil !"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  await PixtralAPI.captureAndSendImage();
                  print('Ingrédients mis à jour : ${PixtralAPI.ingredients}');
                } catch (e) {
                  print('Erreur lors de la capture de l\'image : $e');
                }
              },
              child: Text("Ouvrir la caméra et envoyer l'image"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  if (PixtralAPI.ingredients.isEmpty) {
                    throw Exception('Les ingrédients ne sont pas disponibles. Veuillez d\'abord capturer une image.');
                  }

                  String result = await MistralAPI.getSummary();
                  setState(() {
                    _recipe = result;
                  });
                } catch (e) {
                  print('Erreur lors de la génération de la recette : $e');
                }
              },
              child: Text('Générer une recette'),
            ),
            SizedBox(height: 20),
            if (_recipe.isNotEmpty)
              Text(
                _recipe,
                style: TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}