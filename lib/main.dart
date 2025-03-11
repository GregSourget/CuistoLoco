import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'bottom_navigation.dart';
import 'register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['SB_URL'] ?? '',
    anonKey: dotenv.env['ANON_KEY'] ?? '',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(
          primary: Colors.teal, // Couleur primaire personnalisée
          secondary: Colors.amber, // Couleur d'accentuation personnalisée
        ),
        scaffoldBackgroundColor: Colors.black, // Couleur de fond des écrans
        appBarTheme: AppBarTheme(
          color: Colors.teal, // Couleur de la barre d'application
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.amber, // Couleur des boutons
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: RegisterScreen(),
      routes: {
        '/home': (context) => BottomNavigation(),
      },
    );
  }
}
