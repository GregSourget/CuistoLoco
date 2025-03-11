import 'package:flutter/material.dart';
import 'auth_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void navigateToAuthScreen() {
    String email = _emailController.text;
    String password = _passwordController.text;

    // Vous pouvez ajouter une validation ici pour vérifier que l'email et le mot de passe sont valides
    if (email.isNotEmpty && isValidEmail(email) && password.isNotEmpty  && isValidPassword(password)) {
    // Naviguer vers l'écran d'authentification
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AuthScreen(email: email, password: password),
      ),
    );
  }else {
      // Afficher un message d'erreur si les champs sont vides
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erreur'),
          content: Text('Veuillez remplir tous les champs correctements (mdp > 6 charactères).'),
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

  bool isValidEmail(String email) {
    // Expression régulière pour valider un email
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegExp.hasMatch(email);
  }

  bool isValidPassword(String password) {
    return password.length >= 6;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Enregistrement / Connexion')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Adresse e-mail'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Mot de passe'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: navigateToAuthScreen,
              child: Text('S\'enregistrer / se connecter'),
            ),
          ],
        ),
      ),
    );
  }
}