import 'package:flutter/material.dart';
import 'pixtral_api.dart';

class FridgeScreen extends StatelessWidget {
  // Résumé des ingrédients séparés par des virgules
  List<String> getIngredients() {
    if (PixtralAPI.ingredients.isEmpty) {
      return ['Votre frigo est vide.'];
    }

    // Utilisation d'une regex pour séparer les ingrédients par des virgules
    final List<String> ingredientsList = PixtralAPI.ingredients
        .split(',')
        .map((ingredient) => ingredient.trim()) // Supprimer les espaces inutiles autour de chaque ingrédient
        .toList();

    return ingredientsList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Frigo'),
        automaticallyImplyLeading: false,
      ),
      body: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: getIngredients().map((ingredient) {
              return Text(
                ingredient,
                style: TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
