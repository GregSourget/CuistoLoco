import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Panier')),
      body: Center(
        child: Text('Votre panier est vide.'),
      ),
    );
  }
}
