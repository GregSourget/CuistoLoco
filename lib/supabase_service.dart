import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> createAccount(String email, String password) async {
  final response = await Supabase.instance.client.auth.signUp(
    email: email,
    password: password,
  );
  if (response.error == null) {
    // Compte créé   avec succès
  } else {
    // Erreur lors de la création du compte
  }
}
