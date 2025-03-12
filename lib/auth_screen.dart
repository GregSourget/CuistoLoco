import 'package:flutter/material.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'utils.dart';
import 'bottom_navigation.dart';

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
    if (isValidPhoneNumber(phoneNumber)) {
      verificationCode = generateVerificationCode();
      await twilioFlutter.sendSMS(
        toNumber: phoneNumber,
        messageBody: 'Votre code de vérification est : $verificationCode',
      );
    }
    else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erreur'),
          content: Text('Veuillez saisir un numéro de téléphone valide.'),
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

  void verifyCode() async{
    String enteredCode = _codeController.text;
    String phoneNumber = _phoneController.text;
    if (enteredCode == verificationCode) {
      createAccount(widget.email, widget.password, phoneNumber);
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

  Future<void> createAccount(String email, String password, String phone) async {
    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
        data: {'phone': phone},
      );
      final user = response.user;
      if (user != null) {
        // Ajouter le numéro de téléphone dans la table `profiles`
        await Supabase.instance.client.from('profiles').insert({
          'id': user.id,
          'phone': phone,
        });
        // Compte créé
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNavigation()),
        );
      }
    } catch (e) {
      // Gérer les erreurs du try
      print('Erreur lors de la création du compte: $e');
    }
  }

  bool isValidPhoneNumber(String phoneNumber) {
    final phoneRegExp = RegExp(
      r'^\+?[1-9]\d{1,14}$',
    );
    return phoneRegExp.hasMatch(phoneNumber);
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
            SizedBox(height: 20),
            TextField(
              controller: _codeController,
              decoration: InputDecoration(labelText: 'Code de vérification'),
            ),
            SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
        Expanded(
        child: ElevatedButton(
        onPressed: sendVerificationCode,
          child: Text('Envoyer le code'),
        ),
      ),
      SizedBox(width: 10), // Espace entre les boutons
      Expanded(
        child: ElevatedButton(
          onPressed: verifyCode,
          child: Text('Vérifier le code'),
          )
        )],
        ),
      ]),
      )
    );
  }
}
