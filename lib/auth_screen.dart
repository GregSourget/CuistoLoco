import 'package:flutter/material.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'utils.dart';
import 'home_screen.dart';
import 'register.dart';

class AuthScreen extends StatefulWidget {
  final String email;
  final String password;

  AuthScreen({required this.email, required this.password});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  String? verificationCode;

  TwilioFlutter twilioFlutter = TwilioFlutter(
    accountSid: dotenv.env['ACC_SID'] ?? '',
    authToken: dotenv.env['TOKEN'] ?? '',
    twilioNumber: dotenv.env['NUMBER'] ?? '',
  );

  Future<void> sendVerificationCode() async {
    String phoneNumber = _phoneController.text;
    verificationCode = generateVerificationCode(); // Génére un code aléatoire
    await twilioFlutter.sendSMS(
      toNumber: phoneNumber,
      messageBody: 'Votre code de vérification est : $verificationCode',
    );
  }

  void verifyCode() async{
    String enteredCode = _codeController.text;
    String phoneNumber = _phoneController.text;
    if (enteredCode == verificationCode) {
      createAccount(widget.email, widget.password, phoneNumber);
      // Le code est correct, naviguer vers HomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
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

  Future<void> createAccount(String email, String password, String phone) async {
    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
        data: {'phone': phone},
      );
      final user = response.user;
      if (user != null) {
        // 2️⃣ Ajouter le numéro de téléphone dans la table `profiles`
        await Supabase.instance.client.from('profiles').insert({
          'id': user.id,  // Associe le profil à l'utilisateur
          'phone': phone,
        });
        // Compte créé avec succès, naviguer vers HomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } catch (e) {
      // Gérer l'erreur ici
      print('Erreur lors de la création du compte: $e');
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
