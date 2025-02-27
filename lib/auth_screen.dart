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

  TwilioFlutter twilioFlutter = TwilioFlutter(
    accountSid: 'votre_account_sid',
    authToken: 'votre_auth_token',
    twilioNumber: 'votre_numero_twilio',
  );

  Future<void> sendVerificationCode() async {
    String phoneNumber = _phoneController.text;
    String verificationCode = generateVerificationCode(); // Générez un code aléatoire
    await twilioFlutter.sendSMS(
      toNumber: phoneNumber,
      messageBody: 'Votre code de vérification est : $verificationCode',
    );
  }

  void verifyCode() {
    String enteredCode = _codeController.text;
    // Vérifiez le code ici
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