import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';

class PixtralAPI {
  static String apiKey = dotenv.env['MISTRAL_KEY'] ?? '';
  static String model = 'pixtral-12b-2409';
  static String agentId = dotenv.env['PIXTRAL_AGENT'] ?? '';
  static String url = 'https://api.mistral.ai/v1/chat/completions';
  static String ingredients = '';

  static Future<void> captureAndSendImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image == null) {
      print('Aucune image sélectionnée.');
      return;
    }

    final File imageFile = File(image.path);
    final List<int> imageBytes = await imageFile.readAsBytes();
    final String base64Image = base64Encode(imageBytes);

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
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
                "text": "Dis-moi uniquement les ingrédients visibles sur cette image, séparés par des virgules, sans aucune phrase. Par exemple : bananes, pomme, fromage.",
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
      String responseMessage = data['choices'][0]['message']['content'];
      ingredients = utf8.decode(responseMessage.codeUnits);
      print('Ingrédients : $ingredients');
    } else {
      throw Exception('Erreur ${response.statusCode}: ${response.body}');
    }
  }
}
