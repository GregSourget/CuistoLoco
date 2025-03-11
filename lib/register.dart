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

    // Vérifiez que l'email et le mot de passe sont valides
    if (email.isNotEmpty && isValidEmail(email) && password.isNotEmpty && isValidPassword(password)) {
      // Naviguer vers l'écran d'authentification
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AuthScreen(email: email, password: password),
        ),
      );
    } else {
      // Afficher un message d'erreur si les champs sont vides ou incorrects
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erreur'),
          content: Text('Veuillez remplir tous les champs correctement (mdp > 6 caractères).'),
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Adresse e-mail'),
              ),
              SizedBox(height: 30), // Espace entre les champs de texte
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Mot de passe'),
                obscureText: true,
              ),
              SizedBox(height: 60), // Espace de 50 pixels entre le champ de texte et le bouton
              ElevatedButton(
                onPressed: navigateToAuthScreen,
                child: Text('S\'enregistrer / se connecter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
