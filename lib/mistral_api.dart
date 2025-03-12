import 'package:http/http.dart' as http;
import 'dart:convert';
import 'pixtral_api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MistralAPI {
  static String apiKey = dotenv.env['MISTRAL_KEY'] ?? '';
  static String model = 'mistral-small-latest';
  static String agentId = dotenv.env['MISTRAL_AGENT'] ?? '';
  static String url = 'https://api.mistral.ai/v1/chat/completions';

  static Future<String> getSummary() async {
    if (PixtralAPI.ingredients.isEmpty) {
      throw Exception('Les ingrédients ne sont pas disponibles. Veuillez d\'abord capturer une image.');
    }

    final String prompt = "Je veux que ta reponse soit uniquement composé de la recette avec d'abord la liste des ingredients puis la recette mais tres concis, rédige moi une recette francaise avec ces ingredients : ${PixtralAPI.ingredients}";

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
        'Agent-ID': agentId,
      },
      body: jsonEncode({
        'model': model,
        'messages': [
          {
            'role': 'user',
            'content': prompt,
          },
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String recipe = data['choices'][0]['message']['content'];
      String recipe_utf8 = utf8.decode(recipe.codeUnits);
      print('Recette générée : $recipe_utf8');
      return recipe_utf8;
    } else {
      throw Exception('Erreur ${response.statusCode}: ${response.body}');
    }
  }
}
