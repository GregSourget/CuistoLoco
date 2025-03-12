import 'package:flutter/material.dart';
import 'pixtral_api.dart';
import 'mistral_api.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _recipe = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accueil'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Bienvenue sur la page d'accueil !",
              style: TextStyle(fontSize: 20),
            ),
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
              child: Text(
                "Scanner votre frigo",
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (PixtralAPI.ingredients.isEmpty) {
                  print('Les ingrédients ne sont pas disponibles.');
                  return;
                }

                setState(() {
                  isLoading = true;
                });

                try {
                  String result = await MistralAPI.getSummary();
                  setState(() {
                    _recipe = result;
                    isLoading = false;
                  });
                } catch (e) {
                  setState(() {
                    isLoading = false;
                  });
                  print('Erreur lors de la génération de la recette : $e');
                }
              },
              child: Text(
                'Générer une recette',
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: 20),
            if (isLoading)
              Center(child: CircularProgressIndicator()),
            if (!_recipe.isEmpty && !isLoading)
              Text(
                _recipe,
                style: TextStyle(fontSize: 20),
              ),
          ],
        ),
      ),
    );
  }
}
