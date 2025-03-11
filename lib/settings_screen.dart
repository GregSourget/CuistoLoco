import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paramètres'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Text('Paramètres de l\'application.'),
      ),
    );
  }
}
