import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String? email;
  String? phone;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Récupérer les données de l'utilisateur connecté
  Future<void> _fetchUserData() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      try {
        // Récupérer l'email et le téléphone
        final response = await Supabase.instance.client
            .from('profiles')
            .select('phone')
            .eq('id', user.id)
            .single()
            .maybeSingle();

        setState(() {
          email = user.email;
          phone = response?['phone'] ?? 'Numéro de téléphone non disponible';
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          email = 'Email non disponible';
          phone = 'Numéro de téléphone non disponible';
          isLoading = false;
        });
      }
    } else {
      setState(() {
        email = 'Utilisateur non connecté';
        phone = 'Numéro de téléphone non disponible';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Compte'),
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Affichage du loading
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Align(
          alignment: Alignment.topLeft,  // Alignement à gauche
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Adresse e-mail : $email',
                style: TextStyle(
                  fontSize: 20, // Taille de la police de l'email
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Numéro de téléphone : $phone',
                style: TextStyle(
                  fontSize: 20, // Taille de la police du téléphone
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
