import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MistralAPI {
  static String apiKey = dotenv.env['MISTRAL_KEY'] ?? '';
  static String model = 'mistral-small-latest';
  static String agentId = dotenv.env['MISTRAL_AGENT'] ?? '';
  static String url = 'https://api.mistral.ai/v1/chat/completions';

  static Future<String> getSummary() async {
    final String prompt = "le nom d'une seule recette française aux pommes de terre";

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
      String recipe = data['choices'][0]['message']['content']; // Récupération du contenu de la réponse
      print('Recette générée : $recipe');
      return recipe; // Retourne la recette générée
    } else {
      throw Exception('Erreur ${response.statusCode}: ${response.body}');
    }
  }
}
