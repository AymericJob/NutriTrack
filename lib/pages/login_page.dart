import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page de Connexion'),
      ),
      body: Center(
        child: Text(
          'Bienvenue sur la page de connexion!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
