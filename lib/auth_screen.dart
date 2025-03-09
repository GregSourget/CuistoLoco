import 'package:flutter/material.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
import 'utils.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  String? verificationCode;

  TwilioFlutter twilioFlutter = TwilioFlutter(
    accountSid: 'AC2df89184d36e6ce345e046870406f1f2',
    authToken: 'b64e87add6eb6f8870645971731162ed',
    twilioNumber: '+18284265553',
  );

  Future<void> sendVerificationCode() async {
    String phoneNumber = _phoneController.text;
    verificationCode = generateVerificationCode(); // Générez un code aléatoire
    await twilioFlutter.sendSMS(
      toNumber: phoneNumber,
      messageBody: 'Votre code de vérification est : $verificationCode',
    );
  }

  void verifyCode() {
    String enteredCode = _codeController.text;
    if (enteredCode == verificationCode) {
      // Le code est correct
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Succès'),
          content: Text('Le code de vérification est correct.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // Le code est incorrect
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
            ElevatedButton(
              onPressed: sendVerificationCode,
              child: Text('Envoyer le code'),
            ),
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