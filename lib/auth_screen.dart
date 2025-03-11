import 'package:flutter/material.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'utils.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  String? verificationCode = "1";

  TwilioFlutter twilioFlutter = TwilioFlutter(
    accountSid: dotenv.env['ACC_SID'] ?? '',
    authToken: dotenv.env['TOKEN'] ?? '',
    twilioNumber: dotenv.env['NUMBER'] ?? '',
  );

  // Future<void> sendVerificationCode() async {
  //   String phoneNumber = _phoneController.text;
  //   verificationCode = generateVerificationCode(); // Génère un code aléatoire
  //   await twilioFlutter.sendSMS(
  //     toNumber: phoneNumber,
  //     messageBody: 'Votre code de vérification est : $verificationCode',
  //   );
  // }

  void verifyCode() {
    String enteredCode = _codeController.text;
    if (enteredCode == verificationCode) {
      // Le code est correct, naviguer vers HomeScreen
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Le code est incorrect, afficher un message d'erreur
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erreur'),
          content: Text('Le code de vérification est incorrect.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Authentification')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Numéro de téléphone'),
            ),
            TextField(
              controller: _codeController,
              decoration: InputDecoration(labelText: 'Code de vérification'),
            ),
            // ElevatedButton(
            //   onPressed: sendVerificationCode,
            //   child: Text('Envoyer le code'),
            // ),
            ElevatedButton(
              onPressed: verifyCode,
              child: Text('Vérifier le code'),
            ),
          ],
        ),
      ),
    );
  }
}
