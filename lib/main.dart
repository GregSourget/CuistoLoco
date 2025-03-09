import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: 'https://ljllotbxnlujooyxbtls.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxqbGxvdGJ4bmx1am9veXhidGxzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDA1NzQ5NjUsImV4cCI6MjA1NjE1MDk2NX0.KAq_VXkMlLOMhrIIfBr-A6kGt317jTFzUxL-58mNOP4',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AuthScreen(),

    );
  }
}