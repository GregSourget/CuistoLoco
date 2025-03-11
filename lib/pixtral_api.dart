import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';

class PixtralAPI {
  static String apiKey = dotenv.env['MISTRAL_KEY'] ?? '';
  static String model = 'pixtral-12b-2409';  // Assurez-vous que le modèle est valide
  static String agentId = dotenv.env['PIXTRAL_AGENT'] ?? '';
  static String url = 'https://api.mistral.ai/v1/chat/completions';

  // Méthode pour capturer l'image et envoyer la requête
  static Future<String> captureAndSendImage() async { // Changez ici Future<void> en Future<String>
    // Prendre une photo avec la caméra
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image == null) {
      print('Aucune image sélectionnée.');
      return ''; // Retourner une chaîne vide si aucune image n'est sélectionnée
    }

    // Lire l'image et l'encoder en base64
    final File imageFile = File(image.path);
    final List<int> imageBytes = await imageFile.readAsBytes();
    final String base64Image = base64Encode(imageBytes);

    // Construire le payload JSON avec l'image en base64
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
            "role": "user",
            "content": [
              {
                "type": "text",
                "text": "Dis-moi quelle nourriture tu vois sur cette image :",
              },
              {
                "type": "image_url",
                "image_url": "data:image/png;base64,$base64Image",
              }
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String responseMessage = data['choices'][0]['message']['content']; // Récupération du contenu de la réponse
      print('Réponse générée : $responseMessage');
      return responseMessage; // Retourne la réponse générée
    } else {
      throw Exception('Erreur ${response.statusCode}: ${response.body}');
    }
  }
}
